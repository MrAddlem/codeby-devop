#!/bin/bash

# Конфигурация
BACKUP_DIR="/opt/mysql_backup"
MYSQL_USER="root"
MYSQL_PASSWORD="root"
DATABASE="ppl"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")

# Создаем директорию для бэкапов, если её нет
mkdir -p $BACKUP_DIR

# Создаем бэкап
mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD $DATABASE > $BACKUP_DIR/${DATABASE}_${TIMESTAMP}.sql

# Запишем лог
echo "Backup of $DATABASE completed at $(date)" >> $BACKUP_DIR/backup.log