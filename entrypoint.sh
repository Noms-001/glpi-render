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

# # Générer config_db.php si absent
# if [ ! -f /var/www/html/config/config_db.php ]; then

# cat > /var/www/html/config/config_db.php <<EOF
# <?php
# class DB extends DBmysql {

#    public \$dbhost     = '${DB_HOST}';
#    public \$dbport     = '${DB_PORT}';
#    public \$dbdefault  = '${DB_NAME}';
#    public \$dbuser     = '${DB_USER}';
#    public \$dbpassword = '${DB_PASSWORD}';

# }
# EOF

# echo "config_db.php créé."

# fi

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

exec apache2-foreground