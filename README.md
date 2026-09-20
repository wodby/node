# Node.js docker container image

[![Build Status](https://github.com/wodby/node/workflows/Build%20docker%20image/badge.svg)](https://github.com/wodby/node/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/node.svg)](https://hub.docker.com/r/wodby/node)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/node.svg)](https://hub.docker.com/r/wodby/node)

## Docker Images

❗️For better reliability we release images with stability tags (
`wodby/node:26-X.X.X`) which correspond to [git tags](https://github.com/wodby/node/releases). We strongly recommend using images only with stability tags.

Overview:

- All images based on Alpine Linux
- Base image: [node](https://hub.docker.com/r/_/node/)
- [GitHub actions builds](https://github.com/wodby/node/actions)
- [Docker Hub](https://hub.docker.com/r/wodby/node)

Supported tags and respective `Dockerfile` links:

- `26.9`, `26`, `latest` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `24.21`, `24`, [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `22.23`, `22` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `26.9-dev`, `26-dev`, `dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
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
