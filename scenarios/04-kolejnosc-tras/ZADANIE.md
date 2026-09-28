# 04. Zamówienia trafiają do serwisu użytkowników

Poziom: **średni**

## Uruchomienie

```bash
# raz, z katalogu głównego ćwiczeń (backendy users :8081 i orders :8082)
./scripts/start-backends.sh

# gateway z tego scenariusza (port 8080)
cd scenarios/04-kolejnosc-tras
mvn spring-boot:run

# w drugim terminalu: automatyczne sprawdzenie
./scenarios/04-kolejnosc-tras/check.sh
```

## Zgłoszenie

Ktoś dodał trasę "domyślną" `api-default`, żeby nieznane ścieżki `/api/**` szły do serwisu `users`. Od tego czasu zamówienia przestały działać.

```bash
curl -i http://localhost:8080/api/orders/7
```

**Oczekiwane:** `/api/orders/**` trafia do `orders`, `/api/users/**` do `users`, a trasa domyślna łapie tylko resztę.

**Pytanie dodatkowe:** użyj `GET /actuator/gateway/routes`. W jakiej kolejności są trasy i od czego ona zależy?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
