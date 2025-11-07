package com.vihaanthat.microservices.order.service;

import com.vihaanthat.microservices.order.client.InventoryClient;
import com.vihaanthat.microservices.order.dto.OrderRequest;
import com.vihaanthat.microservices.order.event.OrderPlacedEvent;
import com.vihaanthat.microservices.order.model.Order;
import com.vihaanthat.microservices.order.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.transaction.annotation.Transactional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional

public class OrderService {
    private static final Logger log = LoggerFactory.getLogger(OrderService.class);
    private final OrderRepository orderRepository;
    private final InventoryClient inventoryClient;
    private final KafkaTemplate<String, OrderPlacedEvent> kafkaTemplate;

    public void placeOrder(OrderRequest orderRequest) {

        boolean inStock = inventoryClient.isInStock(orderRequest.skuCode(),orderRequest.quantity());

        if(inStock) {
            var order = mapToOrder(orderRequest);
            orderRepository.save(order);
            var orderPlacedEvent = new OrderPlacedEvent(order.getOrderNumber(), orderRequest.userDetails()
                    .email(),
                    orderRequest.userDetails()
                            .firstName(),
                    orderRequest.userDetails()
                            .lastName());
            log.info("Start- Sending OrderPlacedEvent for order number: {}", order.getOrderNumber());
            kafkaTemplate.send("order-placed", orderPlacedEvent);
            log.info("End- Sending OrderPlacedEvent for order number: {}", order.getOrderNumber());
        } else {
            throw new RuntimeException("Product " + orderRequest.skuCode() + " is not in stock");
        }
    }
    public static Order mapToOrder(OrderRequest orderRequest) {
        Order order = new Order();
        order.setOrderNumber(UUID.randomUUID().toString());
        order.setQuantity(orderRequest.quantity());
        order.setPrice(orderRequest.price());
        order.setSkuCode(orderRequest.skuCode());
        return order;
    }
}
