package com.vihaanthat.microservices.order.repository;

import com.vihaanthat.microservices.order.model.Order;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderRepository extends JpaRepository<Order, Long> {



}
