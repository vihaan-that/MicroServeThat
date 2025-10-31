import { useState, useEffect, useRef } from 'react'
import { useSession } from 'next-auth/react'
import { useRouter } from 'next/router'
import { getProducts } from '../services/productService'
import { orderProduct } from '../services/orderService'

/**
 * HomePage Component
 * Converted from Angular HomePageComponent
 * Displays product list and handles order placement
 */
export default function HomePage() {
  const { data: session, status } = useSession()
  const router = useRouter()
  
  // Equivalent to Angular component properties
  const isAuthenticated = status === 'authenticated'
  const [products, setProducts] = useState([])
  const [quantityIsNull, setQuantityIsNull] = useState(false)
  const [orderSuccess, setOrderSuccess] = useState(false)
  const [orderFailed, setOrderFailed] = useState(false)
  const [loading, setLoading] = useState(true)

  // Store quantity refs for each product
  const quantityRefs = useRef({})

  // Equivalent to Angular's ngOnInit - fetch products on mount
  useEffect(() => {
    async function fetchProducts() {
      try {
        setLoading(true)
        const accessToken = session?.accessToken || null
        const fetchedProducts = await getProducts(accessToken)
        console.log('Fetched products:', fetchedProducts)
        setProducts(fetchedProducts)
      } catch (error) {
        console.error('Error fetching products:', error)
        setProducts([])
      } finally {
        setLoading(false)
      }
    }

    fetchProducts()
  }, [session])

  // Equivalent to Angular's goToCreateProductPage()
  const goToCreateProductPage = () => {
    router.push('/add-product')
  }

  // Equivalent to Angular's orderProduct()
  const handleOrderProduct = async (product, productId) => {
    const quantity = quantityRefs.current[productId]?.value

    console.log('Ordering product:', product)
    console.log('Product ID:', productId)

    if (!session || !session.user) {
      console.error('User not authenticated')
      return
    }

    // Check if product has a valid skuCode
    if (!product.skuCode) {
      alert('⚠️ This product cannot be ordered because it has no SKU Code.\n\nPlease create new products with valid SKU codes that match inventory entries.')
      return
    }

    if (!quantity) {
      setOrderFailed(true)
      setOrderSuccess(false)
      setQuantityIsNull(true)
      return
    }

    // Create order matching backend OrderRequest DTO format
    const order = {
      skuCode: product.skuCode,
      price: product.price,
      quantity: Number(quantity),
    }

    console.log('Order object being sent:', order)

    try {
      await orderProduct(order, session.accessToken)
      setOrderSuccess(true)
      setOrderFailed(false)
      setQuantityIsNull(false)
      
      // Clear the quantity input
      if (quantityRefs.current[productId]) {
        quantityRefs.current[productId].value = ''
      }
    } catch (error) {
      console.error('Error placing order:', error)
      setOrderFailed(true)
      setOrderSuccess(false)
      setQuantityIsNull(false)
    }
  }

  return (
    <main>
      <div className="p-4">
        <div className="flex justify-between items-center mb-4">
          <h1 className="text-2xl font-bold mb-4">
            Products ({loading ? '...' : products.length})
          </h1>
          {isAuthenticated && (
            <button
              className="bg-green-500 text-white px-4 py-2 rounded-lg hover:bg-green-600 ml-4"
              onClick={goToCreateProductPage}
            >
              Create Product
            </button>
          )}
        </div>

        {/* Warning banner for products without SKU codes */}
        {!loading && products.some(p => !p.skuCode) && (
          <div className="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4 mb-4">
            <p className="font-bold">⚠️ Warning: Some products cannot be ordered</p>
            <p className="text-sm mt-1">
              Products without SKU codes (highlighted in red) cannot be ordered.
              Please create new products with valid SKU codes that match inventory entries:
              <span className="font-mono text-xs block mt-1">
                iphone_13, iphone_13_red, samsung_galaxy_s21, etc.
              </span>
            </p>
          </div>
        )}

        {loading ? (
          <p className="text-gray-500">Loading products...</p>
        ) : products.length > 0 ? (
          <>
            {orderSuccess && (
              <h4 className="text-green-500 font-bold mb-4">Order Placed Successfully</h4>
            )}
            {orderFailed && (
              <>
                <h4 className="text-red-500 font-bold mb-2">Order Failed, please try again later</h4>
                {quantityIsNull && (
                  <h4 className="text-red-500 font-bold mb-4">Quantity cannot be null</h4>
                )}
              </>
            )}

            <ul className="list-disc list-inside">
              {products.map((product) => {
                const hasValidSkuCode = product.skuCode && product.skuCode.trim() !== ''
                return (
                  <li
                    key={product.id}
                    className={`mb-2 p-4 rounded-lg shadow-sm flex justify-between items-center ${
                      hasValidSkuCode ? 'bg-gray-100' : 'bg-red-50 border-2 border-red-300'
                    }`}
                  >
                    <div className="flex-1">
                      <span className="font-semibold">{product.name}</span> -
                      <span className="text-gray-600"> Price: ${product.price}</span>
                      <br />
                      <span className={`text-sm ${hasValidSkuCode ? 'text-gray-500' : 'text-red-600 font-bold'}`}>
                        SKU: {product.skuCode || '⚠️ MISSING - Cannot order this product'}
                      </span>
                      <br />
                      {hasValidSkuCode && (
                        <span>
                          Quantity:{' '}
                          <input
                            type="number"
                            min="1"
                            ref={(el) => (quantityRefs.current[product.id] = el)}
                            className="border border-gray-300 rounded px-2 py-1 w-20"
                          />
                        </span>
                      )}
                    </div>
                    <button
                      className={`px-4 py-2 rounded-lg ml-4 ${
                        hasValidSkuCode
                          ? 'bg-green-500 text-white hover:bg-green-600'
                          : 'bg-gray-400 text-gray-200 cursor-not-allowed'
                      }`}
                      onClick={() => handleOrderProduct(product, product.id)}
                      disabled={!hasValidSkuCode}
                    >
                      {hasValidSkuCode ? 'Order Now' : 'No SKU'}
                    </button>
                  </li>
                )
              })}
            </ul>

            {products.length === 100 && (
              <span className="text-sm text-gray-700">
                Click{' '}
                <a className="text-blue-500 hover:underline cursor-pointer">Load More</a> to see
                more products
              </span>
            )}
          </>
        ) : (
          <p className="text-red-500 font-semibold">No products found!</p>
        )}
      </div>
    </main>
  )
}
