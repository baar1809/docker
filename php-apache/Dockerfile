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
    pdo_pgsql && \
    pecl install redis apcu && \
    docker-php-ext-enable redis apcu

# Install Xdebug
RUN pecl install xdebug-2.7.2 \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > $PHP_INI_DIR/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> $PHP_INI_DIR/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> $PHP_INI_DIR/conf.d/xdebug.ini

# Apache configuration
ENV APACHE_DOCUMENT_ROOT /var/www
ENV APACHE_RUN_USER #1000
ENV APACHE_RUN_GROUP #1000
RUN a2enmod rewrite headers expires 
#    sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
#    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
#  && sed -i "/DocumentRoot \/var\/www\/html/c\\\tDocumentRoot \$\{APACHE_DOCROOT\}" /etc/apache2/sites-enabled/000-default.conf
COPY vhost.conf /etc/apache2/sites-enabled/vhost.conf

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Change default work directory
WORKDIR /var/www
