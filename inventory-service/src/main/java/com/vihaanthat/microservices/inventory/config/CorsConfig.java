package com.vihaanthat.microservices.inventory.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * CORS Configuration for Inventory Service
 * 
 * NOTE: In a microservices architecture with an API Gateway,
 * CORS should be handled at the Gateway level only to avoid duplicate headers.
 * 
 * This configuration is DISABLED when using the API Gateway.
 * If you need to access this service directly (e.g., for testing), 
 * uncomment the @Configuration annotation.
 */
// @Configuration  // DISABLED: API Gateway handles CORS
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedMethods("*")
                .allowedHeaders("*")
                .allowedOriginPatterns("*")
                .allowCredentials(false);
    }
}
