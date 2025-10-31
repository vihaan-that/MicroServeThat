package com.vihaanthat.gateway.config;

import java.util.Arrays;
import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.security.oauth2.jwt.JwtDecoder;

@Configuration
public class SecurityConfig {
    // Allow Swagger/OpenAPI and related static resources. Explicitly include the
    // gateway proxy endpoints for each downstream service so they are always allowed.
    private final String[] freeResourceUrls = {
            "/swagger-ui.html",
            "/swagger-ui/**",
            "/v3/api-docs/**",
            "/v3/api-docs",
            "/api-docs/**",
            "/api-docs",
            "/swagger-resources/**",
            "/webjars/**",
            "/aggregate/**",
            "/product-service/api-docs",
            "/product-service/api-docs/**",
            "/order-service/api-docs",
            "/order-service/api-docs/**",
            "/inventory-service/api-docs",
            "/inventory-service/api-docs/**",
            "/product-service/swagger-ui/**",
            "/order-service/swagger-ui/**",
            "/inventory-service/swagger-ui/**",
            // Allow the internal fallback route to be forwarded to by the circuit breaker
            "/fallbackRoute",
            // Expose actuator for local debugging
            "/actuator/**",
            // Allow public product endpoints (both public and api-prefixed variants)
            "/product",
            "/product/**",
            "/api/product",
            "/api/product/**"
    };

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        // Permit the Swagger/OpenAPI endpoints (GET requests) and require authentication for everything else.
        // Also disable CSRF (Swagger UI won't send CSRF tokens) and keep resource server JWT enabled.
        return httpSecurity
                .cors(Customizer.withDefaults()) // Enable CORS
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers(HttpMethod.GET, freeResourceUrls).permitAll()
                        .anyRequest().authenticated()
                )
                .csrf(csrf -> csrf.disable())
                .oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()))
                .build();
    }

   @Bean
   CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of("http://localhost:3000"));
        configuration.setAllowedMethods(Arrays.asList("GET","POST","PUT","DELETE","OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
 
}