# Node.js docker container image

[![Build Status](https://github.com/wodby/node/workflows/Build%20docker%20image/badge.svg)](https://github.com/wodby/node/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/node.svg)](https://hub.docker.com/r/wodby/node)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/node.svg)](https://hub.docker.com/r/wodby/node)

## Docker Images

Use image revision tags such as `wodby/node:26-rN` to select a Wodby image revision.
Major and minor tags use the repository release number, starting at `r0`. Full-version tags such as
`wodby/node:26.9.0-r0` start at `r0` for each exact upstream version.
Every published versioned revision tag has a matching annotated Git tag pointing to its release commit.
Existing tags remain available after support for their major or minor version ends.
See [release tags](https://github.com/wodby/node/tags) for available revisions and the [image revision policy](https://github.com/wodby/images#image-revisions) for upgrade guidance.
Previously published image tags remain available.

Overview:

- All images based on Alpine Linux
- Base image: [node](https://hub.docker.com/r/_/node/)
- [GitHub actions builds](https://github.com/wodby/node/actions)
- [Docker Hub](https://hub.docker.com/r/wodby/node)

Supported tags and respective `Dockerfile` links:

- `26.10`, `26`, `latest` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `24.21`, `24`, [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `22.23`, `22` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `26.10-dev`, `26-dev`, `dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `24.21-dev`, `24-dev`, [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `22.23-dev`, `22-dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)

Images with `-dev` tag have dev packages and `sudo` allowed for all commands for `wodby` user.

All images built for `linux/amd64` and `linux/arm64`

## Environment variables

| Variable    | Default Value | Description            |
|-------------|---------------|------------------------|
| `NODE_PORT` | `3000`        | Used for health checks |

## Orchestration actions

Usage:

```
make COMMAND [params ...]

commands:
    check-ready [host max_try wait_seconds delay_seconds]
 
default params values:
    host localhost
    max_try 1
    wait_seconds 1
    delay_seconds 0
```

## Building with pinned base images

Build with the Makefile to use the base image digests in `base-images.mk`. Local
builds and CI resolve the same version and variant to the same multi-platform
image. A version without a pin fails before the build starts.

When adding a supported base version or variant, add its image index digest to
`base-images.mk`. For a custom build, override `BASE_IMAGE` with a complete
`repository:tag@sha256:...` reference.

### Workspace image contract

Development variants declare `com.wodby.workspace.contract=1`; ordinary variants
leave it empty. The contract covers SSH/tool availability, workspace startup and
preparation, and login-shell tool discovery. CI checks the label and runtime tools.

`workspace-node` enables Chokidar and Watchpack polling at 1000 ms for shared
volumes. Set `WORKSPACE_POLL_INTERVAL` (100–60000 ms) to tune the cost, or
`WORKSPACE_POLLING=0` to disable these defaults. Explicit watcher variables
are preserved. This does not enable watching in scripts that have no watcher.
Keep dependencies/build output excluded in project watcher configuration.

`workspace-node next-start` starts the installed Next.js CLI with Webpack polling
(adding `--webpack` on Next 16+), using `HOST` and `PORT`. It does not run custom
package lifecycle scripts; use `WORKSPACE_NODE_COMMAND` for a custom command with
its own shared-volume watcher configuration. Angular requires `ng serve --poll 1000`.
Vite's Chokidar watcher uses the polling environment; other watcher engines need
explicit project configuration such as `server.watch.usePolling: true`.

Preparation without an npm lockfile uses `--package-lock=false`. Dependency lifecycle
scripts remain project-owned and may change files; review their changes before committing.

Use `workspace-node vite-start` for React/Vue Vite projects: it loads the existing
Vite config and enables both Chokidar and Rolldown polling in memory. Use
`workspace-node angular-start` for Angular's CLI polling. These helpers call the
framework directly, so custom package lifecycle scripts require a custom command.
