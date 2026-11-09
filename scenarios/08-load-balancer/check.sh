#!/usr/bin/env bash
# Scenariusz 08-load-balancer: Trasa lb:// zwraca 503
# Uruchom: najpierw scripts/start-backends.sh, potem gateway z tego katalogu (mvn spring-boot:run), potem ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 08-load-balancer: Trasa lb:// zwraca 503"
require_gateway
expect_body "GET /api/orders/7 trafia do orders przez lb://" '"service":"orders"' "$GW/api/orders/7"
expect_body "GET /api/users/1 dalej działa" '"service":"users"' "$GW/api/users/1"
summary
