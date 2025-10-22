#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SQL_FILE="${ROOT_DIR}/sql/seed.sql"

if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform is required on PATH to fetch outputs" >&2
  exit 1
fi

if ! command -v psql >/dev/null 2>&1; then
  echo "psql (PostgreSQL client) is required on PATH to load data" >&2
  exit 1
fi

if [[ ! -f "${SQL_FILE}" ]]; then
  echo "Seed file not found at ${SQL_FILE}" >&2
  exit 1
fi

TF_CMD=(terraform -chdir="${ROOT_DIR}")

DB_HOST="$("${TF_CMD[@]}" output -raw db_hostname)"
DB_PORT="$("${TF_CMD[@]}" output -raw db_port)"
DB_NAME="$("${TF_CMD[@]}" output -raw db_name)"
DB_USER="$("${TF_CMD[@]}" output -raw db_username)"
DB_PASSWORD="$("${TF_CMD[@]}" output -raw db_password)"

export PGPASSWORD="${DB_PASSWORD}"

echo "Waiting for database ${DB_NAME} at ${DB_HOST}:${DB_PORT} to accept connections..."
until psql "host=${DB_HOST} port=${DB_PORT} dbname=${DB_NAME} user=${DB_USER}" -c "SELECT 1;" >/dev/null 2>&1; do
  sleep 5
  echo "Still waiting..."
done

echo "Loading seed data from ${SQL_FILE}..."
psql "host=${DB_HOST} port=${DB_PORT} dbname=${DB_NAME} user=${DB_USER}" -f "${SQL_FILE}"
echo "Seed data loaded successfully."

