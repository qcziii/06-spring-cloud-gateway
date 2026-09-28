#!/usr/bin/env bash
# Scenariusz 01-brak-gwiazdek-w-path: Użytkownik /api/users/1 zwraca 404
# Uruchom: najpierw scripts/start-backends.sh, potem gateway z tego katalogu (mvn spring-boot:run), potem ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 01-brak-gwiazdek-w-path: Użytkownik /api/users/1 zwraca 404"
require_gateway
expect_body "GET /api/users/1 trafia do users jako /users/1" '"path":"/users/1"' "$GW/api/users/1"
expect_body "GET /api/users/1/orders trafia do users" '"path":"/users/1/orders"' "$GW/api/users/1/orders"
expect_body "GET /api/orders/7 trafia do orders" '"service":"orders"' "$GW/api/orders/7"
summary
