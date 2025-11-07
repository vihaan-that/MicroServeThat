#!/bin/bash
# Script to clean up MongoDB products and start fresh

echo "🧹 Cleaning up existing products from MongoDB..."

# Connect to MongoDB and drop the product collection
docker exec -it $(docker ps -qf "name=mongodb") mongosh productdb --eval "db.product.drop()"

echo "✅ Product collection cleared!"
echo ""
echo "📝 Next steps:"
echo "1. Go to http://localhost:3001"
echo "2. Click 'Create Product'"
echo "3. Create products with proper skuCodes that match inventory:"
echo "   - Use skuCode: 'iphone_13' (inventory has 100 units)"
echo "   - Use skuCode: 'samsung_galaxy_s21' (inventory has 100 units)"
echo "   - Or add more inventory entries in V2__add_inventory.sql"
echo ""
echo "⚠️  Remember: The skuCode MUST match an entry in the inventory service!"

