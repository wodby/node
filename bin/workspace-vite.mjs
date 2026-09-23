#!/usr/bin/env node
// Load the project's own Vite configuration, then enable shared-volume polling
// for both Chokidar and Rolldown without writing a generated config into Git.
import { createRequire } from 'node:module';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
const require = createRequire(join(process.cwd(), 'package.json'));
const { createServer, loadConfigFromFile, mergeConfig } = await import(pathToFileURL(require.resolve('vite')).href);
const configEnv = { command: 'serve', mode: process.env.WORKSPACE_VITE_MODE || 'development', isSsrBuild: false, isPreview: false };
const loaded = await loadConfigFromFile(configEnv);
const interval = Number(process.env.WORKSPACE_POLL_INTERVAL || 1000);
const polling = process.env.WORKSPACE_POLLING !== '0';
const server = await createServer(mergeConfig(loaded?.config || {}, {
  configFile: false,
  mode: configEnv.mode,
  server: {
    host: process.env.HOST,
    port: Number(process.env.PORT),
    strictPort: true,
    watch: { usePolling: polling, interval, pollInterval: interval },
  },
}));
await server.listen();
server.printUrls();
for (const signal of ['SIGTERM', 'SIGINT']) {
  process.once(signal, async () => { await server.close(); process.exit(0); });
}
