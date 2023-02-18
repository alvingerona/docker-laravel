#!/bin/sh

chown -R www-data:www-data /var/www/html/storage

php artisan migrate --force
php artisan db:seed

STORAGE_DIR="public/storage"
if [ -d "$STORAGE_DIR" ]; then
  ### Take action if $DIR exists ###
  echo "Installing config files in ${STORAGE_DIR}..."
else
  ###  Control will jump here if $DIR does NOT exists ###
  php artisan storage:link
  exit 1
fi

# mkdir /var/log/php-fpm
nginx
php-fpm -F