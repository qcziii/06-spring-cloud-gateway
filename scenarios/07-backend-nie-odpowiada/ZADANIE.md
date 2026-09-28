# 07. Zamówienia zwracają 500

Poziom: **łatwy**

## Uruchomienie

```bash
# raz, z katalogu głównego ćwiczeń (backendy users :8081 i orders :8082)
./scripts/start-backends.sh

# gateway z tego scenariusza (port 8080)
cd scenarios/07-backend-nie-odpowiada
mvn spring-boot:run

# w drugim terminalu: automatyczne sprawdzenie
./scenarios/07-backend-nie-odpowiada/check.sh
```

## Zgłoszenie

`GET /api/orders/7` zwraca `500 Internal Server Error`. Zespół backendu twierdzi, że serwis `orders` działa i w jego logach nie ma żadnego błędu.

```bash
curl -i http://localhost:8080/api/orders/7
curl -i http://localhost:8082/orders/7
```

**Oczekiwane:** żądanie trafia do serwisu `orders`.

**Zadanie właściwe:** zanim poprawisz konfigurację, znajdź w **logach gatewaya** komunikat, który wprost mówi, co się stało. Jakie jest `requestId` w body błędu i jak pomaga w szukaniu w logach?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
