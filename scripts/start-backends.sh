#!/usr/bin/env bash
# Startuje dwa egzemplarze backendu echo:
#   users  -> http://localhost:8081  (obsługuje /users/**)
#   orders -> http://localhost:8082  (obsługuje /orders/**)
set -e
ROOT=$(cd "$(dirname "$0")/.." && pwd)
JAR="$ROOT/backend/target/echo-backend-1.0.0.jar"
if [ ! -f "$JAR" ]; then
  echo "Buduję backend..."
  (cd "$ROOT/backend" && mvn -q -B package -DskipTests)
fi
mkdir -p "$ROOT/logs"
PORT=8081 SERVICE_NAME=users  ACCEPTED_PREFIX=/users  nohup java -jar "$JAR" > "$ROOT/logs/users.log"  2>&1 & echo $! > "$ROOT/logs/users.pid"
PORT=8082 SERVICE_NAME=orders ACCEPTED_PREFIX=/orders nohup java -jar "$JAR" > "$ROOT/logs/orders.log" 2>&1 & echo $! > "$ROOT/logs/orders.pid"
for i in $(seq 1 60); do
  if curl -s -o /dev/null localhost:8081/users && curl -s -o /dev/null localhost:8082/orders; then
    echo "Backendy działają: users na :8081, orders na :8082 (logi w $ROOT/logs)"
    exit 0
  fi
  sleep 1
done
echo "Backendy nie wystartowały w 60 s, sprawdź $ROOT/logs/*.log"
exit 1
