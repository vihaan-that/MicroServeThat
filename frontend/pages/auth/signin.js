import { signIn } from 'next-auth/react'
import { useRouter } from 'next/router'

export default function SignIn() {
  const router = useRouter()
  const { error } = router.query

  return (
    <main className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full space-y-8 p-8 bg-white rounded-lg shadow-md">
        <div>
          <h2 className="text-center text-3xl font-bold text-gray-900">
            Sign in to Microservices Shop
          </h2>
          {error && (
            <div className="mt-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded">
              Authentication error. Please try again.
            </div>
          )}
        </div>
        
        <button
          onClick={() => signIn('keycloak', { callbackUrl: '/' })}
          className="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition"
        >
          Sign in with Keycloak
        </button>
        
        <p className="mt-4 text-center text-sm text-gray-600">
          Using OAuth2 + OpenID Connect with Keycloak
        </p>
      </div>
    </main>
  )
}
