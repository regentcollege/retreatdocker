FROM php:8.2-apache

RUN apt-get update && \
    apt-get install -y vim \
    curl \
    unzip \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
	libldap2-dev&& \
    rm -rf /var/lib/apt/lists/* 
	
RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl

RUN docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
    
# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir /var/www/retreat && chown www-data: /var/www/retreat -R && \
    chmod 0755 /var/www/retreat -R
	
COPY ./config/retreat.conf /etc/apache2/sites-available/retreat.conf
RUN mkdir -p /var/www/retreat/current

RUN a2ensite retreat.conf && a2dissite 000-default.conf && a2enmod rewrite

WORKDIR /var/www/retreat

EXPOSE 80

CMD ["apache2-foreground"]

