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


1 - exchange.getRequest().getHeaders().add("X-Client-Id", "kurs-app");

W Spring WebFlux nagłówki otrzymanego żądania są udostępniane jako niemodyfikowalne dlatego nie mozna wykonac .add()

zamias tego mozna uzyc mutate()


2- nieprawidłowe wywołanie chain.filter()

chain.filter(exchange);
return Mono.empty();

chain.filter(exchange) odpowiada za przekazanie żądania dalej, czyli do kolejnych filtrów, a ostatecznie do backendu

Problem polega na tym, że metoda zwraca Mono, które opisuje operację do wykonania, ale my ignorujemy ten wynik

return Mono.empty();

zwraca pustą operację zakończoną sukcesem, zamiast przekazać Springowi dalsze przetwarzanie żądania

poprawka :

return chain.filter(newExchange);

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.





























mutate() – pozwala zmodyfikować żądanie bez bezpośredniej zmiany oryginalnego obiektu
chain.filter(exchange) – przekazuje żądanie do dalszego łańcucha filtrów
return chain.filter(exchange) – zwraca operację dalszego przetwarzania, aby framework reaktywny mógł ją wykonać
return Mono.empty() – kończy przetwarzanie bez przekazywania żądania dalej
