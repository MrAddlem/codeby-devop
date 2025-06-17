sudo touch /opt/mysql_backup.sh
sudo bash -c 'cat /opt/mysql_backup.sh << '"'"'EOF'"'"'

#!/bin/bash

# Параметры
BACKUP_DIR="/opt/mysql_backup"
MYSQL_USER="svt"
MYSQL_PASSWORD="svt123"
DATABASE_NAME="svt"
STORE_SERVER="192.168.56.20"
TIMESTAMP=$(date +"%F_%H-%M-%S")

# Создание бэкапа
mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $DATABASE_NAME > $BACKUP_DIR/$DATABASE_NAME-$TIMESTAMP.sql

# Синхронизация с store сервером
rsync -avz $BACKUP_DIR/ svt@$STORE_SERVER:/opt/store/mysql/

# Удаление старых бэкапов (старше 7 дней)
find $BACKUP_DIR -type f -name "*.sql" -mtime +7 -exec rm {} \;
EOF'