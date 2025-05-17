#!/usr/bin/env bash
set -e
psql "postgresql://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}" <<'EOSQL'
INSERT INTO users (username, password_hash)
VALUES
  ('alice', 'hash1'),
  ('bob', 'hash2')
ON CONFLICT (username) DO NOTHING;
EOSQL
