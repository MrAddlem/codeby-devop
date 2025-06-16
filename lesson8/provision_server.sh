#!/bin/bash

# Обновление системы
apt-get update
apt-get upgrade -y

# Установка Apache и OpenSSL
apt-get install -y apache2 openssl

# Создаем папку для SSL сертификатов
mkdir -p /etc/apache2/ssl

# Генерируем self-signed SSL сертификат для svt.local
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/apache2/ssl/svt.local.key \
  -out /etc/apache2/ssl/svt.local.crt \
  -subj "/C=US/ST=State/L=City/O=Company/CN=svt.local"

# Создаем конфигурационный файл для svt.local
cat > /etc/apache2/sites-available/svt.local.conf <<EOF
<VirtualHost *:80>
    ServerName www.svt.local
    ServerAlias svt.local
    Redirect permanent / https://svt.local/
</VirtualHost>

<VirtualHost *:443>
    ServerName svt.local
    ServerAlias www.svt.local
    Redirect permanent / https://svt.local/

    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/svt.local.crt
    SSLCertificateKeyFile /etc/apache2/ssl/svt.local.key

    DocumentRoot /var/www/html

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

<VirtualHost *:443>
    ServerName svt.local
    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/svt.local.crt
    SSLCertificateKeyFile /etc/apache2/ssl/svt.local.key

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Активируем SSL модуль и наш сайт
a2enmod ssl
a2ensite svt.local.conf
a2dissite 000-default.conf

# Перезапускаем Apache
systemctl restart apache2