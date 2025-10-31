/**
 * Product Service
 * Converted from Angular services/product/product.service
 * Handles API calls to the product microservice
 * 
 * API Endpoint: http://localhost:9000/api/product
 * Now uses centralized API client with automatic token injection (interceptor pattern)
 */

import { apiGet, apiPost } from '../lib/apiClient'

/**
 * Fetch all products from the API
 * @param {string} accessToken - OAuth access token for authentication
 * @returns {Promise<Product[]>} Array of products
 */
export async function getProducts(accessToken = null) {
  return apiGet('/api/product', accessToken)
}

/**
 * Create a new product
 * @param {Object} product - Product data (skuCode, name, description, price)
 * @param {string} accessToken - OAuth access token for authentication
 * @returns {Promise<Product>} Created product
 */
export async function createProduct(product, accessToken) {
  return apiPost('/api/product', product, accessToken)
}
