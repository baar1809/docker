FROM php:7.0-apache

MAINTAINER Roman Zakharov <zkhvroman@github.com>

ENV DEBIAN_FRONTEND noninteractive

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install php extension
RUN pecl install -o -f redis-5.3.4 xdebug-2.7.0 \
    && rm -rf /tmp/pear

RUN apt-get update \
    && apt-get install -yqq iproute2 iputils-ping libpq-dev libzip-dev zip \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install pdo_pgsql exif zip \
    && docker-php-ext-enable pdo_pgsql redis xdebug exif zip \
    && rm -rf /var/lib/apt/lists/*

# Set php setup
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

COPY ./php/conf.d /usr/local/etc/php/conf.d

COPY ./entrypoint.sh /usr/local/bin/docker-php-entrypoint
RUN chmod +x /usr/local/bin/docker-php-entrypoint

# Configurate apache
RUN a2enmod rewrite headers
COPY vhost.conf /etc/apache2/sites-enabled/vhost.conf

# Add non-root user
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

RUN groupmod -o -g ${PGID} www-data && \
    usermod -o -u ${PUID} -g www-data www-data

# Change default work directory
WORKDIR /var/www