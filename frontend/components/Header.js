import { useSession, signIn, signOut } from 'next-auth/react'
import Link from 'next/link'
import { useState } from 'react'

/**
 * Header Component - Converted from Angular HeaderComponent
 * Displays user authentication status, username, and login/logout controls
 * Includes responsive mobile menu toggle
 * 
 * Original Angular component: src/app/shared/header
 * Uses NextAuth.js instead of angular-auth-oidc-client's OidcSecurityService
 */
export default function Header() {
  const { data: session, status } = useSession()
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)
  
  // Equivalent to Angular's isAuthenticated$ subscription
  const isAuthenticated = status === 'authenticated'
  const loading = status === 'loading'
  
  // Equivalent to Angular's userData$ subscription (preferred_username)
  const username = session?.user?.name || session?.user?.preferred_username || session?.user?.email

  // Equivalent to Angular's oidcSecurityService.authorize()
  const handleLogin = () => {
    signIn('keycloak')
  }

  // Equivalent to Angular's oidcSecurityService.logoff()
  const handleLogout = () => {
    signOut().then((result) => console.log(result))
  }

  const toggleMobileMenu = () => {
    setMobileMenuOpen(!mobileMenuOpen)
  }

  return (
    <nav className="bg-white border border-gray-200 dark:border-gray-700 px-2 sm:px-4 py-2.5 rounded dark:bg-gray-800 shadow">
      <div className="container flex flex-wrap justify-between items-center mx-auto">
        <Link href="/" className="flex items-center">
          <span className="self-center text-xl font-semibold whitespace-nowrap dark:text-white">
            Spring Boot Microservices Shop
          </span>
        </Link>

        <div className="flex items-center">
          <button
            id="menu-toggle"
            type="button"
            onClick={toggleMobileMenu}
            className="inline-flex items-center p-2 ml-3 text-sm text-gray-500 rounded-lg hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600 md:hidden"
          >
            <span className="sr-only">Open main menu</span>
            {/* Hamburger icon */}
            <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth="2"
                d="M4 6h16M4 12h16m-7 6h7"
              />
            </svg>
          </button>
        </div>

        <div
          className={`w-full md:block md:w-auto ${mobileMenuOpen ? '' : 'hidden'}`}
          id="mobile-menu"
        >
          <ul className="flex flex-col mt-4 md:flex-row md:space-x-8 md:mt-0 md:text-sm md:font-medium">
            <li>
              {loading ? (
                <span className="text-gray-400">Loading...</span>
              ) : isAuthenticated ? (
                <>
                  <p className="text-white">Hi {username}</p>
                  <a
                    onClick={handleLogout}
                    className="block py-2 pr-4 pl-3 text-gray-700 hover:bg-gray-50 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-gray-400 md:dark:hover:text-white dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent cursor-pointer"
                  >
                    Logout
                  </a>
                </>
              ) : (
                <a
                  onClick={handleLogin}
                  className="block py-2 pr-4 pl-3 text-gray-700 hover:bg-gray-50 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-gray-400 md:dark:hover:text-white dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent cursor-pointer"
                >
                  Login
                </a>
              )}
            </li>
          </ul>
        </div>
      </div>
    </nav>
  )
}
