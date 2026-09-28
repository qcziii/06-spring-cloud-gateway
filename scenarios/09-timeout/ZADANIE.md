# 09. Raporty zwracają 504 mimo ustawionego timeoutu

Poziom: **średni**

## Uruchomienie

```bash
# raz, z katalogu głównego ćwiczeń (backendy users :8081 i orders :8082)
./scripts/start-backends.sh

# gateway z tego scenariusza (port 8080)
cd scenarios/09-timeout
mvn spring-boot:run

# w drugim terminalu: automatyczne sprawdzenie
./scenarios/09-timeout/check.sh
```

## Zgłoszenie

Globalny limit czasu odpowiedzi backendu w gatewayu to 1 s. Raporty (`/api/users/reports/**`) liczą się ok. 3 s, więc dla nich dodano osobną trasę z dłuższym timeoutem. Mimo to raporty dalej kończą się 504 po ok. 1 s.

Backend echo symuluje wolną odpowiedź parametrem `delay` (ms):
```bash
curl -i -w '\nczas: %{time_total}s\n' 'http://localhost:8080/api/users/reports/monthly?delay=3000'
```

**Oczekiwane:** raporty do 5 s przechodzą. Pozostałe trasy zachowują globalny limit 1 s (nie podnoś go!).

**Pytanie dodatkowe:** czym się różni `connect-timeout` od `response-timeout`? Który timeout zadziała, gdy backend w ogóle nie istnieje pod danym adresem?

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
