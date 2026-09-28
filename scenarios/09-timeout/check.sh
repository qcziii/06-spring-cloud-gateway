#!/usr/bin/env bash
# Scenariusz 09-timeout: Raporty zwracają 504 mimo ustawionego timeoutu
# Uruchom: najpierw scripts/start-backends.sh, potem gateway z tego katalogu (mvn spring-boot:run), potem ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 09-timeout: Raporty zwracają 504 mimo ustawionego timeoutu"
require_gateway
expect_body "Raport liczony 3 s przechodzi" '"path":"/users/reports/monthly"' "$GW/api/users/reports/monthly?delay=3000"
expect_status "Zwykłe żądanie 3 s nadal kończy się 504 (globalny limit 1 s zostaje)" 504 "$GW/api/users/1?delay=3000"
expect_body "Szybkie żądanie działa" '"service":"users"' "$GW/api/users/1"
summary
