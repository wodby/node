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
