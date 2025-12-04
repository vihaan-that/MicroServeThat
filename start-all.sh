#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_DIR="/home/vihaan/Documents/sem7/microservices-k8s"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Microservices Startup Script${NC}"
echo -e "${BLUE}========================================${NC}"

# Function to wait for a service to be ready
wait_for_port() {
    local host=$1
    local port=$2
    local service=$3
    local max_attempts=30
    local attempt=1
    
    echo -e "${YELLOW}Waiting for $service on port $port...${NC}"
    while ! nc -z $host $port 2>/dev/null; do
        if [ $attempt -ge $max_attempts ]; then
            echo -e "${RED}$service failed to start after $max_attempts attempts${NC}"
            return 1
        fi
        sleep 2
        ((attempt++))
    done
    echo -e "${GREEN}$service is ready!${NC}"
    return 0
}

# Step 1: Start Infrastructure
echo -e "\n${YELLOW}Step 1: Starting Infrastructure Services...${NC}"

# Start MongoDB (product-service)
echo -e "${BLUE}Starting MongoDB...${NC}"
cd "$PROJECT_DIR/product-service"
docker compose up -d 2>/dev/null

# Start MySQL, Kafka, Zookeeper, Schema Registry (order-service)
echo -e "${BLUE}Starting MySQL, Kafka, Zookeeper, Schema Registry...${NC}"
cd "$PROJECT_DIR/order-service"
docker compose up -d 2>/dev/null

# Start Inventory MySQL
echo -e "${BLUE}Starting Inventory MySQL...${NC}"
cd "$PROJECT_DIR/inventory-service"
docker compose up -d 2>/dev/null

# Start Keycloak, Grafana Stack (api-gateway)
echo -e "${BLUE}Starting Keycloak, Loki, Prometheus, Tempo, Grafana...${NC}"
cd "$PROJECT_DIR/api-gateway"
docker compose up -d 2>/dev/null

# Wait for infrastructure to be ready
echo -e "\n${YELLOW}Step 2: Waiting for Infrastructure...${NC}"
wait_for_port localhost 27017 "MongoDB"
wait_for_port localhost 3306 "MySQL"
wait_for_port localhost 9092 "Kafka"
wait_for_port localhost 8085 "Schema Registry"
wait_for_port localhost 8181 "Keycloak"
wait_for_port localhost 3100 "Loki"
wait_for_port localhost 9090 "Prometheus"
wait_for_port localhost 3000 "Grafana"

sleep 5  # Extra wait for services to stabilize

# Step 3: Build the project
echo -e "\n${YELLOW}Step 3: Building Project...${NC}"
cd "$PROJECT_DIR"
mvn clean compile -q
if [ $? -ne 0 ]; then
    echo -e "${RED}Build failed! Please fix compilation errors.${NC}"
    exit 1
fi
echo -e "${GREEN}Build successful!${NC}"

# Step 4: Start Microservices
echo -e "\n${YELLOW}Step 4: Starting Microservices...${NC}"

# Start product-service (port 8080)
echo -e "${BLUE}Starting product-service on port 8080...${NC}"
cd "$PROJECT_DIR/product-service"
mvn spring-boot:run -q > /tmp/product-service.log 2>&1 &
PRODUCT_PID=$!
echo "product-service PID: $PRODUCT_PID"

# Start inventory-service (port 8082)
echo -e "${BLUE}Starting inventory-service on port 8082...${NC}"
cd "$PROJECT_DIR/inventory-service"
mvn spring-boot:run -q > /tmp/inventory-service.log 2>&1 &
INVENTORY_PID=$!
echo "inventory-service PID: $INVENTORY_PID"

# Wait for inventory-service before starting order-service
sleep 10
wait_for_port localhost 8082 "Inventory Service"

# Start order-service (port 8081)
echo -e "${BLUE}Starting order-service on port 8081...${NC}"
cd "$PROJECT_DIR/order-service"
mvn spring-boot:run -q > /tmp/order-service.log 2>&1 &
ORDER_PID=$!
echo "order-service PID: $ORDER_PID"

# Start notification-service (port 8083)
echo -e "${BLUE}Starting notification-service on port 8083...${NC}"
cd "$PROJECT_DIR/notification-service"
mvn spring-boot:run -q > /tmp/notification-service.log 2>&1 &
NOTIFICATION_PID=$!
echo "notification-service PID: $NOTIFICATION_PID"

# Wait for services before starting api-gateway
sleep 15
wait_for_port localhost 8080 "Product Service"
wait_for_port localhost 8081 "Order Service"

# Start api-gateway (port 9000)
echo -e "${BLUE}Starting api-gateway on port 9000...${NC}"
cd "$PROJECT_DIR/api-gateway"
mvn spring-boot:run -q > /tmp/api-gateway.log 2>&1 &
GATEWAY_PID=$!
echo "api-gateway PID: $GATEWAY_PID"

# Wait for api-gateway
sleep 10
wait_for_port localhost 9000 "API Gateway"

# Save PIDs to file for stopping later
echo "$PRODUCT_PID" > /tmp/microservices-pids.txt
echo "$INVENTORY_PID" >> /tmp/microservices-pids.txt
echo "$ORDER_PID" >> /tmp/microservices-pids.txt
echo "$NOTIFICATION_PID" >> /tmp/microservices-pids.txt
echo "$GATEWAY_PID" >> /tmp/microservices-pids.txt

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}  All Services Started Successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n${BLUE}Service URLs:${NC}"
echo -e "  API Gateway:        http://localhost:9000"
echo -e "  Product Service:    http://localhost:8080"
echo -e "  Order Service:      http://localhost:8081"
echo -e "  Inventory Service:  http://localhost:8082"
echo -e "  Notification Svc:   http://localhost:8083"
echo -e "\n${BLUE}Infrastructure URLs:${NC}"
echo -e "  Keycloak:           http://localhost:8181 (admin/admin)"
echo -e "  Grafana:            http://localhost:3000"
echo -e "  Prometheus:         http://localhost:9090"
echo -e "  Kafka UI:           http://localhost:8086"
echo -e "\n${BLUE}Swagger UI:${NC}"
echo -e "  http://localhost:9000/swagger-ui.html"
echo -e "\n${BLUE}Logs:${NC}"
echo -e "  tail -f /tmp/product-service.log"
echo -e "  tail -f /tmp/order-service.log"
echo -e "  tail -f /tmp/inventory-service.log"
echo -e "  tail -f /tmp/notification-service.log"
echo -e "  tail -f /tmp/api-gateway.log"
echo -e "\n${YELLOW}To stop all services, run: ./stop-all.sh${NC}"
