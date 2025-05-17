#!/usr/bin/env bash
# ---------------------------------------
# 開発者用ラッパースクリプト
# ./run.sh start | stop | logs | rebuild | migrate | seed
# ---------------------------------------
set -e

CMD=${1:-start}

case "$CMD" in
  start)
    docker compose up -d --build
    docker compose ps
    ;;
  stop)
    docker compose down
    ;;
  logs)
    docker compose logs -f --tail=50
    ;;
  rebuild)
    docker compose down --volumes
    docker compose build --no-cache
    docker compose up -d
    ;;
  migrate)
    echo "🔄 Running migrations..."
    docker compose exec api bash /scripts/migrate.sh
    ;;
  seed)
    echo "🌱 Seeding DB..."
    docker compose exec api bash /scripts/seed.sh
    ;;
  *)
    echo "Usage: ./run.sh {start|stop|logs|rebuild|migrate|seed}"
    exit 1
    ;;
esac
