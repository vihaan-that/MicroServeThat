package com.vihaanthat.microservices.order.config;

import org.flywaydb.core.Flyway;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;

import javax.sql.DataSource;

@Configuration
public class FlywayConfig {

    @Autowired
    private DataSource dataSource;

    @Bean(name = "flyway")
    public Flyway flyway() {
        Flyway flyway = Flyway.configure()
                .dataSource(dataSource)
                .baselineOnMigrate(true)
                .cleanOnValidationError(true)
                .validateOnMigrate(false)
                .load();
        
        try {
            // Try to repair the schema history
            flyway.repair();
            // Then migrate
            flyway.migrate();
        } catch (Exception e) {
            // If repair fails, try clean then migrate
            flyway.clean();
            flyway.migrate();
        }
        
        return flyway;
    }
}
