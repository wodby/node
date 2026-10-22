# Base image inputs shared by local builds and CI. Updated by wodby/images.
# Each digest identifies the complete multi-platform image index.
BASE_IMAGE_REPOSITORY := node
BASE_IMAGE_VERSION_SUFFIX := -alpine

BASE_IMAGE_DIGEST_22.23.4-alpine := sha256:ebc216c22db53dbde85719a874978d5aec04e6e405ad26a3804c6f9abc4ca1a9
BASE_IMAGE_DIGEST_24.22.1-alpine := sha256:feb76650b7195319268c59cb2d419c732d6c499b13bf5296f16ab59eb1f0a4f3
BASE_IMAGE_DIGEST_26.12.1-alpine := sha256:ae8e1c19d56886270987e99b3cfcef13a919f0655b376ae322bc64ada76f88cd

# Fail before building when a version or variant has no reviewed pin.
BASE_IMAGE = $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG)@$(or $(BASE_IMAGE_DIGEST_$(BASE_IMAGE_TAG)),$(error No base image digest for $(BASE_IMAGE_REPOSITORY):$(BASE_IMAGE_TAG); update base-images.mk))
