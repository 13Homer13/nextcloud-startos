FROM nextcloud:27.0.0-fpm-alpine

# arm64 or amd64
ARG PLATFORM

# Install additional dependencies
RUN apk add --no-cache \
    sudo \
    bash \
    postgresql15 \
    postgresql15-client \
    # exiftool \
    # ffmpeg \
    yq \
    # imagemagick \
    # supervisor \
    # libreoffice \
;

# # Set environment variables
ENV NEXTCLOUD_VERSION 27.0.0

ENV POSTGRES_DB nextcloud
ENV POSTGRES_USER nextcloud
ENV POSTGRES_PASSWORD nextclouddbpassword
ENV POSTGRES_HOST localhost
ENV EXISTING_DB false

ENV PHP_MEMORY_LIMIT 4096M
ENV PHP_UPLOAD_LIMIT 20480M

RUN mkdir -p /run/postgresql
RUN chown postgres:postgres /run/postgresql

# Import Entrypoint and Actions scripts and give permissions
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
ADD ./check-web.sh /usr/local/bin/check-web.sh
ADD actions/reset-pass.sh /usr/local/bin/reset-pass.sh
ADD actions/disable-maintenance-mode.sh /usr/local/bin/disable-maintenance-mode.sh
ADD actions/index-memories.sh /usr/local/bin/index-memories.sh
ADD actions/places-setup.sh /usr/local/bin/places-setup.sh
ADD actions/download-models.sh /usr/local/bin/download-models.sh
RUN chmod a+x /usr/local/bin/*.sh
