# 12. Własny filtr autoryzacji psuje odpowiedzi

Poziom: **trudny**

## Uruchomienie

```bash
# raz, z katalogu głównego ćwiczeń (backendy users :8081 i orders :8082)
./scripts/start-backends.sh

# gateway z tego scenariusza (port 8080)
cd scenarios/12-wlasny-filtr-globalny
mvn spring-boot:run

# w drugim terminalu: automatyczne sprawdzenie
./scenarios/12-wlasny-filtr-globalny/check.sh
```

## Zgłoszenie

W gatewayu dodano globalny filtr `ApiKeyFilter`: sprawdza nagłówek `X-Api-Key` i przekazuje do backendu nagłówek `X-Client-Id`. Żądania bez klucza są poprawnie odrzucane z 401, ale z poprawnym kluczem też coś jest nie tak.

```bash
curl -i http://localhost:8080/api/users/1                            # 401, OK
curl -i -H 'X-Api-Key: kurs-2026' http://localhost:8080/api/users/1  # ???
```

**Oczekiwane:** z poprawnym kluczem odpowiedź pochodzi z backendu `users`, a backend widzi nagłówek `X-Client-Id: kurs-app`.

**Uwaga:** w filtrze są **dwa** błędy. Po naprawieniu pierwszego objaw się zmieni.

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
