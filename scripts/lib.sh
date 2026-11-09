#!/usr/bin/env bash
# Wspólne funkcje dla skryptów check.sh w scenariuszach.
# Wymagają tylko bash i curl.

GW=${GW:-http://localhost:8080}
PASS=0
FAIL=0
BODY_FILE=$(mktemp)
HDR_FILE=$(mktemp)
trap 'rm -f "$BODY_FILE" "$HDR_FILE"' EXIT

ok()  { echo "  [OK]   $1"; PASS=$((PASS+1)); }
bad() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

# Wykonuje żądanie; zapisuje kod, nagłówki i body. Argumenty jak dla curl.
call() {
  CODE=$(curl -s -o "$BODY_FILE" -D "$HDR_FILE" -w '%{http_code}' --max-time 15 "$@")
  BODY=$(cat "$BODY_FILE")
}

require_gateway() {
  if ! curl -s -o /dev/null --max-time 5 "$GW/"; then
    echo "  [FAIL] Gateway nie odpowiada pod $GW. Czy wystartował? Sprawdź logi aplikacji."
    exit 1
  fi
}

# expect_status "opis" 200 <argumenty curl>
expect_status() {
  local desc=$1 expected=$2; shift 2
  call "$@"
  if [ "$CODE" = "$expected" ]; then ok "$desc (HTTP $CODE)"; else bad "$desc: oczekiwano HTTP $expected, jest HTTP $CODE. Body: ${BODY:0:300}"; fi
}

# expect_body "opis" 'fragment' <argumenty curl>  (sprawdza też, że HTTP 2xx)
expect_body() {
  local desc=$1 fragment=$2; shift 2
  call "$@"
  if [[ "$CODE" == 2* ]] && grep -qF -- "$fragment" "$BODY_FILE"; then
    ok "$desc"
  else
    bad "$desc: oczekiwano HTTP 2xx i fragmentu $fragment, jest HTTP $CODE. Body: ${BODY:0:300}"
  fi
}

# expect_header_count "opis" Nazwa-Naglowka 1 <argumenty curl>
expect_header_count() {
  local desc=$1 header=$2 expected=$3; shift 3
  call "$@"
  local n
  n=$(grep -ci "^$header:" "$HDR_FILE")
  if [ "$n" = "$expected" ]; then ok "$desc"; else bad "$desc: oczekiwano $expected nagłówka $header, jest $n: $(grep -i "^$header:" "$HDR_FILE" | tr -d '\r' | tr '\n' ' ')"; fi
}

summary() {
  echo
  if [ "$FAIL" = 0 ]; then
    echo "WYNIK: wszystkie sprawdzenia przeszły ($PASS). Scenariusz naprawiony!"
    exit 0
  else
    echo "WYNIK: $FAIL nie przeszło, $PASS przeszło. Szukaj dalej."
    exit 1
  fi
}
