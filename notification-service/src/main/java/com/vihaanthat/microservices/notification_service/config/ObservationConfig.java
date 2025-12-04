package com.vihaanthat.microservices.notification_service.config;

import io.micrometer.observation.ObservationRegistry;
import io.micrometer.observation.aop.ObservedAspect;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;

@Configuration
public class ObservationConfig {

    @Autowired(required = false)
    private ConcurrentKafkaListenerContainerFactory<?, ?> kafkaListenerContainerFactory;

    @PostConstruct
    public void configureKafkaObservation() {
        if (kafkaListenerContainerFactory != null) {
            kafkaListenerContainerFactory.getContainerProperties().setObservationEnabled(true);
        }
    }
    
    @Bean
    public ObservedAspect observedAspect(ObservationRegistry observationRegistry) {
        return new ObservedAspect(observationRegistry);
    }
}
