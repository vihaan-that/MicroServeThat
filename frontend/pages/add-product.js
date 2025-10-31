import { useState } from 'react'
import { useSession } from 'next-auth/react'
import { useRouter } from 'next/router'
import Header from '../components/Header'
import { createProduct } from '../services/productService'

/**
 * Add Product Page
 * Converted from Angular AddProductComponent
 * Implements form validation equivalent to Angular's ReactiveFormsModule
 */
export default function AddProductPage() {
  const { data: session, status } = useSession()
  const router = useRouter()
  
  // Form state (equivalent to FormGroup)
  const [formData, setFormData] = useState({
    skuCode: '',
    name: '',
    description: '',
    price: '',
  })
  
  // Touched state (for validation display)
  const [touched, setTouched] = useState({
    skuCode: false,
    name: false,
    description: false,
    price: false,
  })
  
  const [productCreated, setProductCreated] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const isAuthenticated = status === 'authenticated'

  // Redirect if not authenticated
  if (status === 'unauthenticated') {
    router.push('/auth/signin')
    return null
  }

  // Validation functions (equivalent to Angular Validators)
  const validators = {
    skuCode: (value) => {
      if (!value) return 'SKU Code is required.'
      if (value.length < 3) return 'SKU Code must be at least 3 characters long.'
      return null
    },
    name: (value) => {
      if (!value) return 'Name is required.'
      if (value.length < 3) return 'Name must be at least 3 characters long.'
      return null
    },
    description: (value) => {
      if (!value) return 'Description is required.'
      if (value.length < 10) return 'Description must be at least 10 characters long.'
      return null
    },
    price: (value) => {
      if (!value) return 'Price is required.'
      if (Number(value) <= 0) return 'Price must be greater than 0.'
      return null
    },
  }

  // Get validation errors
  const errors = {
    skuCode: validators.skuCode(formData.skuCode),
    name: validators.name(formData.name),
    description: validators.description(formData.description),
    price: validators.price(formData.price),
  }

  // Check if form is valid (equivalent to addProductForm.invalid)
  const isFormInvalid = Object.values(errors).some(error => error !== null)

  // Handle input change
  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }))
  }

  // Handle blur (mark as touched)
  const handleBlur = (field) => {
    setTouched((prev) => ({
      ...prev,
      [field]: true,
    }))
  }

  // Check if field should show error (equivalent to field?.invalid && (field?.dirty || field?.touched))
  const shouldShowError = (field) => {
    return touched[field] && errors[field] !== null
  }

  // Handle form submission (equivalent to onSubmit)
  const handleSubmit = async (e) => {
    e.preventDefault()

    // Mark all fields as touched
    setTouched({
      skuCode: true,
      name: true,
      description: true,
      price: true,
    })

    if (isFormInvalid) {
      console.log('Form is not valid')
      return
    }

    try {
      setLoading(true)
      setError(null)
      
      // Debug: Log session and token
      console.log('Session:', session)
      console.log('Access Token:', session?.accessToken)
      
      if (!session?.accessToken) {
        throw new Error('No access token available. Please sign in again.')
      }
      
      const product = {
        skuCode: formData.skuCode,
        name: formData.name,
        description: formData.description,
        price: Number(formData.price),
      }

      console.log('Sending product:', product)
      await createProduct(product, session.accessToken)
      
      setProductCreated(true)
      
      // Reset form (equivalent to this.addProductForm.reset())
      setFormData({
        skuCode: '',
        name: '',
        description: '',
        price: '',
      })
      setTouched({
        skuCode: false,
        name: false,
        description: false,
        price: false,
      })

      // Redirect to home after 2 seconds
      setTimeout(() => {
        router.push('/')
      }, 2000)
    } catch (err) {
      setError(err?.message || 'Failed to create product. Please try again.')
      console.error('Error creating product:', err)
      if (err?.status) console.error('Error status:', err.status)
      if (err?.response) console.error('Error response:', err.response)
    } finally {
      setLoading(false)
    }
  }

  if (status === 'loading') {
    return (
      <>
        <Header />
        <div className="flex items-center justify-center min-h-screen">
          <div className="text-gray-500">Loading...</div>
        </div>
      </>
    )
  }

  return (
    <>
      <Header />
      <div className="container mx-auto p-4">
        <h2 className="text-2xl font-bold mb-4">Add Product</h2>

        {/* Information Box for Available SKU Codes */}
        <div className="mb-6 p-4 bg-blue-50 border-l-4 border-blue-500 text-blue-700">
          <p className="font-bold mb-2">ℹ️ Important: Use Available SKU Codes</p>
          <p className="text-sm mb-2">
            Products must use SKU codes that exist in the inventory. Available SKU codes:
          </p>
          <div className="grid grid-cols-2 gap-2 text-sm font-mono bg-white p-3 rounded">
            <div>• iphone_13</div>
            <div>• iphone_13_red</div>
            <div>• iphone_13_blue</div>
            <div>• iphone_13_black</div>
            <div>• samsung_galaxy_s21</div>
            <div>• samsung_galaxy_s21_white</div>
            <div>• samsung_galaxy_s21_black</div>
          </div>
          <p className="text-xs mt-2 text-blue-600">
            💡 Tip: Copy one of these SKU codes exactly to ensure orders will work!
          </p>
        </div>

        {productCreated && (
          <h4 className="text-green-500 mb-4">Product Created Successfully</h4>
        )}

        {error && (
          <div className="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit}>
          {/* SKU Code Field */}
          <div className="mb-4">
            <label className="block text-gray-700 font-semibold" htmlFor="skuCode">
              SKU Code <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              id="skuCode"
              name="skuCode"
              value={formData.skuCode}
              onChange={handleChange}
              onBlur={() => handleBlur('skuCode')}
              placeholder="e.g., iphone_13"
              className="border rounded w-full py-2 px-3 text-gray-700"
            />
            {shouldShowError('skuCode') && (
              <div className="text-red-500 mt-1">{errors.skuCode}</div>
            )}
            <p className="text-xs text-gray-500 mt-1">
              Use one of the available SKU codes listed above
            </p>
          </div>

          {/* Name Field */}
          <div className="mb-4">
            <label className="block text-gray-700" htmlFor="name">
              Name
            </label>
            <input
              type="text"
              id="name"
              name="name"
              value={formData.name}
              onChange={handleChange}
              onBlur={() => handleBlur('name')}
              className="border rounded w-full py-2 px-3 text-gray-700"
            />
            {shouldShowError('name') && (
              <div className="text-red-500 mt-1">{errors.name}</div>
            )}
          </div>

          {/* Description Field */}
          <div className="mb-4">
            <label className="block text-gray-700" htmlFor="description">
              Description
            </label>
            <textarea
              id="description"
              name="description"
              value={formData.description}
              onChange={handleChange}
              onBlur={() => handleBlur('description')}
              className="border rounded w-full py-2 px-3 text-gray-700"
              rows="4"
            />
            {shouldShowError('description') && (
              <div className="text-red-500 mt-1">{errors.description}</div>
            )}
          </div>

          {/* Price Field */}
          <div className="mb-4">
            <label className="block text-gray-700" htmlFor="price">
              Price
            </label>
            <input
              type="number"
              id="price"
              name="price"
              value={formData.price}
              onChange={handleChange}
              onBlur={() => handleBlur('price')}
              step="0.01"
              min="0"
              className="border rounded w-full py-2 px-3 text-gray-700"
            />
            {shouldShowError('price') && (
              <div className="text-red-500 mt-1">{errors.price}</div>
            )}
          </div>

          <button
            type="submit"
            disabled={isFormInvalid || loading}
            className="bg-green-500 text-white px-4 py-2 rounded-lg hover:bg-green-600 disabled:bg-gray-400 disabled:cursor-not-allowed"
          >
            {loading ? 'Adding Product...' : 'Add Product'}
          </button>
        </form>
      </div>
    </>
  )
}
