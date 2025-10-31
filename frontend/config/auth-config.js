/**
 * Authentication configuration for Keycloak OIDC
 * Converted from Angular auth-oidc-client to NextAuth.js
 */

export const authConfig = {
  // Keycloak realm URL
  authority: 'http://localhost:8181/realms/test-client',
  
  // Client configuration
  clientId: 'react-client',
  
  // OAuth2 settings
  scope: 'openid profile offline_access',
  responseType: 'code',
  
  // Token refresh settings
  useRefreshToken: true,
  renewTimeBeforeTokenExpiresInSeconds: 30,
  
  // Redirect URLs
  redirectUrl: typeof window !== 'undefined' ? window.location.origin : 'http://localhost:3000',
  postLogoutRedirectUri: typeof window !== 'undefined' ? window.location.origin : 'http://localhost:3000',
}

/**
 * NextAuth.js provider configuration for Keycloak
 * Reference: https://programmingtechie.com/2024/04/18/spring-boot-microservices-tutorial-part-4/
 */
export const keycloakProvider = {
  id: 'keycloak',
  name: 'Keycloak',
  type: 'oauth',
  wellKnown: `${authConfig.authority}/.well-known/openid-configuration`,
  authorization: { 
    params: { 
      scope: authConfig.scope,
      response_type: authConfig.responseType
    } 
  },
  idToken: true,
  checks: ['pkce', 'state'],
  profile(profile) {
    return {
      id: profile.sub,
      name: profile.name ?? profile.preferred_username,
      email: profile.email,
      image: profile.picture,
    }
  },
}
