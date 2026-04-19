#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$ROOT_DIR/includes/.env"
SQL_FILE="$ROOT_DIR/database/devwebcamp.sql"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "No se encontro $ENV_FILE"
  exit 1
fi

if [[ ! -f "$SQL_FILE" ]]; then
  echo "No se encontro $SQL_FILE"
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

if [[ -z "${DB_HOST:-}" || -z "${DB_USER:-}" || -z "${DB_NAME:-}" ]]; then
  echo "Faltan DB_HOST, DB_USER o DB_NAME en includes/.env"
  exit 1
fi

MYSQL_PWD="${DB_PASS:-}" mysql -h"$DB_HOST" -u"$DB_USER" \
  -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

MYSQL_PWD="${DB_PASS:-}" mysql -h"$DB_HOST" -u"$DB_USER" "$DB_NAME" < "$SQL_FILE"

echo "Base de datos importada correctamente en '$DB_NAME'."
