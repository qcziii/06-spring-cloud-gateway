#!/usr/bin/env bash
# Check for scenario 08-load-balancer (the description is printed below)
# Run: first scripts/start-backends.sh, then the gateway from this directory (mvn spring-boot:run), then ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 08-load-balancer: Trasa lb:// zwraca 503"
require_gateway
expect_body "GET /api/orders/7 trafia do orders przez lb://" '"service":"orders"' "$GW/api/orders/7"
expect_body "GET /api/users/1 dalej działa" '"service":"users"' "$GW/api/users/1"
summary
