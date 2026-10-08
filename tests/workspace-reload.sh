#!/usr/bin/env bash
# HTTP refresh smoke test with a separate container writing the shared checkout.
# This does not substitute for cross-node NFS and browser/WebSocket acceptance.
set -euo pipefail
volume="workspace-contract-smoke-$$"
server="workspace-contract-server-$$"
results=$(mktemp -d)
docker volume create "$volume" >/dev/null
cleanup() { docker rm -f "$server" >/dev/null 2>&1 || true; docker volume rm "$volume" >/dev/null; rm -rf "$results"; }
trap cleanup EXIT
image="${IMAGE:?Set IMAGE to the candidate Node development image}"
docker run --rm --user 0 --entrypoint sh -v "$volume:/fixture" "$image" -ec '
cd /fixture
printf "{\"name\":\"workspace-smoke\",\"private\":true}" > package.json
npm install --no-audit --no-fund --package-lock=false next@16.3.6 react@19.2.4 react-dom@19.2.4 vite@8.3.0
mkdir pages
printf "export default function Page(){return <div>before-edit</div>}" > pages/index.jsx
printf "<script type=\"module\" src=\"/main.js\"></script>" > index.html
printf "document.body.textContent=\"before-edit\";" > main.js
chown -R node:node /fixture
'
for framework in vite next; do
 docker run -d --name "$server" --network none --entrypoint /usr/local/bin/workspace-node -e APP_ROOT=/fixture -e NEXT_TELEMETRY_DISABLED=1 -v "$volume:/fixture" "$image" "$framework-start" >/dev/null
 ready=0
 for i in $(seq 1 40); do
  if docker exec "$server" curl -fs http://localhost:3000/ > "$results/response"; then ready=1;break;fi
  sleep 1
 done
 if [ "$ready" != 1 ]; then docker logs "$server";exit 1;fi
 if [ "$framework" = vite ]; then
  docker exec "$server" curl -fsS http://localhost:3000/main.js | grep -q before-edit
  docker run --rm --network none --entrypoint sh -v "$volume:/fixture" "$image" -ec 'printf "document.body.textContent=\"after-edit\";" > /fixture/main.js'
  url=http://localhost:3000/main.js
 else
  grep -q before-edit "$results/response"
  docker run --rm --network none --entrypoint sh -v "$volume:/fixture" "$image" -ec 'printf "export default function Page(){return <div>after-edit</div>}" > /fixture/pages/index.jsx'
  url=http://localhost:3000/
 fi
 changed=0
 for i in $(seq 1 30); do
  if docker exec "$server" curl -fsS "$url" | grep after-edit >/dev/null; then changed=1;break;fi
  sleep 1
 done
 if [ "$changed" != 1 ]; then docker logs "$server";exit 1;fi
 docker logs "$server" > "$results/$framework.log" 2>&1
 docker rm -f "$server" >/dev/null
 echo "$framework: second-container edit appeared in HTTP response"
done

# A package with only a start script runs its application once, so workspace-node restarts it
# when the checkout changes: a second container's edit is served by the same container.
docker run --rm --user 0 --entrypoint sh -v "$volume:/fixture" "$image" -ec '
mkdir /fixture/plain
cd /fixture/plain
printf "{\"name\":\"plain\",\"private\":true,\"scripts\":{\"start\":\"node server.js\"}}" > package.json
cat > server.js <<JS
const http = require("http");
http.createServer((req, res) => {
  if (req.url === "/exit") process.exit(7);
  res.end("before-edit");
}).listen(process.env.PORT);
JS
chown -R node:node /fixture/plain
'
plain() { docker run -d --name "$server" --network none --entrypoint /usr/local/bin/workspace-node -e APP_ROOT=/fixture/plain -e WORKSPACE_POLL_INTERVAL=500 "$@" -v "$volume:/fixture" "$image" start >/dev/null; }
edit() { docker run --rm --network none --entrypoint sh -v "$volume:/fixture" "$image" -ec "sed -i 's/$1/$2/' /fixture/plain/server.js"; }
serves() {
 for i in $(seq 1 40); do
  if [ "$(docker exec "$server" curl -fsS http://localhost:3000/ 2>/dev/null || true)" = "$1" ]; then return 0; fi
  sleep 1
 done
 echo "never answered $1" >&2; docker logs "$server" >&2; exit 1
}
plain
serves before-edit
first=$(docker inspect -f '{{.State.StartedAt}}' "$server")
edit before-edit after-edit
serves after-edit
test "$(docker inspect -f '{{.State.StartedAt}} {{.RestartCount}}' "$server")" = "$first 0"
# The application the package manager started is gone with it: one server listens, not two.
test "$(docker exec "$server" pgrep -f '^node server\.js$' | wc -l | tr -d ' ')" = 1
echo "start script: second-container edit restarted the application in the same container"

# Stopping the container stops the application at once.
began=$(date +%s)
docker stop -t 30 "$server" >/dev/null
test $(( $(date +%s) - began )) -lt 10
test "$(docker inspect -f '{{.State.ExitCode}}' "$server")" = 143
docker rm -f "$server" >/dev/null
echo "start script: stopping the container stopped the application"

# An application that ends by itself ends the container with its exit code.
plain
serves after-edit
docker exec "$server" curl -s http://localhost:3000/exit >/dev/null || true
for i in $(seq 1 20); do
 [ "$(docker inspect -f '{{.State.Running}}' "$server")" = false ] && break
 sleep 1
done
test "$(docker inspect -f '{{.State.Running}} {{.State.ExitCode}}' "$server")" = 'false 7'
docker rm -f "$server" >/dev/null
echo "start script: an application that ended took the container with it"

# WORKSPACE_NODE_WATCH=0 runs the script as before, and a dev script is never wrapped.
plain -e WORKSPACE_NODE_WATCH=0
serves after-edit
edit after-edit unwatched
sleep 5
test "$(docker exec "$server" curl -fsS http://localhost:3000/)" = after-edit
docker rm -f "$server" >/dev/null
docker run --rm --network none --entrypoint sh -v "$volume:/fixture" "$image" -ec 'cd /fixture/plain && sed -i "s/\"start\":/\"dev\":/" package.json'
plain
serves unwatched
edit unwatched dev-edit
sleep 5
test "$(docker exec "$server" curl -fsS http://localhost:3000/)" = unwatched
docker rm -f "$server" >/dev/null
echo "start script: no watcher with WORKSPACE_NODE_WATCH=0 or for a dev script"
