# 05. Po aktualizacji Spring Cloud wszystko zwraca 404

Poziom: **średni**

## Uruchomienie

```bash
# raz, z katalogu głównego ćwiczeń (backendy users :8081 i orders :8082)
./scripts/start-backends.sh

# gateway z tego scenariusza (port 8080)
cd scenarios/05-stary-prefiks-konfiguracji
mvn spring-boot:run

# w drugim terminalu: automatyczne sprawdzenie
./scenarios/05-stary-prefiks-konfiguracji/check.sh
```

## Zgłoszenie

Projekt przeniesiono z Spring Boot 3.3 / Spring Cloud 2024 na Spring Boot 4 / Spring Cloud 2025.1. Kod się kompiluje, aplikacja startuje bez błędów, ale **każde** żądanie zwraca 404. Konfiguracja tras "na pewno się nie zmieniła".

```bash
curl -i http://localhost:8080/api/users/1
curl -i http://localhost:8080/api/orders/7
```

**Oczekiwane:** oba żądania trafiają do właściwych backendów.

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
