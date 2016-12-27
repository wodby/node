FROM node:7.3-alpine
MAINTAINER Wodby <admin@wodby.com>

ARG WWW_DATA_UID=82
ARG WWW_DATA_GID=82

# Install packages
RUN apk add --no-cache bash

# Create user www-data
RUN addgroup -g $WWW_DATA_GID -S www-data && \
	adduser -u $WWW_DATA_UID -D -S -G www-data www-data

# Create work dir
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www

WORKDIR /var/www/html
VOLUME /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/
CMD docker-entrypoint.sh

# Install node packages
#RUN npm install --global gulp-cli grunt webpack
