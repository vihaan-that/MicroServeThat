import { useState } from 'react'
import TodoList from '../components/TodoList'
import Header from '../components/Header'

export default function TodoPage() {
  const [items, setItems] = useState([
    { id: 1, text: 'Learn React basics', done: false },
    { id: 2, text: 'Translate Angular examples', done: false }
  ])
  const [text, setText] = useState('')
  const [filter, setFilter] = useState('all')

  function addItem(e) {
    e.preventDefault()
    if (!text.trim()) return
    const newItem = { id: Date.now(), text: text.trim(), done: false }
    setItems(prev => [newItem, ...prev])
    setText('')
  }

  function removeItem(id) {
    setItems(prev => prev.filter(it => it.id !== id))
  }

  function toggleDone(id) {
    setItems(prev => prev.map(it => it.id === id ? { ...it, done: !it.done } : it))
  }

  const filtered = items.filter(it => {
    if (filter === 'all') return true
    if (filter === 'active') return !it.done
    if (filter === 'done') return it.done
    return true
  })

  return (
    <>
      <Header />
      <main className="p-8 max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">Todo Demo</h1>

      <form onSubmit={addItem} className="mb-6">
        <input 
          value={text} 
          onChange={e => setText(e.target.value)} 
          placeholder="Add todo" 
          className="px-4 py-2 border border-gray-300 rounded-md w-80 focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
        <button className="ml-3 px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition">
          Add
        </button>
      </form>

      <div className="mb-6">
        <label className="mr-3 font-medium">Filter:</label>
        <select 
          value={filter} 
          onChange={e => setFilter(e.target.value)}
          className="px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
        >
          <option value="all">All</option>
          <option value="active">Active</option>
          <option value="done">Done</option>
        </select>
      </div>

      <TodoList items={filtered} onToggle={toggleDone} onRemove={removeItem} />

      <p className="mt-6 text-sm text-gray-600">
        This page demonstrates key Angular tutorial concepts: data binding (input ↔ state), list rendering, event handling, and filtering — using React hooks and components.
      </p>
    </main>
    </>
  )
}
