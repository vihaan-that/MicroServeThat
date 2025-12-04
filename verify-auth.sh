#!/bin/bash

# Authentication Test Script
# This script helps verify the authentication setup

echo "🔐 Authentication Setup Verification Script"
echo "==========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Keycloak is running
echo "1️⃣ Checking Keycloak..."
if curl -s http://localhost:8181/realms/test-client/.well-known/openid-configuration > /dev/null; then
    echo -e "${GREEN}✅ Keycloak is running and test-client realm is accessible${NC}"
else
    echo -e "${RED}❌ Keycloak is not accessible at http://localhost:8181${NC}"
    echo "   Run: cd api-gateway && docker-compose up -d"
    exit 1
fi

# Check if API Gateway is running
echo ""
echo "2️⃣ Checking API Gateway..."
if curl -s http://localhost:9000/actuator/health > /dev/null; then
    echo -e "${GREEN}✅ API Gateway is running${NC}"
else
    echo -e "${RED}❌ API Gateway is not accessible at http://localhost:9000${NC}"
    echo "   Run: cd api-gateway && ./mvnw spring-boot:run"
    exit 1
fi

# Check if Product Service is running
echo ""
echo "3️⃣ Checking Product Service..."
if curl -s http://localhost:9000/api/product > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Product Service is accessible through API Gateway${NC}"
else
    echo -e "${YELLOW}⚠️  Product Service might not be running${NC}"
    echo "   Run: cd product-service && ./mvnw spring-boot:run"
fi

# Try to get a token
echo ""
echo "4️⃣ Testing Token Acquisition..."
TOKEN_RESPONSE=$(curl -s -X POST "http://localhost:8181/realms/test-client/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=testuser" \
  -d "password=test123" \
  -d "grant_type=password" \
  -d "client_id=react-client")

if echo "$TOKEN_RESPONSE" | grep -q "access_token"; then
    echo -e "${GREEN}✅ Successfully obtained access token${NC}"
    ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
    echo "   Token preview: ${ACCESS_TOKEN:0:50}..."
    
    # Test API with token
    echo ""
    echo "5️⃣ Testing Authenticated API Call..."
    API_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X GET "http://localhost:9000/api/product" \
      -H "Authorization: Bearer $ACCESS_TOKEN")
    
    if [ "$API_RESPONSE" = "200" ]; then
        echo -e "${GREEN}✅ Authenticated API call successful (HTTP $API_RESPONSE)${NC}"
    else
        echo -e "${RED}❌ Authenticated API call failed (HTTP $API_RESPONSE)${NC}"
    fi
    
    # Test POST request
    echo ""
    echo "6️⃣ Testing POST Request (Add Product)..."
    POST_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "http://localhost:9000/api/product" \
      -H "Authorization: Bearer $ACCESS_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
        "skuCode": "TEST-'$(date +%s)'",
        "name": "Test Product",
        "description": "This is a test product created by verification script",
        "price": 99.99
      }')
    
    if [ "$POST_RESPONSE" = "201" ] || [ "$POST_RESPONSE" = "200" ]; then
        echo -e "${GREEN}✅ POST request successful (HTTP $POST_RESPONSE)${NC}"
    else
        echo -e "${RED}❌ POST request failed (HTTP $POST_RESPONSE)${NC}"
        echo "   This is the issue you're experiencing. Check the steps below."
    fi
else
    echo -e "${RED}❌ Failed to obtain access token${NC}"
    echo "   Response: $TOKEN_RESPONSE"
    echo "   Check Keycloak configuration"
fi

echo ""
echo "==========================================="
echo "📊 Summary"
echo "==========================================="
echo ""
echo "Next steps:"
echo "1. Visit http://localhost:3000/debug-auth to check frontend authentication"
echo "2. Sign in with: testuser / test123"
echo "3. Verify access token is present in debug page"
echo "4. Try adding a product at http://localhost:3000/add-product"
echo ""
echo "If issues persist, check:"
echo "- Browser console for errors (F12)"
echo "- API Gateway logs for JWT validation errors"
echo "- Keycloak logs: docker logs keycloak"
echo ""
