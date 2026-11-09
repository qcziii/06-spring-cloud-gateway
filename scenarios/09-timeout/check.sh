#!/usr/bin/env bash
# Check for scenario 09-timeout (the description is printed below)
# Run: first scripts/start-backends.sh, then the gateway from this directory (mvn spring-boot:run), then ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 09-timeout: Raporty zwracają 504 mimo ustawionego timeoutu"
require_gateway
expect_body "Raport liczony 3 s przechodzi" '"path":"/users/reports/monthly"' "$GW/api/users/reports/monthly?delay=3000"
expect_status "Zwykłe żądanie 3 s nadal kończy się 504 (globalny limit 1 s zostaje)" 504 "$GW/api/users/1?delay=3000"
expect_body "Szybkie żądanie działa" '"service":"users"' "$GW/api/users/1"
summary
