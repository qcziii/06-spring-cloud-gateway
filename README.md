# Spring Cloud Gateway: warsztat z troubleshootingu

Masz przed sobą 12 gatewayów, które nie działają. Każdy to osobny projekt z opisem zgłoszenia od użytkownika i testem, który przejdzie dopiero po naprawie. Twoim zadaniem jest znaleźć przyczynę, poprawić konfigurację lub kod i umieć wyjaśnić, **jak** do przyczyny doszedłeś.

## Wymagania

- Java 21
- Maven 3.9+
- `bash` i `curl` (na Windows: Git Bash)
- wolne porty 8080, 8081, 8082

**Windows / Git Bash:** Git Bash zamienia argumenty zaczynające się od `/` (np. `/users`) na ścieżki Windows (`C:/Program Files/Git/users`). Skrypty z repo są na to odporne. Jeśli uruchamiasz coś ręcznie i w odpowiedzi lub logach widzisz `C:/Program Files/Git/...`, poprzedź polecenie `MSYS_NO_PATHCONV=1`.

Stos: Spring Boot 4.0, Spring Cloud 2025.1 (Spring Cloud Gateway Server WebFlux).

## Architektura

```
klient (curl) ──> gateway :8080 ──┬──> users  :8081  (obsługuje /users/**)
                                  └──> orders :8082  (obsługuje /orders/**)
```

`users` i `orders` to dwa egzemplarze tego samego backendu "echo" z katalogu `backend/`. Odsyła on JSON z tym, co do niego **faktycznie dotarło**: metodą, ścieżką, parametrami i nagłówkami. To Twoje główne narzędzie diagnostyczne.

```bash
curl http://localhost:8081/users/1
# {"service":"users","method":"GET","path":"/users/1","query":{},"headers":{...}}
```

Dodatkowe parametry backendu:
- `?delay=3000` opóźnia odpowiedź o 3000 ms,
- `?status=503` wymusza podany kod odpowiedzi.

Na ścieżkę spoza swojego prefiksu backend odpowiada 404 z polem `error`.

## Jak pracować

```bash
# 1. Raz na całe zajęcia: uruchom backendy
./scripts/start-backends.sh

# 2. Uruchom gateway z wybranego scenariusza
cd scenarios/01-brak-gwiazdek-w-path
mvn spring-boot:run

# 3. W drugim terminalu (z katalogu głównego repo): sprawdź
./scenarios/01-brak-gwiazdek-w-path/check.sh

# Na koniec
./scripts/stop-backends.sh
```

Przeczytaj `ZADANIE.md` w katalogu scenariusza, odtwórz problem curlem, znajdź przyczynę, popraw i uruchom gateway ponownie. Scenariusz jest rozwiązany, gdy `check.sh` wypisze `WYNIK: wszystkie sprawdzenia przeszły`.

Gateway w każdym scenariuszu ma włączony endpoint `/actuator/gateway/routes`. Warto z niego korzystać.

## Scenariusze

| # | Zgłoszenie | Poziom |
|---|---|---|
| 01 | Użytkownik /api/users/1 zwraca 404 | łatwy |
| 02 | Backend dostaje złą ścieżkę | łatwy |
| 03 | Nowa wersja API v2 nie działa | średni |
| 04 | Zamówienia trafiają do serwisu użytkowników | średni |
| 05 | Po aktualizacji Spring Cloud wszystko zwraca 404 | średni |
| 06 | Tworzenie zamówienia (POST) zwraca 404 | łatwy |
| 07 | Zamówienia zwracają 500 | łatwy |
| 08 | Trasa lb:// zwraca 503 | trudny |
| 09 | Raporty zwracają 504 mimo ustawionego timeoutu | średni |
| 10 | Przeglądarka odrzuca odpowiedź przez CORS | średni |
| 11 | Gateway nie startuje po dodaniu zależności | średni |
| 12 | Własny filtr autoryzacji psuje odpowiedzi | trudny |

## Zasady

- Nie zmieniaj backendu, skryptów ani `check.sh`. Naprawiasz wyłącznie gateway w katalogu scenariusza.
- Zanim cokolwiek zmienisz, odpowiedz sobie na pytanie: **kto zwrócił ten błąd, gateway czy backend?**
- Czytaj logi. Większość scenariuszy da się rozwiązać bez zgadywania.
- Przy pracy w repo zrób własną gałąź, żeby łatwo wrócić do zepsutej wersji (`git checkout -- scenarios/NN-...`).

Cały projekt (backend i wszystkie scenariusze) buduje się naraz poleceniem `mvn package -DskipTests` w katalogu głównym.
