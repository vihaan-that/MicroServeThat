import { useSession } from 'next-auth/react'
import { useRouter } from 'next/router'
import { useEffect } from 'react'
import Header from '../components/Header'

export default function ProtectedPage() {
  const { data: session, status } = useSession()
  const router = useRouter()
  const loading = status === 'loading'

  useEffect(() => {
    if (!loading && !session) {
      router.push('/auth/signin')
    }
  }, [session, loading, router])

  if (loading) {
    return (
      <>
        <Header />
        <div className="flex items-center justify-center min-h-screen">
          <div className="text-gray-500">Loading...</div>
        </div>
      </>
    )
  }

  if (!session) {
    return null
  }

  return (
    <>
      <Header />
      <main className="p-8 max-w-4xl mx-auto">
        <h1 className="text-3xl font-bold mb-6">Protected Page</h1>
        
        <div className="bg-white p-6 rounded-lg shadow-md space-y-4">
          <div>
            <h2 className="text-xl font-semibold mb-2">User Information</h2>
            <div className="bg-gray-50 p-4 rounded">
              <p><strong>Name:</strong> {session.user?.name}</p>
              <p><strong>Email:</strong> {session.user?.email}</p>
              <p><strong>ID:</strong> {session.user?.id}</p>
            </div>
          </div>

          <div>
            <h2 className="text-xl font-semibold mb-2">Session Details</h2>
            <div className="bg-gray-50 p-4 rounded">
              <p className="text-sm text-gray-600 mb-2">Access Token Available: {session.accessToken ? '✅ Yes' : '❌ No'}</p>
              <p className="text-sm text-gray-600">ID Token Available: {session.idToken ? '✅ Yes' : '❌ No'}</p>
            </div>
          </div>

          {session.error && (
            <div className="bg-red-100 border border-red-400 text-red-700 p-4 rounded">
              <p><strong>Session Error:</strong> {session.error}</p>
              <p className="text-sm mt-2">Please sign in again.</p>
            </div>
          )}

          <div className="mt-6">
            <h3 className="font-semibold mb-2">Full Session Object (Debug)</h3>
            <pre className="bg-gray-900 text-gray-100 p-4 rounded overflow-auto text-xs">
              {JSON.stringify(session, null, 2)}
            </pre>
          </div>
        </div>

        <div className="mt-6 p-4 bg-blue-50 border border-blue-200 rounded">
          <p className="text-sm text-blue-800">
            🔒 This page is protected and requires authentication. The access token can be used to call your microservices backend APIs.
          </p>
        </div>
      </main>
    </>
  )
}
