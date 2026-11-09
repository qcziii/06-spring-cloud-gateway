#!/usr/bin/env bash
# Check for scenario 11-starter-web (the description is printed below)
# Run: first scripts/start-backends.sh, then the gateway from this directory (mvn spring-boot:run), then ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 11-starter-web: Gateway nie startuje po dodaniu zależności"
require_gateway
expect_body "GET /api/users/1 trafia do users" '"service":"users"' "$GW/api/users/1"
expect_body "GET /api/orders/7 trafia do orders" '"service":"orders"' "$GW/api/orders/7"
summary
