#!/usr/bin/env bash
# Scenariusz 12-wlasny-filtr-globalny: Własny filtr autoryzacji psuje odpowiedzi
# Uruchom: najpierw scripts/start-backends.sh, potem gateway z tego katalogu (mvn spring-boot:run), potem ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 12-wlasny-filtr-globalny: Własny filtr autoryzacji psuje odpowiedzi"
require_gateway
expect_status "Bez klucza API: 401" 401 "$GW/api/users/1"
expect_status "Zły klucz API: 401" 401 -H 'X-Api-Key: zly' "$GW/api/users/1"
expect_body "Z kluczem: odpowiedź z users" '"service":"users"' -H 'X-Api-Key: kurs-2026' "$GW/api/users/1"
expect_body "Backend dostaje nagłówek X-Client-Id" '"X-Client-Id":"kurs-app"' -H 'X-Api-Key: kurs-2026' "$GW/api/users/1"
summary
