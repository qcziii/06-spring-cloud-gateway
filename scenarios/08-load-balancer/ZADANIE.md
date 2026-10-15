# 08. Trasa lb:// zwraca 503

Poziom: **trudny**

## Uruchomienie

```bash
# raz, z katalogu głównego ćwiczeń (backendy users :8081 i orders :8082)
./scripts/start-backends.sh

# gateway z tego scenariusza (port 8080)
cd scenarios/08-load-balancer
mvn spring-boot:run

# w drugim terminalu: automatyczne sprawdzenie
./scenarios/08-load-balancer/check.sh
```

## Zgłoszenie

Serwis `orders` ma być wołany przez nazwę z service discovery (`lb://`), a nie przez stały adres. Zamiast Eureki używamy tu `SimpleDiscoveryClient`: instancje są wpisane w `spring.cloud.discovery.client.simple.instances`.

```bash
curl -i http://localhost:8080/api/orders/7   # 503
```

W logach gatewaya nie ma nic podejrzanego.

**Oczekiwane:** `GET /api/orders/7` trafia do `orders` przez `lb://`.

**Uwaga:** w tym scenariuszu są **dwa** błędy. Po naprawieniu pierwszego wynik się nie zmieni, ale zmienią się logi.


1 - brak dependency :

<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-loadbalancer</artifactId>
</dependency>

2 - nazwy nie są takie same :

            orders-service:
              - uri: http://localhost:8082

              uri: lb://order-service

trzeba zmienic na uri: lb://orders-service

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.























Service Discovery – pozwala znaleźć adres mikroserwisu na podstawie jego nazwy.

Load Balancer – pozwala wybrać instancję mikroserwisu, do której zostanie wysłane żądanie.

jak działa lb://
W poprzednich zadaniach mieliśmy:
uri: http://localhost:8082


Gateway wiedział od razu, że Orders Service działa na porcie 8082.
Teraz mamy:
uri: lb://order-service


To oznacza:
„Gateway, znajdź instancję mikroserwisu o nazwie order-service i przekaż do niej żądanie”.