# Используем базовый образ Alpine
FROM alpine:latest
# Устанавливаем необходимые инструменты
RUN apk add --no-cache bash flock
# Копируем скрипт в контейнер
COPY file_manager.sh /usr/local/bin/file_manager.sh
# Делаем скрипт исполняемым
RUN chmod +x /usr/local/bin/file_manager.sh
# Указываем команду по умолчанию
CMD ["/usr/local/bin/file_manager.sh"]
