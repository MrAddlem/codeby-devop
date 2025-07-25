#!/bin/bash
set -eu

# Проверка наличия аргументов
if [ $# -eq 0 ]; then
    echo "Error: No servers specified for restore"
    exit 1
fi

# Конфигурация
TARGET_SERVERS=("$@")
TARGET_USER="backup"
LOCAL_BACKUP_ROOT="/home/backup/backups"
LOG_FILE="${LOG_FILE:-$LOCAL_BACKUP_ROOT/logs/restore_$(date +%F_%H-%M).log}"

# Функция логирования
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Функция восстановления одного сервера
restore_server() {
    local server=$1
    local backup_dir="$LOCAL_BACKUP_ROOT/$server"
    local local_dump_file="$backup_dir/postgresql/full_dump.sql"
    local remote_dump_path="/tmp/restore_dump_$server.sql"

    log "Starting restore of server $server"

    # Проверка существования бэкапа
    if [ ! -d "$backup_dir" ] || [ ! -f "$local_dump_file" ]; then
        log "Error: Backup for server $server not found or incomplete"
        return 1
    fi

    log "Checking that databases on $server are empty"

    # Список пользовательских баз данных, исключая системные
    databases=$(ssh "$TARGET_USER@$server" \
        "cd /tmp && sudo -u postgres \
        psql -tAc \"SELECT datname FROM pg_database WHERE datistemplate = false AND datname NOT IN ('postgres');\"")

    for db in $databases; do
        table_count=$(ssh "$TARGET_USER@$server" \
            "cd /tmp && sudo -u postgres \
            psql -d \"$db\" -tAc \"SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';\"")

        if [ "$table_count" -ne 0 ]; then
            log "Error: Database '$db' on $server is not empty (tables: $table_count) — restore aborted"
            return 1
        fi
    done

    # Копируем дамп на удалённый сервер
    log "Copying PostgreSQL dump to $server"
    if ! rsync -avz --progress "$local_dump_file" "$TARGET_USER@$server:$remote_dump_path" 2>> "$LOG_FILE"; then
        log "Error while copying PostgreSQL dump to $server"
        return 1
    fi

    # Восстановление PostgreSQL из временного файла
    log "Restoring PostgreSQL dump on $server"
    if ! ssh "$TARGET_USER@$server" \
           "cd /tmp/ && \
           chmod 644 $remote_dump_path && \
           sudo -u postgres psql -f $remote_dump_path" 2>> "$LOG_FILE"; then
        log "Error while restoring PostgreSQL dump on $server"
        ssh "$TARGET_USER@$server" "rm -f $remote_dump_path" 2>> "$LOG_FILE"
        return 1
    fi

    # Удаляем временный дамп с удалённого сервера
    ssh "$TARGET_USER@$server" "rm -f $remote_dump_path" 2>> "$LOG_FILE"

    log "PostgreSQL dump successfully restored on $server"

    # Восстановление /opt
    log "Restoring application files on $server"
    if ! rsync -avz --delete --progress \
           --chown=gitlab-runner:gitlab-runner \
           -e "ssh -o StrictHostKeyChecking=yes" \
           --rsync-path="sudo rsync" \
           "$backup_dir/opt/" \
           "$TARGET_USER@$server:/opt/" 2>> "$LOG_FILE"; then
        log "Error while restoring files on $server"
        return 1
    fi

    log "Restore of server $server completed"
}

# Основной цикл
log "=== Restore started ==="

for server in "${TARGET_SERVERS[@]}"; do
    if ping -c 1 "$server" &> /dev/null; then
        if ! restore_server "$server"; then
            log "Error during restore of server $server, continuing with next"
        fi
    else
        log "Error: Server $server is unreachable, skipping"
    fi
done

find "$LOCAL_BACKUP_ROOT/logs" -maxdepth 1 -type f -name "restore_*.log" -mtime +7 -delete

log "=== Restore completed ==="
