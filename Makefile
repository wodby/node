-include .env

NODE_VER ?= 18.14.0

NODE_VER_MINOR = $(shell echo "${NODE_VER}" | grep -oE '^[0-9]+\.[0-9]+')

TAG ?= $(NODE_VER_MINOR)

REPO = wodby/node
NAME = node-$(NODE_VER_MINOR)

ifneq ($(NODE_DEV),)
    NAME := $(NAME)-dev
endif

ifneq ($(NODE_DEV),)
	TAG ?= $(TAG)-dev
endif

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

PLATFORM ?= linux/amd64

.PHONY: build buildx-build buildx-build-amd64 buildx-push test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
		--build-arg NODE_VER=$(NODE_VER) \
		--build-arg NODE_DEV=$(NODE_DEV) \
		./

# --load doesn't work with multiple platforms https://github.com/docker/buildx/issues/59
# we need to save cache to run tests first.
buildx-build-amd64:
	docker buildx build --platform linux/amd64 -t $(REPO):$(TAG) \
		--build-arg NODE_VER=$(NODE_VER) \
		--build-arg NODE_DEV=$(NODE_DEV) \
		--load \
		./

buildx-build:
	docker buildx build --platform $(PLATFORM) -t $(REPO):$(TAG) \
		--build-arg NODE_VER=$(NODE_VER) \
		--build-arg NODE_DEV=$(NODE_DEV) \
		./

buildx-push:
	docker buildx build --platform $(PLATFORM) --push -t $(REPO):$(TAG) \
		--build-arg NODE_VER=$(NODE_VER) \
		--build-arg NODE_DEV=$(NODE_DEV) \
		./

test:
	IMAGE=$(REPO):$(TAG) echo "no tests :("

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push
