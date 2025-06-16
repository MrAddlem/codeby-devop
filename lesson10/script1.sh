#!/bin/bash

# Создаем папку myfolder в домашней директории
mkdir -p ~/myfolder

# Файл 1: приветствие и текущая дата/время
echo -e "Приветствие пользователю $USER\n$(date)" > ~/myfolder/file1.txt

# Файл 2: пустой файл с правами 777
touch ~/myfolder/file2.txt
chmod 777 ~/myfolder/file2.txt

# Файл 3: строка из 20 случайных символов
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1 > ~/myfolder/file3.txt

# Файлы 4-5: пустые файлы
touch ~/myfolder/file4.txt ~/myfolder/file5.txt

echo "Скрипт 1 выполнен: создана папка и 5 файлов в ~/myfolder"