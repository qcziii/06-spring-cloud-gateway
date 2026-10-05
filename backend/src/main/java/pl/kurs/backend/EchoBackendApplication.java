package pl.kurs.backend;

import java.time.Duration;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.TreeMap;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.server.RequestPredicates;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import org.springframework.web.server.WebFilter;
import reactor.core.publisher.Mono;

/**
 * Backend "echo": odsyła JSON z tym, co faktycznie do niego dotarło
 * (metoda, ścieżka, query, nagłówki). Dzięki temu widać, co gateway zrobił z żądaniem.
 *
 * Specjalne zachowania:
 *  - ?delay=3000      -> odpowiedź opóźniona o 3000 ms
 *  - ?status=503      -> odpowiedź z podanym kodem HTTP
 *  - ścieżka zaczynająca się od prefiksu innego niż app.accepted-prefix -> 404
 *  - nagłówek Origin  -> backend sam dokłada nagłówki CORS (jak "nadgorliwy" zespół backendu)
 */
@SpringBootApplication
public class EchoBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(EchoBackendApplication.class, args);
    }

    @Value("${app.service-name}")
    private String serviceName;

    /**
     * Backend obsługuje tylko ścieżki zaczynające się od tego prefiksu, np. /users.
     * W konfiguracji podawany bez wiodącego "/" (np. "users"): Git Bash na Windows
     * zamienia wartości zaczynające się od "/" na ścieżki Windows (C:/Program Files/Git/...).
     */
    private final String acceptedPrefix;

    EchoBackendApplication(@Value("${app.accepted-prefix}") String acceptedPrefix) {
        this.acceptedPrefix = "/" + acceptedPrefix.replaceAll("^/+", "");
    }

    @Bean
    RouterFunction<ServerResponse> echo() {
        return RouterFunctions.route(RequestPredicates.all(), this::handle);
    }

    private Mono<ServerResponse> handle(ServerRequest request) {
        return request.bodyToMono(String.class).defaultIfEmpty("").flatMap(body -> {
            Map<String, Object> result = new LinkedHashMap<>();
            result.put("service", serviceName);
            result.put("method", request.method().name());
            result.put("path", request.path());
            result.put("query", request.queryParams().toSingleValueMap());
            Map<String, String> headers = new TreeMap<>(String.CASE_INSENSITIVE_ORDER);
            request.headers().asHttpHeaders().forEach((k, v) -> headers.put(k, String.join(",", v)));
            result.put("headers", headers);
            if (!body.isEmpty()) {
                result.put("body", body);
            }

            if (!request.path().equals(acceptedPrefix) && !request.path().startsWith(acceptedPrefix + "/")) {
                result.put("error", serviceName + " nie zna ścieżki " + request.path()
                        + " (obsługuje tylko " + acceptedPrefix + "/**)");
                return ServerResponse.status(HttpStatus.NOT_FOUND)
                        .contentType(MediaType.APPLICATION_JSON).bodyValue(result);
            }

            int status = request.queryParam("status").map(Integer::parseInt).orElse(200);
            long delay = request.queryParam("delay").map(Long::parseLong).orElse(0L);
            Mono<ServerResponse> response = ServerResponse.status(status)
                    .contentType(MediaType.APPLICATION_JSON).bodyValue(result);
            return delay > 0 ? Mono.delay(Duration.ofMillis(delay)).then(response) : response;
        });
    }

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
}
