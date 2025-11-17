#!/bin/bash

# ==== НАСТРОЙКИ ====
CONTAINER_NAME="remnawave-tg-shop-db"
BACKUP_DIR="./app-data/manual-backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Загружаем переменные окружения из .env
set -o allexport
source .env
set +o allexport

# Проверяем, существует ли каталог backups — если нет, создаём
mkdir -p "$BACKUP_DIR"

# Имя файла
FILENAME="$BACKUP_DIR/db-$TIMESTAMP.sql"

echo "🔄 Создаю бекап базы '$POSTGRES_DB'..."

# Выполняем pg_dump внутри контейнера
docker exec -i "$CONTAINER_NAME" \
  pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB" > "$FILENAME"

# Проверяем успешность
if [ $? -eq 0 ]; then
  echo "✅ Бекап успешно создан: $FILENAME"
else
  echo "❌ Ошибка при создании бекапа!"
  exit 1
fi
