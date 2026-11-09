#!/usr/bin/env bash
# Check for scenario 12-wlasny-filtr-globalny (the description is printed below)
# Run: first scripts/start-backends.sh, then the gateway from this directory (mvn spring-boot:run), then ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 12-wlasny-filtr-globalny: Własny filtr autoryzacji psuje odpowiedzi"
require_gateway
expect_status "Bez klucza API: 401" 401 "$GW/api/users/1"
expect_status "Zły klucz API: 401" 401 -H 'X-Api-Key: zly' "$GW/api/users/1"
expect_body "Z kluczem: odpowiedź z users" '"service":"users"' -H 'X-Api-Key: kurs-2026' "$GW/api/users/1"
expect_body "Backend dostaje nagłówek X-Client-Id" '"X-Client-Id":"kurs-app"' -H 'X-Api-Key: kurs-2026' "$GW/api/users/1"
summary
