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

    if (!session || !session.user) {
      console.error('User not authenticated')
      return
    }

    // Extract user details from session
    const userDetails = {
      email: session.user.email || '',
      firstName: session.user.given_name || session.user.firstName || '',
      lastName: session.user.family_name || session.user.lastName || '',
    }

    if (!quantity) {
      setOrderFailed(true)
      setOrderSuccess(false)
      setQuantityIsNull(true)
      return
    }

    const order = {
      skuCode: product.skuCode,
      price: product.price,
      quantity: Number(quantity),
      userDetails: userDetails,
    }

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
              {products.map((product) => (
                <li
                  key={product.id}
                  className="mb-2 p-4 bg-gray-100 rounded-lg shadow-sm flex justify-between items-center"
                >
                  <div>
                    <span className="font-semibold">{product.name}</span> -
                    <span className="text-gray-600"> Price: {product.price}</span>
                    <br />
                    <span>
                      Quantity:{' '}
                      <input
                        type="number"
                        min="1"
                        ref={(el) => (quantityRefs.current[product.id] = el)}
                        className="border border-gray-300 rounded px-2 py-1 w-20"
                      />
                    </span>
                    <br />
                  </div>
                  <button
                    className="bg-green-500 text-white px-4 py-2 rounded-lg hover:bg-green-600 ml-4"
                    onClick={() => handleOrderProduct(product, product.id)}
                  >
                    Order Now
                  </button>
                </li>
              ))}
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
