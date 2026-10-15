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


INFO 17928 --- [gateway] [           main] o.s.boot.tomcat.TomcatWebServer          : Tomcat initialized with port 8080 (http)
INFO 17928 --- [gateway] [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
INFO 17928 --- [gateway] [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/11.0.24]

Tomcat, ponieważ spring-boot-starter-web wprowadza Spring MVC, a Spring Boot domyślnie wybiera środowisko Servlet, gdy ma zarówno MVC, jak i WebFlux

przyczyna :

Description:

Spring MVC found on classpath, which is incompatible with Spring Cloud Gateway.

Spring Cloud Gateway WebFlux wykrył niezgodność ze Spring MVC i przerwał uruchamianie aplikacji

skutki :

BeanCreationException: Error creating bean
Stopping service [Tomcat]
APPLICATION FAILED TO START
BUILD FAILURE

Spring nie mógł utworzyć komponentu, zatrzymał Tomcata i zakończył uruchamianie niepowodzeniem


wystarczy usunąć dependency:

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

## Kiedy skończysz

`check.sh` ma wypisać `WYNIK: wszystkie sprawdzenia przeszły`. Omówienie rozwiązania przedstawi prowadzący po zajęciach.
