# 03. Nowa wersja API v2 nie działa

Poziom: **średni**

## Uruchomienie

```bash
# raz, z katalogu głównego ćwiczeń (backendy users :8081 i orders :8082)
./scripts/start-backends.sh

# gateway z tego scenariusza (port 8080)
cd scenarios/03-sciezka-w-uri
mvn spring-boot:run

# w drugim terminalu: automatyczne sprawdzenie
./scenarios/03-sciezka-w-uri/check.sh
```

## Zgłoszenie

Dodano trasę `orders-v2`: klienci mają wołać `/api/v2/orders/{id}`, a backend `orders` ma dostać `/orders/{id}`. Autor trasy uznał, że skoro w `uri` jest `http://localhost:8082/orders`, to wystarczy obciąć `/api/v2/orders`.

```bash
curl -i http://localhost:8080/api/v2/orders/7
```

**Oczekiwane:** backend `orders` dostaje `/orders/7` (i `/orders/7/items` dla `/api/v2/orders/7/items`). Stara ścieżka `/api/orders/7` ma dalej działać.

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
