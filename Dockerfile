FROM node:latest AS build

WORKDIR /app
COPY ./front/package*.json ./
RUN npm install

COPY ./front/ .
RUN npm run build

FROM php:8.2-apache AS production
COPY --from=build /app/dist/ /var/www/html/dist/
COPY ./back/ /var/www/

RUN apt-get update && apt-get install -y \
    zip \
    libzip-dev \
    unzip \
    git

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer update -d /var/www/
RUN composer install -d /var/www/ --no-dev --optimize-autoloader
RUN chown -R www-data:www-data /var/www/

#Install pdo_mysql extension
RUN docker-php-ext-install pdo_mysql zip

EXPOSE 80