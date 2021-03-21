ARG PHP_VERSION
FROM php:${PHP_VERSION}-apache

MAINTAINER Roman Zakharov <zkhvroman@github.com>

# Set timezone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add user
ENV GID 1000
ENV UID 1000
RUN groupadd -g ${GID} developer && \
    useradd -u ${UID} -g developer -m developer -G root,www-data && \
    usermod -p "*" developer -s /bin/bash && \
    usermod -aG www-data developer

# Installing basic packages and programs
RUN apt-get update && \
    apt-get install -y \
    apt-utils \
    apt-transport-https \
    curl \
    vim \
    git \
    build-essential \    
    wget \
    zip \
    unzip \
    bzip2 \
    libzip-dev \
    libbz2-dev \
    libfontconfig \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libxml2-dev \
    libmcrypt-dev \
    libpq-dev \
    g++

# Install Node (with NPM)
ARG NODE_VERSION
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -
RUN apt-get update && \
    apt-get install -y nodejs
    
# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Install additional php extensions
RUN docker-php-ext-install \
    gd \
    bz2 \
    zip \
    intl \
    iconv \
    bcmath \
    opcache \
    calendar \
    mbstring \
    pgsql \
    pdo_pgsql


# Apache configuration
ENV APACHE_DOCUMENT_ROOT /var/www
ENV APACHE_RUN_USER #1000
ENV APACHE_RUN_GROUP #1000
RUN a2enmod rewrite headers expires 


COPY vhost.conf /etc/apache2/sites-enabled/vhost.conf

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Change default work directory
WORKDIR /var/www
