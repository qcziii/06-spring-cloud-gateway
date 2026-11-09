#!/usr/bin/env bash
# Scenariusz 03-sciezka-w-uri: Nowa wersja API v2 nie działa
# Uruchom: najpierw scripts/start-backends.sh, potem gateway z tego katalogu (mvn spring-boot:run), potem ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 03-sciezka-w-uri: Nowa wersja API v2 nie działa"
require_gateway
expect_body "GET /api/v2/orders/7 trafia do orders jako /orders/7" '"path":"/orders/7"' "$GW/api/v2/orders/7"
expect_body "GET /api/v2/orders/7/items trafia jako /orders/7/items" '"path":"/orders/7/items"' "$GW/api/v2/orders/7/items"
expect_body "Stare GET /api/orders/7 dalej działa" '"path":"/orders/7"' "$GW/api/orders/7"
summary
