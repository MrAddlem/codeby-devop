#!/bin/bash

readonly FOLDER_NAME="myfolder"
readonly USER_HOME="$HOME"
readonly TARGET_FOLDER="${USER_HOME}/${FOLDER_NAME}"

# Функция для обработки файлов
process_files() {
    local file_count
    file_count=$(find "${TARGET_FOLDER}" -maxdepth 1 -type f | wc -l) || return 1
    echo "Количество файлов в папке: ${file_count}"

    # Исправляем права второго файла
    if [ -f "${TARGET_FOLDER}/file2.txt" ]; then
        chmod 664 "${TARGET_FOLDER}/file2.txt" || return 1
        echo "Права файла file2.txt изменены на 664"
    fi

    # Удаляем пустые файлы
    find "${TARGET_FOLDER}" -maxdepth 1 -type f -empty -delete || return 1
    echo "Пустые файлы удалены"

    # Оставляем только первую строку в непустых файлах
    while IFS= read -r -d '' file; do
        [ -s "${file}" ] || continue  # Пропускаем пустые файлы
        # Получаем первую строку и перезаписываем файл
        head -n 1 "${file}" > "${file}.tmp" && mv "${file}.tmp" "${file}" || return 1
    done < <(find "${TARGET_FOLDER}" -maxdepth 1 -type f -print0)

    return 0
}

# Основная функция
main() {
    # Проверяем существование папки
    [ -d "${TARGET_FOLDER}" ] || {
        echo "Ошибка: папка ${TARGET_FOLDER} не существует" >&2
        return 1
    }

    # Обрабатываем файлы
    process_files || {
        echo "Ошибка при обработке файлов" >&2
        return 1
    }

    echo "Скрипт 2 выполнен: права исправлены, пустые файлы удалены, в остальных оставлена только первая строка"
    return 0
}

# Вызов основной функции
main "$@"