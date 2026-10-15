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

Method – określa, jakie metody HTTP (np. GET, POST, PUT, DELETE) są dozwolone dla danej trasy w API Gateway.

Przykład: Method=GET,POST oznacza, że Gateway przekazuje żądania GET i POST do backendu, a pozostałe metody nie pasują do tej trasy.

404 Not Found – Gateway nie znalazł trasy, która spełnia wszystkie warunki, ponieważ Method=GET nie dopuszcza POST.

405 Method Not Allowed – oznacza, że dany zasób lub endpoint istnieje, ale nie obsługuje wskazanej metody HTTP.

Ponieważ Gateway nie znalazł trasy pasującej do metody POST. Kod 405 oznacza, że endpoint istnieje, 
ale nie obsługuje danej metody, natomiast tutaj żądanie nie zostało w ogóle dopasowane do trasy.

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
