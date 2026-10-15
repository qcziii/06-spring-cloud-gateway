# 10. Przeglądarka odrzuca odpowiedź przez CORS

Poziom: **średni**

## Uruchomienie

```bash
# raz, z katalogu głównego ćwiczeń (backendy users :8081 i orders :8082)
./scripts/start-backends.sh

# gateway z tego scenariusza (port 8080)
cd scenarios/10-cors
mvn spring-boot:run

# w drugim terminalu: automatyczne sprawdzenie
./scenarios/10-cors/check.sh
```

## Zgłoszenie

Aplikacja SPA z `http://localhost:3000` woła API przez gateway. CORS jest skonfigurowany w gatewayu (`globalcors`), preflight przechodzi, a mimo to przeglądarka odrzuca odpowiedź:

```
Access to fetch at 'http://localhost:8080/api/users/1' from origin 'http://localhost:3000' has been blocked by CORS policy:
The 'Access-Control-Allow-Origin' header contains multiple values 'http://localhost:3000, *', but only one is allowed.
```

Odtworzenie bez przeglądarki:
```bash
curl -si -H 'Origin: http://localhost:3000' http://localhost:8080/api/users/1 | grep -i access-control
```

**Oczekiwane:** odpowiedź ma dokładnie jeden nagłówek `Access-Control-Allow-Origin: http://localhost:3000`. Preflight z obcego originu nadal jest odrzucany. Nie zmieniaj backendu (to kod innego zespołu).

**Pytanie dodatkowe:** skąd pochodzi każda z dwóch wartości nagłówka?


Gateway, jak i backend dodają nagłówek Access-Control-Allow-Origin

allowed-origins: "http://localhost:3000" – pozwala aplikacji frontendowej działającej pod tym adresem odczytywać odpowiedzi API
oraz
 backend:

/** Backend "na wszelki wypadek" sam ustawia CORS dla każdego żądania z nagłówkiem Origin. */
@Bean
WebFilter naiveCors() {
return (exchange, chain) -> {
if (exchange.getRequest().getHeaders().getOrigin() != null) {
exchange.getResponse().getHeaders().add("Access-Control-Allow-Origin", "*");
}
return chain.filter(exchange);
};
}

Znak * oznacza dowolny origin

W rezultacie odpowiedź zawiera dwie wartości:
Access-Control-Allow-Origin: http://localhost:3000, *

Przeglądarka odrzuca taką odpowiedź, ponieważ nagłówek Access-Control-Allow-Origin nie może zawierać kilku wartości origin


DedupeResponseHeader – usuwa nadmiarowe wartości określonego nagłówka
Access-Control-Allow-Origin – wskazuje, który nagłówek chcemy poprawić
RETAIN_FIRST – pozostawia tylko pierwszą wartość nagłówka

default-filters:
- DedupeResponseHeader=Access-Control-Allow-Origin, RETAIN_FIRST



Przeglądarka odrzucała odpowiedź, ponieważ zarówno Gateway, jak i backend dodawały nagłówek Access-Control-Allow-Origin, przez co miał on dwie wartości.
Rozwiązaniem było dodanie filtra DedupeResponseHeader=Access-Control-Allow-Origin, RETAIN_FIRST, który pozostawia tylko pierwszą wartość nagłówka

http://localhost:3000 pochodzi z konfiguracji globalcors w Gateway, a * jest dodawane przez backend w metodzie naiveCors()

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
