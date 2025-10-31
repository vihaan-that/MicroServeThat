import NextAuth from 'next-auth'
import { keycloakProvider } from '../../../config/auth-config'

/**
 * NextAuth.js API route handler
 * Handles all OAuth/OIDC flows: login, logout, callback, session refresh
 */
export default NextAuth({
  providers: [
    {
      ...keycloakProvider,
      clientId: process.env.KEYCLOAK_CLIENT_ID,
      clientSecret: process.env.KEYCLOAK_CLIENT_SECRET || 'not-used', // Public client - no secret needed
    }
  ],
  
  session: {
    strategy: 'jwt',
    maxAge: 30 * 60, // 30 minutes (adjust based on your token expiry)
  },
  
  callbacks: {
    async jwt({ token, account, profile }) {
      // Initial sign in
      if (account && profile) {
        token.accessToken = account.access_token
        token.refreshToken = account.refresh_token
        token.idToken = account.id_token
        token.expiresAt = account.expires_at
        token.profile = profile
      }
      
      // Return previous token if not expired
      if (Date.now() < token.expiresAt * 1000) {
        return token
      }
      
      // Access token has expired, try to refresh it
      return refreshAccessToken(token)
    },
    
    async session({ session, token }) {
      // Add custom fields to session
      session.accessToken = token.accessToken
      session.idToken = token.idToken
      session.error = token.error
      
      if (token.profile) {
        session.user = {
          ...session.user,
          id: token.profile.sub,
          ...token.profile
        }
      }
      
      return session
    }
  },
  
  events: {
    async signOut({ token }) {
      // Call Keycloak logout endpoint
      if (token.idToken) {
        const logoutUrl = new URL(`${process.env.KEYCLOAK_ISSUER}/protocol/openid-connect/logout`)
        logoutUrl.searchParams.set('id_token_hint', token.idToken)
        
        try {
          await fetch(logoutUrl.toString())
        } catch (error) {
          console.error('Error during Keycloak logout:', error)
        }
      }
    }
  },
  
  pages: {
    signIn: '/auth/signin',
    error: '/auth/error',
  },
})

/**
 * Refresh the access token using the refresh token
 */
async function refreshAccessToken(token) {
  try {
    const url = `${process.env.KEYCLOAK_ISSUER}/protocol/openid-connect/token`
    
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: new URLSearchParams({
        client_id: process.env.KEYCLOAK_CLIENT_ID,
        client_secret: process.env.KEYCLOAK_CLIENT_SECRET,
        grant_type: 'refresh_token',
        refresh_token: token.refreshToken,
      }),
    })

    const refreshedTokens = await response.json()

    if (!response.ok) {
      throw refreshedTokens
    }

    return {
      ...token,
      accessToken: refreshedTokens.access_token,
      expiresAt: Math.floor(Date.now() / 1000 + refreshedTokens.expires_in),
      refreshToken: refreshedTokens.refresh_token ?? token.refreshToken,
    }
  } catch (error) {
    console.error('Error refreshing access token:', error)
    
    return {
      ...token,
      error: 'RefreshAccessTokenError',
    }
  }
}
