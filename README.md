# Node.js docker container image

[![Build Status](https://github.com/wodby/node/workflows/Build%20docker%20image/badge.svg)](https://github.com/wodby/node/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/node.svg)](https://hub.docker.com/r/wodby/node)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/node.svg)](https://hub.docker.com/r/wodby/node)

## Docker Images

❗️For better reliability we release images with stability tags (`wodby/node:18-X.X.X`) which correspond to [git tags](https://github.com/wodby/node/releases). We strongly recommend using images only with stability tags. 

Overview:

- All images based on Alpine Linux
- Base image: [node](https://hub.docker.com/r/_/node/)
- [GitHub actions builds](https://github.com/wodby/node/actions) 
- [Docker Hub](https://hub.docker.com/r/wodby/node)

Supported tags and respective `Dockerfile` links:

- `18.12`, `18`, `latest` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `16.18`, `16` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `14.20`, `14` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `18.4-dev`, `18-dev`, `dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `16.9-dev`, `16-dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `14.5-dev`, `14-dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)

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
