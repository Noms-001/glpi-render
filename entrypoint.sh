#!/bin/bash
set -e

mkdir -p /var/www/html/files
mkdir -p /var/www/html/config
mkdir -p /var/www/html/marketplace

chown -R www-data:www-data /var/www/html

exec apache2-foreground