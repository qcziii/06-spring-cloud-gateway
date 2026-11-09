#!/usr/bin/env bash
# Check for scenario 07-backend-nie-odpowiada (the description is printed below)
# Run: first scripts/start-backends.sh, then the gateway from this directory (mvn spring-boot:run), then ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 07-backend-nie-odpowiada: Zamówienia zwracają 500"
require_gateway
expect_body "GET /api/orders/7 trafia do orders" '"service":"orders"' "$GW/api/orders/7"
summary
