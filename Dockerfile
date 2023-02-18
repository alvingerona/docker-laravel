FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
    nginx \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    zip \
    unzip \
    git \
    cron

# RUN docker-php-ext-install pgsql
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql mbstring exif pcntl bcmath gd zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./deploy/nginx/conf.d /etc/nginx/sites-available/

COPY . /var/www/html

# Set working directory
WORKDIR /var/www/html

# Install composer dependencies
RUN composer install --no-dev --verbose

RUN chown -R www-data:www-data /var/www/html/storage

COPY init.sh /opt
RUN chmod +x /opt/init.sh

CMD ["/opt/init.sh"]