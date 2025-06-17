#!/bin/bash

# Установливаем разрешения для private key
chmod 600 /home/vagrant/.ssh/id_rsa
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa

# Создаём конфигурацию SSH 
echo -e "Host server\n\tHostName 192.168.56.10\n\tUser vagrant\n\tIdentityFile ~/.ssh/id_rsa" > /home/vagrant/.ssh/config
chmod 600 /home/vagrant/.ssh/config
chown vagrant:vagrant /home/vagrant/.ssh/config



sudo cat > ~/sync_mysql_backups.sh << 'EOF'
#!/bin/bash

RSYNC_USER="backup"
RSYNC_PASSWORD="securepassword"
SERVER_IP="192.168.56.10"  # IP сервера
BACKUP_DIR="/opt/store/mysql"

#rsync -avz --password-file=<(echo "$RSYNC_PASSWORD") $RSYNC_USER@$SERVER_IP::mysql_backup/ $BACKUP_DIR/
rsync -avz /opt/mysql_backup/ vagrant@192.168.56.11:/opt/store/mysql/

EOF

sudo cp ~/sync_mysql_backups.sh /opt/