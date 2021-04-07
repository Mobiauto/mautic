FROM php:7.4-fpm

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN apt-get update -y \
    && apt-get install -y git curl nano zip cron libmcrypt-dev libbz2-dev zlib1g-dev \
        libicu-dev libjpeg62-turbo-dev libzip-dev gnupg2 ghostscript apt-transport-https \
        libxml2-dev libc-client-dev libkrb5-dev \
    && docker-php-ext-install -j$(nproc) intl sockets pdo_mysql bcmath bz2 pcntl zip \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-source delete \
    #Others PHP Configurations
    && echo "expose_php = off" > /usr/local/etc/php/conf.d/expose_php.ini \
    && echo "log_errors = on" > /usr/local/etc/php/conf.d/log_errors.ini \
    && echo "display_errors = on" > /usr/local/etc/php/conf.d/display_errors.ini \
    && echo "memory_limit = -1" > /usr/local/etc/php/conf.d/memory_limit.ini \
    && echo "error_log = /var/log/php/php_errors.log" > /usr/local/etc/php/conf.d/error_log.ini \
    && echo "date.timezone = America/Sao_Paulo" > /usr/local/etc/php/conf.d/timezone.ini \
    && echo "cgi.fix_pathinfo = 1" > /usr/local/etc/php/conf.d/cgi.fix_pathinfo

# Install Postgres
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql pgsql

# Install Nginx
RUN apt-get install -y nginx

ADD nginx.conf /etc/nginx
ADD app.vhost /etc/nginx/conf.d

# Install Redis
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis

#CONFIGURAÇÕES DO OPCACHE
#RUN docker-php-ext-install opcache

# Allow Composer to be run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# Setup the Nodejs, NPM & Composer
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs build-essential \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Rollback Composer to V1
RUN composer self-update --1

WORKDIR /var/www/html

EXPOSE 9000 80 443

RUN mkdir /home/www-data

RUN userdel -f www-data &&\
    if getent group www-data ; then groupdel www-data; fi &&\
    groupadd -g ${GROUP_ID} www-data &&\
    useradd -l -u ${USER_ID} -g www-data www-data &&\
    install -d -m 0755 -o www-data -g www-data /home/www-data &&\
    chown --changes --silent --no-dereference --recursive \
          --from=33:33 ${USER_ID}:${GROUP_ID} \
        /home/www-data \
        /usr/local/bin/composer \
	/usr/local/sbin/php-fpm

USER root

RUN chown -R www-data:www-data /var/www/html/*
COPY run.sh /opt/
RUN chmod 755 /opt/run.sh

CMD ["/bin/bash","-c","/opt/run.sh"]
