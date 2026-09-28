#!/usr/bin/env bash
# Scenariusz 07-backend-nie-odpowiada: Zamówienia zwracają 500
# Uruchom: najpierw scripts/start-backends.sh, potem gateway z tego katalogu (mvn spring-boot:run), potem ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 07-backend-nie-odpowiada: Zamówienia zwracają 500"
require_gateway
expect_body "GET /api/orders/7 trafia do orders" '"service":"orders"' "$GW/api/orders/7"
summary
