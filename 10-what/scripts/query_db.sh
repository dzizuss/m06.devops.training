#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_QUERY="SELECT c.full_name, o.product, o.total_amount, o.order_date FROM customers c JOIN orders o ON o.customer_id = c.id ORDER BY o.order_date;"

if ! command -v terraform >/dev/null 2>&1; then
  echo "terraform is required on PATH to fetch outputs" >&2
  exit 1
fi

if ! command -v psql >/dev/null 2>&1; then
  echo "psql (PostgreSQL client) is required on PATH to run queries" >&2
  exit 1
fi

TF_CMD=(terraform -chdir="${ROOT_DIR}")

DB_HOST="$("${TF_CMD[@]}" output -raw db_hostname)"
DB_PORT="$("${TF_CMD[@]}" output -raw db_port)"
DB_NAME="$("${TF_CMD[@]}" output -raw db_name)"
DB_USER="$("${TF_CMD[@]}" output -raw db_username)"
DB_PASSWORD="$("${TF_CMD[@]}" output -raw db_password)"

QUERY="${1:-${DEFAULT_QUERY}}"

export PGPASSWORD="${DB_PASSWORD}"

psql "host=${DB_HOST} port=${DB_PORT} dbname=${DB_NAME} user=${DB_USER}" -c "${QUERY}"

