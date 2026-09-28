# 11. Gateway nie startuje po dodaniu zależności

Poziom: **średni**

## Uruchomienie

```bash
# raz, z katalogu głównego ćwiczeń (backendy users :8081 i orders :8082)
./scripts/start-backends.sh

# gateway z tego scenariusza (port 8080)
cd scenarios/11-starter-web
mvn spring-boot:run

# w drugim terminalu: automatyczne sprawdzenie
./scenarios/11-starter-web/check.sh
```

## Zgłoszenie

Kursant chciał dodać do gatewaya prosty kontroler REST ze statusem i "na wszelki wypadek" dopisał do `pom.xml` zależność `spring-boot-starter-web`. Od tego czasu gateway nie startuje.

```bash
cd scenarios/11-starter-web && mvn spring-boot:run
curl -i http://localhost:8080/api/users/1
```

**Oczekiwane:** gateway startuje i routuje żądania jak wcześniej.

**Zadanie właściwe:** przeczytaj uważnie log startowy. Jaki serwer HTTP zaczął startować (Netty czy Tomcat) i dlaczego? Gdzie w logu jest właściwa przyczyna, a gdzie tylko jej skutki?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
