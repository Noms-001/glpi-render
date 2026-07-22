#!/bin/bash
set -e

echo "Préparation de GLPI..."

# Création des dossiers
mkdir -p /var/www/html/config
mkdir -p /var/www/html/files
mkdir -p /var/www/html/files/_cache
mkdir -p /var/www/html/files/_cron
mkdir -p /var/www/html/files/_dumps
mkdir -p /var/www/html/files/_graphs
mkdir -p /var/www/html/files/_lock
mkdir -p /var/www/html/files/_log
mkdir -p /var/www/html/files/_pictures
mkdir -p /var/www/html/files/_plugins
mkdir -p /var/www/html/files/_rss
mkdir -p /var/www/html/files/_sessions
mkdir -p /var/www/html/files/_tmp
mkdir -p /var/www/html/files/_uploads
mkdir -p /var/www/html/files/_inventories
mkdir -p /var/www/html/marketplace

# Générer config_db.php si absent
if [ ! -f /var/www/html/config/config_db.php ]; then

cat > /var/www/html/config/config_db.php <<EOF
<?php
class DB extends DBmysql {

   public \$dbhost = '${DB_HOST}:${DB_PORT}';
   public \$dbuser = '${DB_USER}';
   public \$dbpassword = '${DB_PASSWORD}';
   public \$dbdefault = '${DB_NAME}';

   public \$use_utf8mb4 = true;
   public \$allow_datetime = false;
   public \$allow_signed_keys = false;

   public \$dbssl = true;
   public \$dbsslca = '/usr/local/share/ca-certificates/aiven-ca.crt';
}
EOF

echo "config_db.php créé."

fi

# Générer la clé de sécurité si elle n'existe pas
if [ ! -f /var/www/html/config/security.key ]; then
    echo "Génération de la clé de sécurité..."
    php /var/www/html/bin/console security:change_key --allow-superuser --no-interaction || true
fi

chown -R www-data:www-data /var/www/html

exec apache2-foreground