FROM node:7.3-alpine
MAINTAINER Wodby <admin@wodby.com>

# Install packages
RUN apk add --no-cache bash

# Create user www-data
RUN adduser -D -s /bin/bash -u 82 www-data

# Create work dir
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www

WORKDIR /var/www/html
VOLUME /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/
CMD docker-entrypoint.sh

# Install node packages
RUN npm install --global gulp gulp-cli grunt webpack
