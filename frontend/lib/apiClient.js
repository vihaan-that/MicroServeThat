/**
 * API Client with Authentication Interceptor
 * Converted from Angular HttpInterceptor
 * 
 * This utility automatically adds the Bearer token to all API requests,
 * similar to Angular's authInterceptor functionality.
 */

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8080'

/**
 * Create headers with authentication token
 * Equivalent to Angular's authInterceptor that adds 'Bearer ' + token
 * 
 * @param {string|null} accessToken - OAuth access token
 * @param {Object} customHeaders - Additional headers to include
 * @returns {Object} Headers object with auth token if available
 */
function createHeaders(accessToken = null, customHeaders = {}) {
  const headers = {
    'Content-Type': 'application/json',
    ...customHeaders,
  }

  // Equivalent to Angular's: let header = 'Bearer ' + token;
  if (accessToken) {
    headers['Authorization'] = `Bearer ${accessToken}`
  }

  return headers
}

/**
 * Generic API client for making authenticated requests
 * Acts as an interceptor by automatically adding auth headers
 * 
 * @param {string} endpoint - API endpoint (e.g., '/api/products')
 * @param {Object} options - Fetch options
 * @param {string|null} options.accessToken - OAuth access token
 * @param {string} options.method - HTTP method (GET, POST, etc.)
 * @param {Object} options.body - Request body for POST/PUT
 * @param {Object} options.headers - Additional headers
 * @returns {Promise<any>} Response data
 */
export async function apiClient(endpoint, options = {}) {
  const {
    accessToken = null,
    method = 'GET',
    body = null,
    headers: customHeaders = {},
  } = options

  const url = `${API_BASE_URL}${endpoint}`
  
  // Automatically inject Authorization header (interceptor behavior)
  const headers = createHeaders(accessToken, customHeaders)

  // Debug logging
  console.log('API Request:', {
    url,
    method,
    headers: {
      ...headers,
      Authorization: accessToken ? 'Bearer [REDACTED]' : 'None'
    },
    body: body ? JSON.stringify(body).substring(0, 100) : 'None'
  })

  const config = {
    method,
    headers,
  }

  if (body) {
    config.body = JSON.stringify(body)
  }

  const response = await fetch(url, config)

  if (!response.ok) {
    let errorMessage = `API request failed: ${response.status} ${response.statusText}`
    
    try {
      const errorBody = await response.text()
      if (errorBody) {
        console.error('Error response body:', errorBody)
        errorMessage += ` - ${errorBody}`
      }
    } catch (e) {
      // Ignore if we can't read the error body
    }
    
    const error = new Error(errorMessage)
    error.status = response.status
    error.response = response
    throw error
  }

  // Handle empty responses (204 No Content, or 201 Created with no body)
  if (response.status === 204 || response.status === 201) {
    const contentType = response.headers.get('content-type')
    const contentLength = response.headers.get('content-length')
    
    // If no content-type or content-length is 0, return null
    if (!contentType || contentLength === '0') {
      console.log('Success response with no body:', response.status)
      return null
    }
  }

  // Try to parse response based on content type
  const contentType = response.headers.get('content-type')
  const text = await response.text()

  if (!text) {
    console.log('Empty response body, returning null')
    return null
  }

  // If content-type indicates JSON, parse as JSON
  if (contentType && contentType.includes('application/json')) {
    try {
      return JSON.parse(text)
    } catch (error) {
      console.warn('Failed to parse JSON response:', error)
      // Return the raw text if JSON parsing fails
      return text
    }
  }

  // For plain text responses (like "Order Placed Successfully"), return as-is
  console.log('Plain text response:', text)
  return text
}

/**
 * Convenience methods for common HTTP operations
 * All methods automatically include auth token if provided
 */

export async function apiGet(endpoint, accessToken = null, headers = {}) {
  return apiClient(endpoint, { accessToken, method: 'GET', headers })
}

export async function apiPost(endpoint, body, accessToken = null, headers = {}) {
  return apiClient(endpoint, { accessToken, method: 'POST', body, headers })
}

export async function apiPut(endpoint, body, accessToken = null, headers = {}) {
  return apiClient(endpoint, { accessToken, method: 'PUT', body, headers })
}

export async function apiDelete(endpoint, accessToken = null, headers = {}) {
  return apiClient(endpoint, { accessToken, method: 'DELETE', headers })
}

/**
 * Hook-friendly API client for use in React components
 * Automatically extracts token from session
 * 
 * Usage in components:
 * ```javascript
 * import { useSession } from 'next-auth/react'
 * import { useApiClient } from '@/lib/apiClient'
 * 
 * function MyComponent() {
 *   const { data: session } = useSession()
 *   const api = useApiClient(session)
 *   
 *   const fetchData = async () => {
 *     const data = await api.get('/api/products')
 *   }
 * }
 * ```
 */
export function createAuthenticatedClient(session) {
  const accessToken = session?.accessToken || null

  return {
    get: (endpoint, headers) => apiGet(endpoint, accessToken, headers),
    post: (endpoint, body, headers) => apiPost(endpoint, body, accessToken, headers),
    put: (endpoint, body, headers) => apiPut(endpoint, body, accessToken, headers),
    delete: (endpoint, headers) => apiDelete(endpoint, accessToken, headers),
  }
}

export default apiClient
