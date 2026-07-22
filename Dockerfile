FROM php:8.2-apache

# Installation des dépendances système
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libicu-dev \
    libzip-dev \
    libldap2-dev \
    libonig-dev \
    libxml2-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    unzip \
    git \
    curl \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Configuration GD
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg

# Installation des extensions PHP nécessaires à GLPI
RUN docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    intl \
    gd \
    zip \
    ldap \
    opcache \
    bz2 \
    exif \
    soap \
    bcmath \
    mbstring \
    fileinfo

# Activation des modules Apache
RUN a2enmod rewrite headers expires

# Télécharger GLPI 11
RUN curl -L https://github.com/glpi-project/glpi/releases/download/11.0.7/glpi-11.0.7.tgz \
    -o /tmp/glpi.tgz \
    && tar -xzf /tmp/glpi.tgz -C /var/www/html --strip-components=1 \
    && rm /tmp/glpi.tgz

# Correction CORS GLPI API
RUN sed -i 's#Access-Control-Allow-Origin: \*#Access-Control-Allow-Origin: https://glpi-vue.vercel.app#g' \
    /var/www/html/src/Glpi/Api/API.php

RUN sed -i "s/withHeader('Access-Control-Allow-Origin', '\\*')/withHeader('Access-Control-Allow-Origin', 'https:\/\/glpi-vue.vercel.app')/" \
    /var/www/html/src/Glpi/Api/HL/Middleware/SecurityResponseMiddleware.php

RUN echo "RewriteBase /" > /var/www/html/public/.htaccess \
    && echo "RewriteEngine On" >> /var/www/html/public/.htaccess \
    && echo "RewriteCond %{REQUEST_FILENAME} !-f" >> /var/www/html/public/.htaccess \
    && echo "RewriteRule ^(.*)$ index.php [QSA,L]" >> /var/www/html/public/.htaccess
    
# Copier la configuration Apache
COPY glpi.conf /etc/apache2/sites-available/000-default.conf

# Permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Répertoire de travail
WORKDIR /var/www/html

EXPOSE 80

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]