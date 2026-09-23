#!/bin/sh
# Verify command selection, development dependencies and unchanged standard CMD.
set -eu
fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT
export APP_ROOT="$fixture" NODE_ENV=production
mkdir -p "$fixture/dev-tool"
printf '{"name":"dev-tool","version":"1.0.0"}' > "$fixture/dev-tool/package.json"
cat > "$fixture/package.json" <<'JSON'
{"scripts":{"dev":"node check.js","start":"node missing.js"},"devDependencies":{"dev-tool":"file:./dev-tool"}}
JSON
printf 'console.log(process.env.NODE_ENV + ":" + process.env.PORT)\n' > "$fixture/check.js"
workspace-node prepare
test ! -e "$fixture/package-lock.json"
test -e "$fixture/node_modules/dev-tool/package.json"
workspace-node prepare
test -e "$fixture/node_modules/dev-tool/package.json"
WODBY_WORKSPACE=1 /docker-entrypoint.sh node | grep -q development:3000
WODBY_WORKSPACE=1 WORKSPACE_NODE_COMMAND='printf custom-command' /docker-entrypoint.sh node | grep -q custom-command
/docker-entrypoint.sh node -e 'console.log("standard-command")' | grep -q standard-command
cat > "$fixture/package.json" <<'JSON'
{"scripts":{"start":"node check.js"}}
JSON
workspace-node start | grep -q development:3000
printf '{}' > "$fixture/package.json"
if workspace-node start > "$fixture/error" 2>&1; then exit 1; fi
grep -q 'Define a dev/start' "$fixture/error"

# Polling reaches custom/project commands without rewriting project files.
WORKSPACE_NODE_COMMAND='printf "%s:%s" "$CHOKIDAR_USEPOLLING" "$WATCHPACK_POLLING"' workspace-node start | grep -q true:1000
WORKSPACE_POLL_INTERVAL=2000 WORKSPACE_NODE_COMMAND='printf "%s" "$WATCHPACK_POLLING"' workspace-node start | grep -q 2000
if WORKSPACE_POLL_INTERVAL=invalid workspace-node start > "$fixture/error" 2>&1; then exit 1; fi
mkdir -p "$fixture/node_modules/next/dist/bin"
printf '{"version":"16.0.0"}' > "$fixture/node_modules/next/package.json"
printf 'console.log(process.argv.slice(2).join(" "))' > "$fixture/node_modules/next/dist/bin/next"
workspace-node next-start | grep -q 'dev --webpack --hostname 0.0.0.0 --port 3000'
printf '{"version":"15.0.0"}' > "$fixture/node_modules/next/package.json"
workspace-node next-start | grep -q 'dev --hostname 0.0.0.0 --port 3000'

# A tracked lockfile is consumed without being regenerated.
printf '{"scripts":{"dev":"node check.js"}}' > "$fixture/package.json"
(cd "$fixture" && npm install --package-lock-only --ignore-scripts --no-audit --no-fund)
before=$(sha256sum "$fixture/package-lock.json")
workspace-node prepare
test "$before" = "$(sha256sum "$fixture/package-lock.json")"
mkdir -p "$fixture/node_modules/@angular/cli/bin"
printf 'console.log(process.argv.slice(2).join(" "))' > "$fixture/node_modules/@angular/cli/bin/ng.js"
workspace-node angular-start | grep -q 'serve --host 0.0.0.0 --port 3000 --poll 1000'
