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
test -e "$fixture/node_modules/dev-tool/package.json"
workspace-node prepare
test -e "$fixture/node_modules/dev-tool/package.json"
WODBY_WORKSPACE=1 /docker-entrypoint.sh node | grep -q development:3000
WODBY_WORKSPACE=1 WODBY_WORKSPACE_COMMAND='printf custom-command' /docker-entrypoint.sh node | grep -q custom-command
/docker-entrypoint.sh node -e 'console.log("standard-command")' | grep -q standard-command
cat > "$fixture/package.json" <<'JSON'
{"scripts":{"start":"node check.js"}}
JSON
workspace-node start | grep -q development:3000
printf '{}' > "$fixture/package.json"
if workspace-node start > "$fixture/error" 2>&1; then exit 1; fi
grep -q 'Define a dev/start' "$fixture/error"
