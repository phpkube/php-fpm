FROM php:fpm

RUN adduser --quiet --gecos "phpkube,phpkube,0,0" --disabled-password --home /home/phpkube phpkube && bash -c 'mkdir -p /home/phpkube/{html}' \
&& chown -Rf phpkube:phpkube /home/phpkube

RUN pecl install redis-5.1.1 \
    && pecl install xdebug-2.8.1 \
    && docker-php-ext-enable redis xdebug

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN pecl install mongodb \
    && docker-php-ext-enable mongodb

WORKDIR /home/phpkube/html

USER phpkube:phpkube

EXPOSE 9000