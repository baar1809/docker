FROM php:7.0-apache

MAINTAINER Roman Zakharov <zkhvroman@github.com>

ENV DEBIAN_FRONTEND noninteractive

ENV http_proxy=${http_proxy}
ENV https_proxy=${https_proxy}
ENV no_proxy=${no_proxy}

# Install php extension
RUN pear config-set http_proxy ${http_proxy} \
    && pecl install -o -f redis-5.2. xdebug-2.7.0 \
    && rm -rf /tmp/pear

RUN apt-get update \
    && apt-get install -yqq libpq-dev libzip-dev \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install exif \
    && docker-php-ext-enable redis xdebug exif zip \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node


RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

COPY vhost.conf /etc/apache2/sites-enabled/vhost.conf

# Change default work directory
WORKDIR /var/www