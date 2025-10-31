/**
 * Order Model
 * Converted from Angular model/order
 * 
 * Backend OrderRequest DTO (Java Record):
 * - id: Long (optional, set by backend)
 * - orderNumber: String (optional, set by backend)
 * - skuCode: String (required)
 * - price: BigDecimal (required)
 * - quantity: Integer (required)
 * 
 * Note: userDetails is NOT part of the backend contract.
 * User information is derived from the JWT token on the backend.
 * 
 * @typedef {Object} Order
 * @property {number} [id] - Order ID (optional, set by backend)
 * @property {string} [orderNumber] - Order number (optional, set by backend)
 * @property {string} skuCode - Product SKU code
 * @property {number} price - Product price
 * @property {number} quantity - Order quantity
 */

export default {}

