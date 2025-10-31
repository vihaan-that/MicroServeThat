/**
 * Order Service
 * Converted from Angular services/order/order.service
 * Handles API calls to the order microservice
 * 
 * Now uses centralized API client with automatic token injection (interceptor pattern)
 */

import { apiGet, apiPost } from '../lib/apiClient'

/**
 * Place an order for a product
 * @param {Order} order - Order details
 * @param {string} accessToken - OAuth access token for authentication
 * @returns {Promise<Object>} Order response
 */
export async function orderProduct(order, accessToken) {
  return apiPost('/api/order', order, accessToken)
}

/**
 * Get all orders for the authenticated user
 * @param {string} accessToken - OAuth access token for authentication
 * @returns {Promise<Order[]>} Array of orders
 */
export async function getOrders(accessToken) {
  return apiGet('/api/order', accessToken)
}
