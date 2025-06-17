#!/bin/bash

# Обновляем список пакетов и все пакеты
sudo apt-get update -y
sudo apt-get upgrade -y

# Проверяем, что каталог SSH существует, и установлены соответствующие разрешения
mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh