# 01. Użytkownik /api/users/1 zwraca 404

Poziom: **łatwy**

## Uruchomienie

```bash
# raz, z katalogu głównego ćwiczeń (backendy users :8081 i orders :8082)
./scripts/start-backends.sh

# gateway z tego scenariusza (port 8080)
cd scenarios/01-brak-gwiazdek-w-path
mvn spring-boot:run

# w drugim terminalu: automatyczne sprawdzenie
./scenarios/01-brak-gwiazdek-w-path/check.sh
```

## Zgłoszenie

Zespół frontendu zgłasza: "lista zamówień działa, ale szczegóły użytkownika zawsze zwracają 404".

```bash
curl -i http://localhost:8080/api/orders/7   # działa
curl -i http://localhost:8080/api/users/1    # 404
```

**Oczekiwane:** `GET /api/users/1` trafia do serwisu `users` jako `/users/1`.

**Pytanie dodatkowe:** skąd wiesz, czy 404 wygenerował gateway, czy backend? (Podpowiedź: porównaj body odpowiedzi z tym, co zwraca `curl http://localhost:8081/nieistnieje`.)

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
