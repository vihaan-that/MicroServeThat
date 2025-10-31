import { useSession, signIn, signOut } from 'next-auth/react'
import Header from '../components/Header'

/**
 * Debug Auth Page
 * Displays session information and token details for debugging authentication issues
 */
export default function DebugAuthPage() {
  const { data: session, status } = useSession()

  return (
    <>
      <Header />
      <div className="container mx-auto p-4">
        <h1 className="text-3xl font-bold mb-4">Authentication Debug Page</h1>
        
        <div className="mb-4">
          <h2 className="text-xl font-semibold mb-2">Session Status</h2>
          <div className="bg-gray-100 p-4 rounded">
            <p><strong>Status:</strong> {status}</p>
          </div>
        </div>

        {status === 'loading' && (
          <div className="bg-blue-100 p-4 rounded mb-4">
            <p>Loading session...</p>
          </div>
        )}

        {status === 'unauthenticated' && (
          <div className="bg-yellow-100 p-4 rounded mb-4">
            <p className="mb-2">You are not authenticated.</p>
            <button
              onClick={() => signIn('keycloak')}
              className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
            >
              Sign In with Keycloak
            </button>
          </div>
        )}

        {status === 'authenticated' && session && (
          <>
            <div className="mb-4">
              <h2 className="text-xl font-semibold mb-2">User Information</h2>
              <div className="bg-gray-100 p-4 rounded">
                <pre className="whitespace-pre-wrap overflow-auto">
                  {JSON.stringify(session.user, null, 2)}
                </pre>
              </div>
            </div>

            <div className="mb-4">
              <h2 className="text-xl font-semibold mb-2">Access Token</h2>
              <div className="bg-gray-100 p-4 rounded">
                {session.accessToken ? (
                  <>
                    <p className="mb-2"><strong>Token Present:</strong> ✅ Yes</p>
                    <p className="mb-2"><strong>Token Preview:</strong></p>
                    <div className="bg-white p-2 rounded border overflow-auto text-xs">
                      {session.accessToken.substring(0, 100)}...
                    </div>
                    <button
                      onClick={() => {
                        navigator.clipboard.writeText(session.accessToken)
                        alert('Token copied to clipboard!')
                      }}
                      className="mt-2 bg-green-500 text-white px-3 py-1 rounded text-sm hover:bg-green-600"
                    >
                      Copy Full Token
                    </button>
                  </>
                ) : (
                  <p className="text-red-500"><strong>Token Present:</strong> ❌ No</p>
                )}
              </div>
            </div>

            <div className="mb-4">
              <h2 className="text-xl font-semibold mb-2">ID Token</h2>
              <div className="bg-gray-100 p-4 rounded">
                {session.idToken ? (
                  <>
                    <p className="mb-2"><strong>Token Present:</strong> ✅ Yes</p>
                    <div className="bg-white p-2 rounded border overflow-auto text-xs">
                      {session.idToken.substring(0, 100)}...
                    </div>
                  </>
                ) : (
                  <p className="text-red-500"><strong>Token Present:</strong> ❌ No</p>
                )}
              </div>
            </div>

            <div className="mb-4">
              <h2 className="text-xl font-semibold mb-2">Session Error</h2>
              <div className="bg-gray-100 p-4 rounded">
                {session.error ? (
                  <p className="text-red-500">⚠️ {session.error}</p>
                ) : (
                  <p className="text-green-500">✅ No errors</p>
                )}
              </div>
            </div>

            <div className="mb-4">
              <h2 className="text-xl font-semibold mb-2">Full Session Object</h2>
              <div className="bg-gray-100 p-4 rounded">
                <pre className="whitespace-pre-wrap overflow-auto text-xs">
                  {JSON.stringify(session, null, 2)}
                </pre>
              </div>
            </div>

            <div className="mb-4">
              <h2 className="text-xl font-semibold mb-2">API Configuration</h2>
              <div className="bg-gray-100 p-4 rounded">
                <p><strong>API Base URL:</strong> {process.env.NEXT_PUBLIC_API_URL || 'http://localhost:9000'}</p>
                <p><strong>Keycloak Issuer:</strong> {process.env.KEYCLOAK_ISSUER || 'Not configured'}</p>
                <p><strong>Keycloak Client ID:</strong> {process.env.KEYCLOAK_CLIENT_ID || 'Not configured'}</p>
              </div>
            </div>

            <div className="mb-4">
              <button
                onClick={() => signOut()}
                className="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600"
              >
                Sign Out
              </button>
            </div>
          </>
        )}

        <div className="mt-8 bg-blue-50 p-4 rounded">
          <h2 className="text-xl font-semibold mb-2">Troubleshooting Steps</h2>
          <ol className="list-decimal list-inside space-y-2">
            <li>Verify Keycloak is running on <code>http://localhost:8181</code></li>
            <li>Check that the realm <code>test-client</code> exists in Keycloak</li>
            <li>Verify the client <code>react-client</code> is configured properly</li>
            <li>Ensure access token is present in the session</li>
            <li>Check browser console for any errors</li>
            <li>Verify API Gateway is running on <code>http://localhost:9000</code></li>
          </ol>
        </div>
      </div>
    </>
  )
}
