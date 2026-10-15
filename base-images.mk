# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := node
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_22.23.3-alpine := sha256:0a7108bf6c7bf5de370ffb1a3ed6be93d405b43ff159f681a8d18c0e2bc2e402
BASE_IMAGE_DIGEST_24.22.0-alpine := sha256:44fce696f38ba8c987c4db89954051000bbd05ffd8d8659ba15ed4a8602e937f
BASE_IMAGE_DIGEST_26.12.0-alpine := sha256:6f08a523443ddedf52941874c203475b0ad503e859ad70cb26ab8be9a517dbd5

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
