# 02. Backend dostaje złą ścieżkę

Poziom: **łatwy**

## Uruchomienie

```bash
# raz, z katalogu głównego ćwiczeń (backendy users :8081 i orders :8082)
./scripts/start-backends.sh

# gateway z tego scenariusza (port 8080)
cd scenarios/02-strip-prefix
mvn spring-boot:run

# w drugim terminalu: automatyczne sprawdzenie
./scenarios/02-strip-prefix/check.sh
```

## Zgłoszenie

Po "porządkach" w konfiguracji `GET /api/users/1` zwraca 404, ale w innym formacie niż zwykle.

```bash
curl -i http://localhost:8080/api/users/1
```

**Oczekiwane:** `GET /api/users/1` trafia do serwisu `users` jako `/users/1`.

**Pytanie dodatkowe:** czy tym razem trasa w gatewayu została dopasowana? Po czym to poznać?

Tak, ponieważ w odpowiedzi mamy "service": "users" oraz "error". To oznacza, że żądanie dotarło do backendu, 
ale przez błędny StripPrefix=2 backend otrzymał ścieżkę /1 zamiast /users/1 i zwrócił 404.

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
