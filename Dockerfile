FROM php:7.2.14-fpm

LABEL maintainer="Leo Vujanić <leonard.vujanic@gmail.com>"

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    zlib1g-dev \
    libicu-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --version \
    && docker-php-ext-install pdo \
    && docker-php-ext-install opcache \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

COPY custom.ini /usr/local/etc/php/conf.d/custom.ini

RUN mkdir -p /var/app/cache/ && mkdir -p /var/app/log/ && mkdir -p /var/app/sessions \
    && chown -R www-data:www-data /var/app/log \
    && chown -R www-data:www-data /var/app/cache \
    && chown -R www-data:www-data /var/app/sessions

USER www-data

WORKDIR /var/www/app
