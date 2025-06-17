#!/bin/bash

# Установливаем разрешения для authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys

# Отключаем аутентификацию по паролю
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Устанавливаем Mysql Сервер
sudo apt install -y Mysql rsync


#sudo mysql -u root
#ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
#FLUSH PRIVILEGES;

sudo cat > ~/mysql_backup.sh << 'EOF'
#!/bin/bash

# Конфигурация
BACKUP_DIR="/opt/mysql_backup"
MYSQL_USER="root"
MYSQL_PASSWORD="password"
DATABASES="company"
TIMESTAMP=$(date +"%F_%H-%M-%S")

# Создание директории для бэкапа
mkdir -p $BACKUP_DIR

# Создание бэкапа
mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD --databases $DATABASES > $BACKUP_DIR/mysql_backup_$TIMESTAMP.sql

# Удаление старых бэкапов (старше 7 дней)
find $BACKUP_DIR -type f -name "*.sql" -mtime +7 -exec rm {} \;

echo "Бэкап MySQL завершен: $BACKUP_DIR/mysql_backup_$TIMESTAMP.sql"
EOF


sudo cp ~/mysql_backup.sh /opt/

sudo cat > ~/rsyncd.conf << 'EOF'
[mysql_backup]
path = /opt/mysql_backup
comment = MySQL backups
read only = yes
list = yes
auth users = backup
secrets file = /etc/rsyncd.secrets
EOF

sudo cp ~/rsyncd.conf /etc/