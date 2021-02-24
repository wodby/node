# Node.js docker container image

[![Build Status](https://github.com/wodby/node/workflows/Build%20docker%20image/badge.svg)](https://github.com/wodby/node/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/node.svg)](https://hub.docker.com/r/wodby/node)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/node.svg)](https://hub.docker.com/r/wodby/node)
[![Docker Layers](https://images.microbadger.com/badges/image/wodby/node.svg)](https://microbadger.com/images/wodby/node)

## Docker Images

❗️For better reliability we release images with stability tags (`wodby/node:14-X.X.X`) which correspond to [git tags](https://github.com/wodby/node/releases). We strongly recommend using images only with stability tags. 

Overview:

- All images based on Alpine Linux
- Base image: [node](https://hub.docker.com/r/_/node/)
- [GitHub actions builds](https://github.com/wodby/node/actions) 
- [Docker Hub](https://hub.docker.com/r/wodby/node)

Supported tags and respective `Dockerfile` links:

- `14.16`, `14`, `latest` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `12.20`, `12` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `10.23`, `10` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `8.17`, `8` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `14.5-dev`, `14-dev`, `dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `12.13-dev`, `12-dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `10.17-dev`, `10-dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
- `8.16-dev`, `8-dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)

Images with `-dev` tag have dev packages and `sudo` allowed for all commands for `wodby` user.

## Environment variables 

| Variable     | Default Value  | Description            |
| ------------ | -------------- | ---------------------- |
| `NODE_PORT`  | `3000`         | Used for health checks |

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
