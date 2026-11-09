package pl.kurs.gateway;

import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * Simple API key authorization: every request must have the X-Api-Key header.
 * After successful verification we pass the X-Client-Id header to the backend.
 */
@Component
public class ApiKeyFilter implements GlobalFilter, Ordered {

    static final String API_KEY = "kurs-2026";

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        String key = exchange.getRequest().getHeaders().getFirst("X-Api-Key");
        if (!API_KEY.equals(key)) {
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }

        exchange.getRequest().getHeaders().add("X-Client-Id", "kurs-app");

        chain.filter(exchange);
        return Mono.empty();
    }

    @Override
    public int getOrder() {
        return -1;
    }
}
