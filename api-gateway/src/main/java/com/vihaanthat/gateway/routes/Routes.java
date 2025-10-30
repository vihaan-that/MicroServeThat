package com.vihaanthat.gateway.routes;

import org.springframework.boot.autoconfigure.web.servlet.DispatcherServletPath;
import org.springframework.cloud.gateway.server.mvc.handler.GatewayRouterFunctions;
import org.springframework.cloud.gateway.server.mvc.handler.HandlerFunctions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.web.servlet.function.HandlerFunction;
import org.springframework.web.servlet.function.RequestPredicates;
import org.springframework.web.servlet.function.RouterFunction;
import org.springframework.web.servlet.function.ServerRequest;
import org.springframework.web.servlet.function.ServerResponse;

import java.net.URI;

import static org.springframework.cloud.gateway.server.mvc.filter.CircuitBreakerFilterFunctions.circuitBreaker;
import static org.springframework.cloud.gateway.server.mvc.filter.FilterFunctions.setPath;
import static org.springframework.cloud.gateway.server.mvc.handler.GatewayRouterFunctions.route;
import static org.springframework.cloud.gateway.server.mvc.handler.HandlerFunctions.http;

@Configuration
public class Routes {

    // Helper that delegates to the built-in http(...) handler, inspects the downstream status,
    // and throws a RuntimeException when the response status is not 2xx. Throwing an exception
    // ensures the circuit breaker filter treats the call as a failure and invokes the fallback.
    private HandlerFunction<ServerResponse> httpWithStatusCheck(String uri) {
        HandlerFunction<ServerResponse> delegate = http(uri);
        return (ServerRequest request) -> {
            ServerResponse resp = delegate.handle(request);
            HttpStatusCode status = resp.statusCode();
            if (!status.is2xxSuccessful()) {
                throw new RuntimeException("Downstream returned non-2xx status: " + status.value());
            }
            return resp;
        };
    }

    @Bean
    public RouterFunction<ServerResponse> productServiceRoute() {
        return route("product_service")
                // Match /api/product and /api/product/** (downstream-native paths)
                .route(
                        RequestPredicates.path("/api/product").or(RequestPredicates.path("/api/product/**")),
                        // use wrapper so non-2xx results are turned into exceptions (and trigger fallback)
                        httpWithStatusCheck("http://localhost:8080")
                )
                .filter(circuitBreaker("productServiceCircuitBreaker", URI.create("forward:/fallbackRoute")))
                .build();
    }

    // Public-facing route: map /product and /product/** -> downstream /api/** so clients can use either path
    @Bean
    public RouterFunction<ServerResponse> productServicePublicRoute() {
        return route("product_service_public")
                .route(
                        RequestPredicates.path("/product").or(RequestPredicates.path("/product/**")),
                        // Forward to the downstream service with an /api prefix so /product/1 -> http://localhost:8080/api/product/1
                        httpWithStatusCheck("http://localhost:8080/api")
                )
                .filter(circuitBreaker("productServiceCircuitBreaker", URI.create("forward:/fallbackRoute")))
                .build();
    }

    @Bean
    public RouterFunction<ServerResponse> productServiceSwaggerRoute(DispatcherServletPath dispatcherServletPath) {
        return route("product_service_swagger")
                .route(RequestPredicates.path("/product-service/api-docs"), http("http://localhost:8080"))
                .filter(circuitBreaker("productServiceSwaggerCircuitBreaker", URI.create("forward:/fallbackRoute")))
                // downstream services expose OpenAPI JSON at /api-docs (configured in their application.properties)
                .filter(setPath("/api-docs"))
                .build();
    }

    @Bean
    public RouterFunction<ServerResponse> orderServiceRoute() {
        return route("order_service")
                .route(RequestPredicates.path("/api/order/**"), http("http://localhost:8081"))
                .filter(circuitBreaker("orderServiceCircuitBreaker", URI.create("forward:/fallbackRoute")))
                .build();
    }

    @Bean
    public RouterFunction<ServerResponse> orderServiceSwaggerRoute(DispatcherServletPath dispatcherServletPath) {
        return route("order_service_swagger")
                .route(RequestPredicates.path("/order-service/api-docs"), http("http://localhost:8081"))
                .filter(circuitBreaker("orderServiceSwaggerCircuitBreaker", URI.create("forward:/fallbackRoute")))
                .filter(setPath("/api-docs"))
                .build();
    }

    @Bean
    public RouterFunction<ServerResponse> inventoryServiceRoute() {
        return route("inventory_service")
                .route(RequestPredicates.path("/api/inventory/**"), http("http://localhost:8082"))
                .filter(circuitBreaker("inventoryServiceCircuitBreaker", URI.create("forward:/fallbackRoute")))
                .build();
    }

    // Proxy the downstream services' OpenAPI JSON to gateway paths so Swagger UI can fetch them.
    @Bean
    public RouterFunction<ServerResponse> inventoryServiceSwaggerRoute(DispatcherServletPath dispatcherServletPath) {
        return route("inventory_service_swagger")
                .route(RequestPredicates.path("/inventory-service/api-docs"), http("http://localhost:8082"))
                .filter(circuitBreaker("inventoryServiceSwaggerCircuitBreaker", URI.create("forward:/fallbackRoute")))
                .filter(setPath("/api-docs"))
                .build();
    }

    @Bean
    public RouterFunction<ServerResponse> fallbackRoute() {
        return route("fallback_route")
                .GET("/fallbackRoute", request -> ServerResponse.status(HttpStatus.SERVICE_UNAVAILABLE).body("Service is currently unavailable. Please try again later."))
                .build();
    }
}