package com.vihaanthat.microservices.product_service.service;

import com.vihaanthat.microservices.product_service.dto.ProductRequest;
import com.vihaanthat.microservices.product_service.dto.ProductResponse;
import com.vihaanthat.microservices.product_service.model.Product;
import com.vihaanthat.microservices.product_service.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j

public class ProductService {
    private final ProductRepository productRepository;

    public ProductResponse createProduct(ProductRequest productRequest) {
        Product product = Product.builder()
                .name(productRequest.name())
                .description(productRequest.description())
                .price(productRequest.price().doubleValue())
                .build();
        productRepository.save(product);
        log.info("Created product with id {}", product.getId());
        return (new ProductResponse(
                        product.getId(),
                        product.getName(),
                        product.getDescription(),
                        java.math.BigDecimal.valueOf(product.getPrice())));

    }


    public List<ProductResponse> getAllProducts() {
        return productRepository.findAll()
                .stream()
                .map(product -> new ProductResponse(
                        product.getId(),
                        product.getName(),
                        product.getDescription(),
                        java.math.BigDecimal.valueOf(product.getPrice())
                )).toList();
    }
}
