#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Microservices Shutdown Script${NC}"
echo -e "${BLUE}========================================${NC}"

PROJECT_DIR="/home/vihaan/Documents/sem7/microservices-k8s"

# Step 1: Stop Spring Boot services
echo -e "\n${YELLOW}Step 1: Stopping Spring Boot Services...${NC}"

if [ -f /tmp/microservices-pids.txt ]; then
    while read pid; do
        if ps -p $pid > /dev/null 2>&1; then
            echo -e "${BLUE}Stopping process $pid...${NC}"
            kill $pid 2>/dev/null
        fi
    done < /tmp/microservices-pids.txt
    rm /tmp/microservices-pids.txt
    echo -e "${GREEN}Spring Boot services stopped.${NC}"
else
    echo -e "${YELLOW}No PID file found. Attempting to kill by port...${NC}"
    # Kill by port if PID file not found
    for port in 8080 8081 8082 8083 9000; do
        pid=$(lsof -t -i:$port 2>/dev/null)
        if [ -n "$pid" ]; then
            echo -e "${BLUE}Killing process on port $port (PID: $pid)${NC}"
            kill $pid 2>/dev/null
        fi
    done
fi

# Also kill any remaining mvn processes
pkill -f "spring-boot:run" 2>/dev/null

# Step 2: Stop Docker containers (optional)
echo -e "\n${YELLOW}Step 2: Stop Docker containers? (y/n)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${BLUE}Stopping Docker containers...${NC}"
    
    cd "$PROJECT_DIR/product-service"
    docker compose down 2>/dev/null
    
    cd "$PROJECT_DIR/order-service"
    docker compose down 2>/dev/null
    
    cd "$PROJECT_DIR/inventory-service"
    docker compose down 2>/dev/null
    
    cd "$PROJECT_DIR/api-gateway"
    docker compose down 2>/dev/null
    
    echo -e "${GREEN}Docker containers stopped.${NC}"
else
    echo -e "${YELLOW}Docker containers left running.${NC}"
fi

# Clean up log files
echo -e "\n${YELLOW}Clean up log files? (y/n)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    rm -f /tmp/product-service.log
    rm -f /tmp/order-service.log
    rm -f /tmp/inventory-service.log
    rm -f /tmp/notification-service.log
    rm -f /tmp/api-gateway.log
    echo -e "${GREEN}Log files cleaned up.${NC}"
fi

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}  Shutdown Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
