#!/usr/bin/env bash
# Scenariusz 11-starter-web: Gateway nie startuje po dodaniu zależności
# Uruchom: najpierw scripts/start-backends.sh, potem gateway z tego katalogu (mvn spring-boot:run), potem ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 11-starter-web: Gateway nie startuje po dodaniu zależności"
require_gateway
expect_body "GET /api/users/1 trafia do users" '"service":"users"' "$GW/api/users/1"
expect_body "GET /api/orders/7 trafia do orders" '"service":"orders"' "$GW/api/orders/7"
summary
