#!/usr/bin/env bash
# Check for scenario 04-kolejnosc-tras (the description is printed below)
# Run: first scripts/start-backends.sh, then the gateway from this directory (mvn spring-boot:run), then ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 04-kolejnosc-tras: Zamówienia trafiają do serwisu użytkowników"
require_gateway
expect_body "GET /api/orders/7 trafia do orders" '"service":"orders"' "$GW/api/orders/7"
expect_body "GET /api/users/1 trafia do users" '"service":"users"' "$GW/api/users/1"
summary
