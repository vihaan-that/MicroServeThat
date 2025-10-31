import { getServerSession } from 'next-auth/next'
import { authOptions } from './auth/[...nextauth]'

/**
 * Example API route showing how to use the access token
 * to call your microservices backend
 */
export default async function handler(req, res) {
  const session = await getServerSession(req, res, authOptions)
  
  if (!session) {
    return res.status(401).json({ error: 'Unauthorized - Please sign in' })
  }

  // Example: Call your microservices API with the access token
  try {
    const response = await fetch('http://localhost:8080/api/products', {
      headers: {
        'Authorization': `Bearer ${session.accessToken}`,
        'Content-Type': 'application/json',
      },
    })

    if (!response.ok) {
      throw new Error(`API responded with status: ${response.status}`)
    }

    const data = await response.json()
    res.status(200).json(data)
  } catch (error) {
    console.error('Error calling microservices API:', error)
    res.status(500).json({ 
      error: 'Failed to fetch data from microservices',
      details: error.message 
    })
  }
}
