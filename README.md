# Node.js docker container image

[![Build Status](https://github.com/wodby/node/workflows/Build%20docker%20image/badge.svg)](https://github.com/wodby/node/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/node.svg)](https://hub.docker.com/r/wodby/node)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/node.svg)](https://hub.docker.com/r/wodby/node)

## Docker Images

❗️For better reliability we release images with stability tags (
`wodby/node:24-X.X.X`) which correspond to [git tags](https://github.com/wodby/node/releases). We strongly recommend using images only with stability tags.

Overview:

- All images based on Alpine Linux
- Base image: [node](https://hub.docker.com/r/_/node/)
- [GitHub actions builds](https://github.com/wodby/node/actions)
- [Docker Hub](https://hub.docker.com/r/wodby/node)

Supported tags and respective `Dockerfile` links:

- `24.8`, `24`, `latest` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `22.19`, `22` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `20.19`, `20` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `24.8-dev`, `24-dev`, `dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `22.19-dev`, `22-dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `20.19-dev`, `20-dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)

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
