#!/usr/bin/env bash
# Scenariusz 06-predykat-metody: Tworzenie zamówienia (POST) zwraca 404
# Uruchom: najpierw scripts/start-backends.sh, potem gateway z tego katalogu (mvn spring-boot:run), potem ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 06-predykat-metody: Tworzenie zamówienia (POST) zwraca 404"
require_gateway
expect_body "GET /api/orders/7 działa" '"method":"GET"' "$GW/api/orders/7"
expect_body "POST /api/orders dociera do orders" '"method":"POST"' -X POST -H 'Content-Type: application/json' -d '{"product":"kawa"}' "$GW/api/orders"
expect_status "DELETE /api/orders/7 nadal zablokowany (404)" 404 -X DELETE "$GW/api/orders/7"
summary
