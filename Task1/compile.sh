#!/bin/sh
# Проверка аргументов
if [ "$#" -ne 1 ]; then
    echo "Использование: $0 <исходный_файл>"
    exit 1
fi
SOURCE_FILE="$1"
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT
# Проверка существования исходного файла
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Ошибка: Исходный файл не существует."
    exit 2
fi
# Поиск имени конечного файла
OUTPUT_FILE=""
while IFS= read -r line; do
    if echo "$line" | grep -q '^# Output:'; then
        OUTPUT_FILE=$(echo "$line" | cut -d' ' -f3)
        break
    fi
done < "$SOURCE_FILE"
# Проверка, найдено ли имя выходного файла
if [ -z "$OUTPUT_FILE" ]; then
    echo "Ошибка: Не найдено имя выходного файла. Убедитесь, что в файле есть комментарий '# Output: <имя_файла>'."
    exit 3
fi
# Компиляция или обработка
if echo "$SOURCE_FILE" | grep -q '\.c$'; then
    gcc -o "$TEMP_DIR/$OUTPUT_FILE" "$SOURCE_FILE" 2> "$TEMP_DIR/error.log"
    COMPILE_STATUS=$?
elif echo "$SOURCE_FILE" | grep -q '\.cpp$'; then
    g++ -o "$TEMP_DIR/$OUTPUT_FILE" "$SOURCE_FILE" 2> "$TEMP_DIR/error.log"
    COMPILE_STATUS=$?
elif echo "$SOURCE_FILE" | grep -q '\.tex$'; then
    pdflatex -output-directory="$TEMP_DIR" "$SOURCE_FILE" 2> "$TEMP_DIR/error.log"
    COMPILE_STATUS=$?
    if [ $COMPILE_STATUS -eq 0 ]; then
        mv "$TEMP_DIR/${SOURCE_FILE%.tex}.pdf" "$TEMP_DIR/$OUTPUT_FILE"
    fi
else
    echo "Ошибка: Неподдерживаемый тип файла. Поддерживаются только .c, .cpp и .tex."
    exit 4
fi
# Проверка на ошибки компиляции
if [ $COMPILE_STATUS -ne 0 ]; then
    echo "Ошибка компиляции. Проверьте файл '$TEMP_DIR/error.log' для получения деталей."
    exit 5
fi
# Перемещение конечного файла в текущий каталог
mv "$TEMP_DIR/$OUTPUT_FILE" .
echo "Сборка завершена успешно. Конечный файл: '$OUTPUT_FILE'"
# Временный каталог будет удален благодаря trap