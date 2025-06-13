#!/bin/bash

# Установливаем разрешения для private key
chmod 600 /home/vagrant/.ssh/id_rsa
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa

# Создаём конфигурацию SSH 
echo -e "Host server\n\tHostName 192.168.56.10\n\tUser vagrant\n\tIdentityFile ~/.ssh/id_rsa" > /home/vagrant/.ssh/config
chmod 600 /home/vagrant/.ssh/config
chown vagrant:vagrant /home/vagrant/.ssh/config