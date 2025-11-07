#!/bin/bash
# Script to add sample products with correct skuCodes via API

API_URL="http://localhost:9000/api/product"

echo "📦 Adding sample products with correct skuCodes..."
echo ""

# Get access token (you'll need to be logged in)
echo "⚠️  Make sure you're logged in to get an access token!"
echo "You can get your token from: http://localhost:3001/debug-auth"
echo ""
read -p "Enter your access token: " ACCESS_TOKEN

if [ -z "$ACCESS_TOKEN" ]; then
    echo "❌ No token provided. Exiting..."
    exit 1
fi

# Product 1: iPhone 13
echo "Adding iPhone 13..."
curl -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{
    "name": "iPhone 13",
    "description": "Latest iPhone model with amazing features",
    "skuCode": "iphone_13",
    "price": 999
  }'
echo ""

# Product 2: iPhone 13 Red
echo "Adding iPhone 13 Red..."
curl -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{
    "name": "iPhone 13 Red",
    "description": "iPhone 13 in stunning red color",
    "skuCode": "iphone_13_red",
    "price": 999
  }'
echo ""

# Product 3: Samsung Galaxy S21
echo "Adding Samsung Galaxy S21..."
curl -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{
    "name": "Samsung Galaxy S21",
    "description": "Premium Android smartphone",
    "skuCode": "samsung_galaxy_s21",
    "price": 899
  }'
echo ""

echo "✅ Sample products added successfully!"
echo ""
echo "🔍 Check http://localhost:3001 to see the products"
echo "🛒 You should now be able to place orders successfully!"

