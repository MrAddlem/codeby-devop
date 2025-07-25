#!/bin/bash
set -eu

# Проверка наличия аргументов
if [ $# -eq 0 ]; then
    echo "Error: No servers specified for backup"
    exit 1
fi

# Конфигурация
SOURCE_SERVERS=("$@")
SOURCE_USER="backup"
LOCAL_BACKUP_ROOT="/home/backup/backups"
LOG_FILE="${LOG_FILE:-$LOCAL_BACKUP_ROOT/logs/backup_$(date +%F_%H-%M).log}"
mkdir -p $LOCAL_BACKUP_ROOT/logs/

# Функция логирования
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Функция бэкапа одного сервера
backup_server() {

    local server=$1
    local backup_dir="$LOCAL_BACKUP_ROOT/$server"
    local remote_dump_path="/tmp/full_dump_$server.sql"
    local local_dump_file="$backup_dir/postgresql/full_dump.sql"

    handle_exit() {
        local ts=$(date +%s)
        local metrics_file="/var/lib/node_exporter/backup_status_${server}.prom"
        {
            echo "server_backup_success{server=\"${server}\"} ${backup_success:-0}"
            echo "server_backup_size_bytes{server=\"${server}\"} ${backup_size:-0}"
            echo "server_db_size_bytes{server=\"${server}\"} ${db_size:-0}"
            echo "server_backup_timestamp{server=\"${server}\"} $ts"
        } > "$metrics_file"
        trap - RETURN
    }
    
    trap handle_exit RETURN

    log "Starting backup of server $server"

    mkdir -p "$backup_dir"/{postgresql,opt}
    chmod 700 "$backup_dir"

    # Создаём дамп PostgreSQL на удалённом сервере
    log "Creating PostgreSQL dump on $server"
    if ! ssh "$SOURCE_USER@$server" "cd /tmp/ && sudo -u postgres pg_dumpall -f $remote_dump_path" 2>> "$LOG_FILE"; then
        log "Error while creating PostgreSQL dump on $server"
        return 1
    fi

    # Проверяем, что дамп на удалённом сервере создан и не пустой
    if ! ssh "$SOURCE_USER@$server" "[ -s $remote_dump_path ]" 2>> "$LOG_FILE"; then
        log "Error: empty dump file on $server or file not created"
        return 1
    fi

    # Копирование с помощью rsync
    if ! rsync -avz --remove-source-files \
        --rsync-path="sudo rsync" \
        "$SOURCE_USER@$server:$remote_dump_path" "$local_dump_file" 2>> "$LOG_FILE"; then
        log "Error: failed to copy dump file from $server"
        return 1
    fi

    # Проверяем локальную копию дампа
    if [ ! -s "$local_dump_file" ]; then
        log "Error: received empty dump file locally from $server"
        return 1
    fi

    chmod 600 "$local_dump_file"
    local dump_size=$(du -h "$local_dump_file" | cut -f1)
    local dump_size_bytes=$(stat -c %s "$local_dump_file")
    log "PostgreSQL dump successfully downloaded from $server (size: $dump_size)"

    # Копирование /opt
    log "Copying application files from $server"
    if ! rsync -avz --delete --progress \
           -e "ssh -o StrictHostKeyChecking=yes" \
           --rsync-path="sudo rsync" \
           "$SOURCE_USER@$server:/opt/" \
           "$backup_dir/opt/" 2>> "$LOG_FILE"; then
        log "Error while copying files from $server"
        return 1
    fi

    if [[ -d "$backup_dir" ]]; then
        local backup_size=$(du -sb -- "$backup_dir" | cut -f1)
        local db_size=$dump_size_bytes
        local backup_success=1
    fi

    log "Backup of server $server completed"
}

# Основной цикл
log "=== Backup started ==="

for server in "${SOURCE_SERVERS[@]}"; do
    if ping -c 1 "$server" &> /dev/null; then
        if ! backup_server "$server"; then
            log "Error during backup of server $server, continuing with next"
        fi
    else
        log "Error: server $server is unreachable, skipping"
    fi
done

find "$LOCAL_BACKUP_ROOT/logs" -maxdepth 1 -type f -name "backup_*.log" -mtime +7 -delete

log "=== Backups completed ==="
