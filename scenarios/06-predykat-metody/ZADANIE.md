# 06. Tworzenie zamówienia (POST) zwraca 404

Poziom: **łatwy**

## Uruchomienie

```bash
# raz, z katalogu głównego ćwiczeń (backendy users :8081 i orders :8082)
./scripts/start-backends.sh

# gateway z tego scenariusza (port 8080)
cd scenarios/06-predykat-metody
mvn spring-boot:run

# w drugim terminalu: automatyczne sprawdzenie
./scenarios/06-predykat-metody/check.sh
```

## Zgłoszenie

Pobieranie zamówień działa, ale utworzenie zamówienia kończy się 404. Backend `orders` wywołany bezpośrednio przyjmuje POST bez problemu.

```bash
curl -i http://localhost:8080/api/orders/7
curl -i -X POST -H 'Content-Type: application/json' -d '{"product":"kawa"}' http://localhost:8080/api/orders
curl -i -X POST -H 'Content-Type: application/json' -d '{"product":"kawa"}' http://localhost:8082/orders
```

**Oczekiwane:** przez gateway można wykonać GET i POST na `/api/orders/**`. DELETE ma pozostać zablokowany.

**Pytanie dodatkowe:** dlaczego gateway zwraca 404, a nie 405 Method Not Allowed?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
