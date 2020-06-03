# Node.js docker container image

[![Build Status](https://travis-ci.org/wodby/node.svg?branch=master)](https://travis-ci.org/wodby/node)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/node.svg)](https://hub.docker.com/r/wodby/node)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/node.svg)](https://hub.docker.com/r/wodby/node)
[![Docker Layers](https://images.microbadger.com/badges/image/wodby/node.svg)](https://microbadger.com/images/wodby/node)

## Docker Images

❗️For better reliability we release images with stability tags (`wodby/node:12-X.X.X`) which correspond to [git tags](https://github.com/wodby/node/releases). We strongly recommend using images only with stability tags. 

Overview:

* All images are based on Alpine Linux
* Base image: [node](https://hub.docker.com/r/_/node/)
* [Travis CI builds](https://travis-ci.org/wodby/node) 
* [Docker Hub](https://hub.docker.com/r/wodby/node)

Supported tags and respective `Dockerfile` links:

* `12.18`, `12`, `latest` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
* `10.20`, `10` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
* `8.17`, `8` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
* `12.13-dev`, `12-dev`, `dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
* `10.17-dev`, `10-dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)
* `8.16-dev`, `8-dev` [_(Dockerfile)_](https://github.com/wodby/node/tree/master/Dockerfile)

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
