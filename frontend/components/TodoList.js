export default function TodoList({ items, onToggle, onRemove }) {
  if (!items || items.length === 0) return <p className="text-gray-500">No todos yet.</p>

  return (
    <ul className="space-y-2">
      {items.map(item => (
        <li key={item.id} className="flex items-center p-3 bg-white border border-gray-200 rounded-md shadow-sm hover:shadow-md transition">
          <input 
            type="checkbox" 
            checked={item.done} 
            onChange={() => onToggle(item.id)}
            className="w-5 h-5 text-blue-600"
          />
          <span className={`ml-3 flex-1 ${item.done ? 'line-through text-gray-400' : 'text-gray-800'}`}>
            {item.text}
          </span>
          <button 
            onClick={() => onRemove(item.id)}
            className="ml-3 px-4 py-1 bg-red-500 text-white text-sm rounded hover:bg-red-600 transition"
          >
            Remove
          </button>
        </li>
      ))}
    </ul>
  )
}
