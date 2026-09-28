#!/usr/bin/env bash
# Scenariusz 02-strip-prefix: Backend dostaje złą ścieżkę
# Uruchom: najpierw scripts/start-backends.sh, potem gateway z tego katalogu (mvn spring-boot:run), potem ./check.sh
source "$(dirname "$0")/../../scripts/lib.sh"
echo "Scenariusz 02-strip-prefix: Backend dostaje złą ścieżkę"
require_gateway
expect_body "GET /api/users/1 trafia do users jako /users/1" '"path":"/users/1"' "$GW/api/users/1"
expect_body "GET /api/users/42/address trafia jako /users/42/address" '"path":"/users/42/address"' "$GW/api/users/42/address"
summary
