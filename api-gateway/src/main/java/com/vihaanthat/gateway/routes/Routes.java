package com.vihaanthat.gateway.routes;

import org.springframework.boot.autoconfigure.web.servlet.DispatcherServletPath;
import org.springframework.cloud.gateway.server.mvc.handler.GatewayRouterFunctions;
import org.springframework.cloud.gateway.server.mvc.handler.HandlerFunctions;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.function.RequestPredicates;
import org.springframework.web.servlet.function.RouterFunction;
import org.springframework.web.servlet.function.ServerResponse;

import static org.springframework.cloud.gateway.server.mvc.filter.FilterFunctions.setPath;
import static org.springframework.cloud.gateway.server.mvc.handler.HandlerFunctions.http;

@Configuration
public class Routes {

    @Bean
    public RouterFunction<ServerResponse> productServiceRoute(){
        return GatewayRouterFunctions.route("product_service")
                .route(RequestPredicates.path("/api/product"), http("http://localhost:8080"))
                .build();
    }

    @Bean
    public RouterFunction<ServerResponse> orderServiceRoute(){
        return GatewayRouterFunctions.route("order_service")
                .route(RequestPredicates.path("/api/order"), http("http://localhost:8081"))
                .build();
    }
    @Bean
    public RouterFunction<ServerResponse> inventoryServiceRoute(){
        return GatewayRouterFunctions.route("inventory_service")
                .route(RequestPredicates.path("/api/inventory"), http("http://localhost:8082"))
                .build();
    }

    // Proxy the downstream services' OpenAPI JSON to gateway paths so Swagger UI can fetch them.
    @Bean
    public RouterFunction<ServerResponse> productServiceSwaggerRoute(DispatcherServletPath dispatcherServletPath){
        return GatewayRouterFunctions.route("product_service_swagger")
                .route(RequestPredicates.path("/product-service/api-docs"), http("http://localhost:8080"))
                // downstream services expose OpenAPI JSON at /api-docs (configured in their application.properties)
                .filter(setPath("/api-docs"))
                .build();
    }

    @Bean
    public RouterFunction<ServerResponse> orderServiceSwaggerRoute(DispatcherServletPath dispatcherServletPath){
        return GatewayRouterFunctions.route("order_service_swagger")
                .route(RequestPredicates.path("/order-service/api-docs"), http("http://localhost:8081"))
                .filter(setPath("/api-docs"))
                .build();
    }

    @Bean
    public RouterFunction<ServerResponse> inventoryServiceSwaggerRoute(DispatcherServletPath dispatcherServletPath){
        return GatewayRouterFunctions.route("inventory_service_swagger")
                .route(RequestPredicates.path("/inventory-service/api-docs"), http("http://localhost:8082"))
                .filter(setPath("/api-docs"))
                .build();
    }
}
