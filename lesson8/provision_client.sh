#!/bin/bash

# Обновляем систему
apt-get update
apt-get upgrade -y

# Добавляем домен в /etc/hosts
echo "192.168.56.11 svt.local www.svt.local" >> /etc/hosts

# Устанавливаем пакет для работы с CA сертификатами
apt-get install -y ca-certificates

# Копируем сертификат с сервера
# Здесь мы просто создаем тот же сертификат, что и на сервере
mkdir -p /usr/local/share/ca-certificates/extra
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/svt.local.key \
  -out /usr/local/share/ca-certificates/extra/svt.local.crt \
  -subj "/C=RU/ST=Cheb/L=Cheboksary/O=HomeC/CN=svt.local"

# Обновляем хранилище сертификатов
update-ca-certificates

# Устанавливаем curl для тестирования
apt-get install -y curl

# Выводим сообщение о завершении настройки
echo "Client setup complete. You can test with:"
echo "curl -vk https://svt.local"
echo "openssl x509 -text -noout -in /usr/local/share/ca-certificates/extra/svt.local.crt"