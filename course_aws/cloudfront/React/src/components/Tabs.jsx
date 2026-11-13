export default function Tabs({ companies, active, onChange }) {
  return (
    <div className="border-b border-slate-200 bg-white">
      <div className="mx-auto flex max-w-7xl gap-2 overflow-x-auto px-6 py-3 sm:px-10">
        {companies.map((company) => {
          const isActive = company === active
          return (
            <button
              key={company}
              type="button"
              onClick={() => onChange(company)}
              className={`shrink-0 rounded-full px-4 py-2 text-sm font-semibold transition ${
                isActive
                  ? 'bg-gradient-to-r from-indigo-600 to-violet-600 text-white shadow'
                  : 'text-slate-600 hover:bg-slate-100'
              }`}
            >
              {company}
            </button>
          )
        })}
      </div>
    </div>
  )
}
