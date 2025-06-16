#!/bin/bash

folder=~/myfolder

# Кол-во файлов в папке
file_count=$(ls -1 $folder | wc -l)
echo "Количество файлов в папке: $file_count"

# Исправляем права 2-ого файла
if [ -f "$folder/file2.txt" ]; then
    chmod 664 "$folder/file2.txt"
    echo "Права файла file2.txt изменены на 664"
fi

# Удаляем пустые файлы
find $folder -type f -empty -delete
echo "Пустые файлы удалены"

# Оставляем только первую строку в непустых файлах
for file in $folder/*; do
    if [ -s "$file" ]; then  # Проверяем, что файл не пустой 
        # Получаем первую строку
        first_line=$(head -n 1 "$file")
        # Перезаписываем файл только 1-ой строкой
        echo "$first_line" > "$file"
    fi
done

echo "Скрипт 2 выполнен: права исправлены, пустые файлы удалены, в остальных оставлена только первая строка"