package com.vihaanthat.microservices.order;

import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import org.junit.Before;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.context.annotation.Import;
import org.springframework.web.client.RestTemplate;
import org.testcontainers.containers.MySQLContainer;
import org.hamcrest.Matchers;
import static org.hamcrest.MatcherAssert.assertThat;
@Import(TestcontainersConfiguration.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)

class OrderServiceApplicationTests {
    @ServiceConnection
    static MySQLContainer mySQLContainer = new MySQLContainer("mysql:8.3.0");
    @LocalServerPort
    private Integer port;

    @BeforeEach
    void setUp() {
        RestAssured.baseURI = "http://localhost";
        RestAssured.port = port;
    }
    static{
        mySQLContainer.start();
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

}
