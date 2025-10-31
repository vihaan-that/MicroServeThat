import { useSession } from 'next-auth/react'
import { useState, useEffect } from 'react'
import Header from '../components/Header'
import { createAuthenticatedClient } from '../lib/apiClient'

/**
 * Example page demonstrating the authenticated API client usage
 * Shows how to use the interceptor-like pattern for making authenticated requests
 */
export default function ApiClientExamplePage() {
  const { data: session, status } = useSession()
  const [products, setProducts] = useState([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    if (session) {
      fetchProductsExample()
    }
  }, [session])

  // Example 1: Using the authenticated client
  const fetchProductsExample = async () => {
    try {
      setLoading(true)
      
      // Create an authenticated client that automatically adds Bearer token
      const api = createAuthenticatedClient(session)
      
      // All requests automatically include Authorization header
      const data = await api.get('/api/products')
      
      setProducts(data)
      setError(null)
    } catch (err) {
      setError(err.message)
      console.error('Error:', err)
    } finally {
      setLoading(false)
    }
  }

  // Example 2: Creating a new product
  const createProductExample = async () => {
    try {
      const api = createAuthenticatedClient(session)
      
      const newProduct = {
        name: 'New Product',
        price: 99.99,
        skuCode: 'PROD-001',
      }
      
      // POST request with automatic authentication
      const created = await api.post('/api/products', newProduct)
      
      console.log('Created product:', created)
      fetchProductsExample() // Refresh list
    } catch (err) {
      console.error('Error creating product:', err)
    }
  }

  // Example 3: Placing an order
  const placeOrderExample = async (product) => {
    try {
      const api = createAuthenticatedClient(session)
      
      const order = {
        skuCode: product.skuCode,
        price: product.price,
        quantity: 1
      }
      
      // POST request - token automatically included
      const result = await api.post('/api/order', order)
      
      console.log('Order placed:', result)
      alert('Order placed successfully!')
    } catch (err) {
      console.error('Error placing order:', err)
      alert('Failed to place order: ' + (err.message || 'Unknown error'))
    }
  }

  if (status === 'loading') {
    return (
      <>
        <Header />
        <div className="p-8">Loading...</div>
      </>
    )
  }

  if (!session) {
    return (
      <>
        <Header />
        <div className="p-8">
          <p>Please sign in to use the API client example.</p>
        </div>
      </>
    )
  }

  return (
    <>
      <Header />
      <main className="p-8 max-w-4xl mx-auto">
        <h1 className="text-3xl font-bold mb-6">API Client Example</h1>

        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6">
          <h2 className="font-semibold text-blue-900 mb-2">🔐 Authenticated API Client</h2>
          <p className="text-sm text-blue-800">
            This page demonstrates the auth interceptor pattern. All API calls automatically
            include the Bearer token without manually adding headers.
          </p>
        </div>

        <div className="space-y-4 mb-6">
          <button
            onClick={fetchProductsExample}
            disabled={loading}
            className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:bg-gray-400"
          >
            {loading ? 'Loading...' : 'Fetch Products (Authenticated)'}
          </button>

          <button
            onClick={createProductExample}
            className="ml-4 px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700"
          >
            Create Product (Authenticated)
          </button>
        </div>

        {error && (
          <div className="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded">
            Error: {error}
          </div>
        )}

        {products.length > 0 && (
          <div>
            <h2 className="text-xl font-bold mb-4">Products ({products.length})</h2>
            <ul className="space-y-2">
              {products.map((product) => (
                <li
                  key={product.id}
                  className="p-4 bg-white border border-gray-200 rounded shadow-sm"
                >
                  <div className="flex justify-between items-center">
                    <div>
                      <span className="font-semibold">{product.name}</span>
                      <span className="text-gray-600 ml-2">Price: ${product.price}</span>
                    </div>
                    <button
                      onClick={() => placeOrderExample(product)}
                      className="px-3 py-1 bg-green-500 text-white rounded hover:bg-green-600 text-sm"
                    >
                      Order
                    </button>
                  </div>
                </li>
              ))}
            </ul>
          </div>
        )}

        <div className="mt-8 p-4 bg-gray-100 rounded">
          <h3 className="font-semibold mb-2">Code Example:</h3>
          <pre className="text-xs overflow-auto">
{`// Create authenticated client
const api = createAuthenticatedClient(session)

// All requests automatically include Bearer token
await api.get('/api/products')
await api.post('/api/order', orderData)
await api.put('/api/products/1', updateData)
await api.delete('/api/products/1')`}
          </pre>
        </div>
      </main>
    </>
  )
}
