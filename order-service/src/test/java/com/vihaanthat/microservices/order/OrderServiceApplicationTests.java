package com.vihaanthat.microservices.order;

import com.vihaanthat.microservices.order.stubs.InventoryClientStub;
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import org.junit.Before;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.cloud.contract.wiremock.AutoConfigureWireMock;
import org.springframework.context.annotation.Import;
import org.springframework.web.client.RestTemplate;
import org.testcontainers.containers.MySQLContainer;
import org.hamcrest.Matchers;
import static org.hamcrest.MatcherAssert.assertThat;
@Import(TestcontainersConfiguration.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureWireMock(port = 0)
class OrderServiceApplicationTests {
    @ServiceConnection
    static MySQLContainer mySQLContainer = new MySQLContainer("mysql:8.0.33");

    @LocalServerPort
    private Integer port;

    static {
        mySQLContainer.start();
    }

    @BeforeEach
    void setUp() {
        RestAssured.baseURI = "http://localhost";
        RestAssured.port = port;
    }

    @Test
    void shouldSubmitOrder() {
        String submitOrderJson = """
                {
                    "skuCode": "iphone_13",
                    "price": 999.99,
                    "quantity": 1
                }
                """;

        // Register the WireMock stub before making the request
        InventoryClientStub.stubInventoryCall("iphone_13", 1);

        var responseBodyString = RestAssured.given()
                .contentType(ContentType.JSON)
                .body(submitOrderJson)
                .when()
                .post("/api/order")
                .then()
                .log().all()
                .statusCode(201)
                .extract().body().asString();

        assert(responseBodyString.equals("Order Placed Successfully"));
    }
    @Test
    void shouldFailToSubmitOrderWhenItemNotInStock() {
        String submitOrderJson = """
                {
                    "skuCode": "iphone_13",
                    "price": 999.99,
                    "quantity": 1000
                }
                """;

        // Register the WireMock stub before making the request
        InventoryClientStub.stubInventoryCall("iphone_13", 1000);
        var responseBodyString = RestAssured.given()
                .contentType(ContentType.JSON)
                .body(submitOrderJson)
                .when()
                .post("/api/order")
                .then()
                .log().all()
                .statusCode(400)
                .extract().body().asString();

        assert(responseBodyString.equals("Product iphone_13 is not in stock"));
    }
}
