# Microservices Shop Frontend

This project is a Next.js + React + Tailwind CSS application with OAuth2/OIDC authentication, converted from Angular tutorial concepts.

## Features

- ✅ Next.js 13 with React 18
- ✅ Tailwind CSS for styling
- ✅ OAuth2 + OpenID Connect authentication with Keycloak
- ✅ Automatic token refresh
- ✅ Protected routes
- ✅ Session management
- ✅ Product listing and management
- ✅ Order placement system
- ✅ Microservices API integration

## Getting Started

### 1. Install Dependencies

```bash
cd /home/vihaan/Documents/sem7/microservices-k8s/frontend
npm install
```

### 2. Configure Environment Variables

Copy `.env.local.example` to `.env.local` and update with your Keycloak settings:

```bash
cp .env.local.example .env.local
```

Update the following variables in `.env.local`:
- `KEYCLOAK_CLIENT_SECRET` - Get this from your Keycloak admin console
- `NEXTAUTH_SECRET` - Generate with: `openssl rand -base64 32`
- `NEXT_PUBLIC_API_URL` - Your microservices backend URL (default: http://localhost:8080)

### 3. Start Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Project Structure

- `pages/index.js` – Landing page with product listing (HomePage)
- `pages/add-product.js` – Create new product page (authenticated)
- `pages/todo.js` – Todo demo showing binding, list rendering, add/remove, filter
- `pages/protected.js` – Protected page requiring authentication
- `pages/auth/signin.js` – Sign in page
- `pages/auth/error.js` – Authentication error page
- `pages/api/auth/[...nextauth].js` – NextAuth.js API routes (handles OAuth flow)
- `pages/api/example.js` – Example API route showing authenticated requests
- `pages/api-example.js` – Frontend example of authenticated API client usage
- `components/Header.js` – Responsive header with auth controls (converted from Angular)
- `components/HomePage.js` – Product listing and order placement component
- `components/TodoList.js` – Reusable list component
- `lib/apiClient.js` – Centralized API client with auth interceptor (auto-adds Bearer token)
- `services/productService.js` – Product API service
- `services/orderService.js` – Order API service
- `models/product.js` – Product type definitions
- `models/order.js` – Order type definitions
- `config/auth-config.js` – OAuth/OIDC configuration
- `styles/globals.css` – Global styles with Tailwind CSS directives

## Authentication Setup

This app uses **NextAuth.js** with Keycloak as the identity provider.

### Keycloak Configuration Required

1. Create a realm: `test-client`
2. Create a client: `react-client`
3. Configure the client:
   - Client Protocol: `openid-connect`
   - Access Type: `confidential`
   - Valid Redirect URIs: `http://localhost:3000/*`
   - Web Origins: `http://localhost:3000`
4. Get the client secret from the Credentials tab
5. Add the secret to your `.env.local` file

For detailed Keycloak setup, refer to: https://programmingtechie.com/2024/04/18/spring-boot-microservices-tutorial-part-4/

### Authentication Flow

1. User clicks "Sign In" → redirected to Keycloak
2. User authenticates with Keycloak
3. Keycloak redirects back with authorization code
4. NextAuth exchanges code for access/refresh tokens
5. Tokens stored in encrypted JWT session
6. Access token automatically refreshed before expiry

### Using Authentication in Your Code

```javascript
import { useSession, signIn, signOut } from 'next-auth/react'

function MyComponent() {
  const { data: session, status } = useSession()
  
  if (status === 'loading') return <div>Loading...</div>
  
  if (session) {
    return (
      <>
        <p>Signed in as {session.user.email}</p>
        <button onClick={() => signOut()}>Sign out</button>
      </>
    )
  }
  
  return <button onClick={() => signIn('keycloak')}>Sign in</button>
}
```

### Protecting API Routes

```javascript
import { getServerSession } from 'next-auth/next'
import { authOptions } from './auth/[...nextauth]'

export default async function handler(req, res) {
  const session = await getServerSession(req, res, authOptions)
  
  if (!session) {
    return res.status(401).json({ error: 'Unauthorized' })
  }
  
  // Use session.accessToken to call your microservices
  res.json({ data: 'Protected data' })
}
```

## Tailwind CSS

Tailwind CSS is configured and ready to use. The configuration applies to all files in:
- `./pages/**/*.{js,ts,jsx,tsx}`
- `./components/**/*.{js,ts,jsx,tsx}`

## Angular → Next.js Conversion Notes

| Angular Concept | Next.js/React Equivalent |
|----------------|-------------------------|
| `ng-model` | `useState` + `value`/`onChange` |
| `ng-repeat` | `.map()` in JSX |
| `ng-if` / `ng-show` | Conditional rendering `&&` or ternary |
| Controllers | Function components with hooks |
| Services | Custom hooks or utility modules |
| Directives | Custom components |
| `$scope` | Component state (useState) |
| `angular-auth-oidc-client` | NextAuth.js |
| Route Guards | `useSession` + redirect logic |

Share your Angular code blocks and I'll convert them into React components!
