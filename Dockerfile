FROM php:8.1-fpm-alpine

ENV \
    PHP_MEMORY_LIMIT=-1 \
    PHP_UPLOAD_MAX_FILESIZE=2G \
    PHP_POST_MAX_SIZE=2G

RUN apk add --no-cache \
        git \
        bash \
        openssh \
        curl \
        py-pip \
        icu icu-dev \
        libxml2 libxml2-dev \
        libzip libzip-dev \
        $PHPIZE_DEPS \
    && docker-php-ext-install \
        intl \
        pdo_mysql \
        pcntl \
        xml \
        pdo \
        opcache \
        bcmath \
        zip \
    && pecl install xdebug \
    && docker-php-ext-enable \
        xdebug

RUN pip install --no-cache-dir awscli-local[v1]

RUN apk del \
        icu-dev \
        libxml2-dev \
        libzip-dev \
        $PHPIZE_DEPS \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Set working directory
WORKDIR /var/www
