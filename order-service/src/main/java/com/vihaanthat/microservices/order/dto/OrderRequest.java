package com.vihaanthat.microservices.order.dto;

public record OrderRequest(Long id, String orderNumber, String skuCode, java.math.BigDecimal price, Integer quantity) {
}
