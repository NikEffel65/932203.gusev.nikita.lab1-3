#!/bin/sh
# Общий том для файлов
SHARED_DIR="/data"
LOCK_FILE="/tmp/file_lock"
# Проверяем, существует ли общий каталог, если нет - создаем его
mkdir -p "$SHARED_DIR"
# Получаем идентификатор контейнера (можно использовать имя контейнера)
CONTAINER_ID=$(hostname)
# Счетчик для порядкового номера файлов
FILE_COUNT=0
while true; do
    # Определяем имя файла
    FILE_NAME=$(printf "%03d.txt" $((FILE_COUNT + 1)))
    # Атомарная операция с использованием flock
    {
        flock 200
        # Проверяем, существует ли файл, и если нет, создаем его
        if [ ! -f "$SHARED_DIR/$FILE_NAME" ]; then
            FILE_COUNT=$((FILE_COUNT + 1))
            echo "$CONTAINER_ID $FILE_COUNT" > "$SHARED_DIR/$FILE_NAME"
            echo "Создан файл: $FILE_NAME"
        fi
        # Удаляем файл
        if [ -f "$SHARED_DIR/$FILE_NAME" ]; then
            rm "$SHARED_DIR/$FILE_NAME"
            echo "Удален файл: $FILE_NAME"
        fi
    } 200>"$LOCK_FILE"
    # Задержка в 1 секунду
    sleep 1
done
