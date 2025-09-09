#!/bin/bash

set -euo pipefail

DB_HOST=${POSTGRES_HOST:-localhost}
DB_USER=${POSTGRES_USERNAME:-postgres}
DB_PASS=${POSTGRES_PASSWORD:-postgres}

export PGPASSWORD="$DB_PASS"

echo "🔧 Enabling pgvector extension on chatwoot_development and chatwoot_test..."

psql -h "$DB_HOST" -U "$DB_USER" -d chatwoot_development -c 'CREATE EXTENSION IF NOT EXISTS vector;' || true
psql -h "$DB_HOST" -U "$DB_USER" -d chatwoot_test -c 'CREATE EXTENSION IF NOT EXISTS vector;' || true

echo "✅ pgvector extension enabled."
