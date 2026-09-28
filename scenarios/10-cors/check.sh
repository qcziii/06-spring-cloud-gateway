#!/usr/bin/env bash
# Scenariusz 10-cors: Przeglądarka odrzuca odpowiedź przez CORS
# Uruchom: najpierw scripts/start-backends.sh, potem gateway z tego katalogu (mvn spring-boot:run), potem ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 10-cors: Przeglądarka odrzuca odpowiedź przez CORS"
require_gateway
expect_header_count "Dokładnie jeden Access-Control-Allow-Origin w odpowiedzi GET" Access-Control-Allow-Origin 1 -H 'Origin: http://localhost:3000' "$GW/api/users/1"
call -H 'Origin: http://localhost:3000' "$GW/api/users/1"
if grep -qi '^Access-Control-Allow-Origin: http://localhost:3000' "$HDR_FILE"; then ok "Access-Control-Allow-Origin = http://localhost:3000"; else bad "Access-Control-Allow-Origin powinien mieć wartość http://localhost:3000, jest: $(grep -i '^Access-Control-Allow-Origin' "$HDR_FILE" | tr -d '\r' | tr '\n' ' ')"; fi
expect_status "Preflight OPTIONS z localhost:3000 przechodzi" 200 -X OPTIONS -H 'Origin: http://localhost:3000' -H 'Access-Control-Request-Method: POST' "$GW/api/orders"
expect_status "Preflight z obcego originu jest odrzucany" 403 -X OPTIONS -H 'Origin: http://evil.example' -H 'Access-Control-Request-Method: POST' "$GW/api/orders"
summary
