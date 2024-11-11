# Use official Ubuntu 24.10 base image
FROM ubuntu:24.10

# Set environment variables
ENV PHP_MEMORY_LIMIT=256M
ENV MATOMO_VERSION=5.1.2

# Install system dependencies and PHP dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    ca-certificates \
    git \
    unzip \
    libicu-dev \
    libjpeg-dev \
    libpng-dev \
    libzip-dev \
    libldap2-dev \
    libfreetype6-dev \
    procps \
    php-cli \
    php-fpm \
    php-curl \   
    php-gd \
    php-bcmath \
    php-mysqli \
    php-opcache \
    php-pdo-mysql \
    php-zip \
    php-intl \
    php-ldap \
    php-pear \
    php-dev \
    && apt-get clean

# Install Composer globally (corrected)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clone the Matomo repository (instead of fetching it, we clone it directly)
WORKDIR /var/www
RUN git clone https://github.com/matomo-org/matomo.git

# Go into the Matomo directory
WORKDIR /var/www/matomo

# Install Matomo's PHP dependencies using Composer
RUN /usr/local/bin/composer install --no-dev --optimize-autoloader

# Set permissions for the Matomo directory
RUN chown -R www-data:www-data /var/www/matomo && \
    chmod -R 755 /var/www/matomo

# Expose port 80 (the port for the built-in PHP server)
EXPOSE 80

# Start PHP's built-in server (no need for Nginx)
CMD php -S 0.0.0.0:80 -t /var/www/matomo
