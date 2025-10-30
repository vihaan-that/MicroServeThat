package com.vihaanthat.microservices.order.service;

import com.vihaanthat.microservices.order.client.InventoryClient;
import com.vihaanthat.microservices.order.dto.OrderRequest;
import com.vihaanthat.microservices.order.model.Order;
import com.vihaanthat.microservices.order.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional

public class OrderService {
    private final OrderRepository orderRepository;
    private final InventoryClient inventoryClient;

    public void placeOrder(OrderRequest orderRequest) {

        boolean inStock = inventoryClient.isInStock(orderRequest.skuCode(),orderRequest.quantity());

        if(inStock) {
            var order = mapToOrder(orderRequest);
            orderRepository.save(order);
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
