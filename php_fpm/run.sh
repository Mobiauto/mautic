#!/bin/bash -x

php artisan optimize &
php-fpm &
/usr/sbin/nginx -g "daemon off;"
