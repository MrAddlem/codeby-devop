#!/bin/bash

readonly FOLDER_NAME="myfolder"
readonly USER_HOME="$HOME"
readonly TARGET_FOLDER="${USER_HOME}/${FOLDER_NAME}"

create_files() {
    # 1: приветствие и текущая дата/время
    echo -e "Приветствие пользователю $USER\n$(date)" > "${TARGET_FOLDER}/file1.txt" || return 1

    # 2: пустой файл с правами 777
    touch "${TARGET_FOLDER}/file2.txt" || return 1
    chmod 777 "${TARGET_FOLDER}/file2.txt" || return 1

    # 3: строка из 20 случайных символов
    < /dev/urandom tr -dc 'a-zA-Z0-9' | head -c 20 > "${TARGET_FOLDER}/file3.txt" || return 1

    # 4-5: пустые файлы
    touch "${TARGET_FOLDER}/file4.txt" "${TARGET_FOLDER}/file5.txt" || return 1

    return 0
}

# Основной код
main() {
    # Создаем папку (если не существует)
    mkdir -p "${TARGET_FOLDER}" || {
        echo "Ошибка: не удалось создать папку ${TARGET_FOLDER}" >&2
        return 1
    }

    # Создаем файлы
    create_files || {
        echo "Ошибка при создании файлов" >&2
        return 1
    }

    echo "Скрипт 1 выполнен: создана папка и 5 файлов в ${TARGET_FOLDER}"
    return 0
}

# Вызов основной функции
main "$@"