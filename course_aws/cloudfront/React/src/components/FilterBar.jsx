const selectClass =
  'w-full appearance-none rounded-lg border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm text-slate-700 outline-none focus:border-indigo-400 focus:bg-white'

function Field({ label, value, onChange, options }) {
  return (
    <div className="flex-1 min-w-[150px]">
      <label className="mb-1 block text-xs text-slate-500">{label}</label>
      <div className="relative">
        <select value={value} onChange={(e) => onChange(e.target.value)} className={selectClass}>
          {options.map((opt) => (
            <option key={opt.value} value={opt.value}>
              {opt.label}
            </option>
          ))}
        </select>
        <span className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-slate-400">▾</span>
      </div>
    </div>
  )
}

export default function FilterBar({ filters, onChange, inchOptions }) {
  return (
    <div className="mx-auto -mt-8 max-w-7xl px-6 sm:px-10">
      <div className="flex flex-wrap items-end gap-3 rounded-2xl bg-white p-5 shadow-lg shadow-slate-900/5">
        <Field
          label="금액"
          value={filters.price}
          onChange={(v) => onChange({ ...filters, price: v })}
          options={[
            { value: 'all', label: '전체 가격' },
            { value: 'under100', label: '100만원 미만' },
            { value: '100to200', label: '100~200만원' },
            { value: '200to300', label: '200~300만원' },
            { value: 'over300', label: '300만원 이상' },
          ]}
        />
        <Field
          label="인치"
          value={filters.inch}
          onChange={(v) => onChange({ ...filters, inch: v })}
          options={[{ value: 'all', label: '전체 사이즈' }, ...inchOptions.map((i) => ({ value: i, label: `${i}인치` }))]}
        />
        <Field
          label="무게"
          value={filters.weight}
          onChange={(v) => onChange({ ...filters, weight: v })}
          options={[
            { value: 'all', label: '전체 무게' },
            { value: 'under1.5', label: '1.5kg 미만' },
            { value: '1.5to2', label: '1.5~2kg' },
            { value: 'over2', label: '2kg 이상' },
          ]}
        />
        <Field
          label="CPU"
          value={filters.cpu}
          onChange={(v) => onChange({ ...filters, cpu: v })}
          options={[
            { value: 'all', label: '전체 CPU' },
            { value: '인텔', label: '인텔' },
            { value: 'AMD', label: 'AMD' },
          ]}
        />
        <Field
          label="그래픽"
          value={filters.gpu}
          onChange={(v) => onChange({ ...filters, gpu: v })}
          options={[
            { value: 'all', label: '전체 그래픽' },
            { value: '내장그래픽', label: '내장그래픽' },
            { value: '외장그래픽', label: '외장그래픽' },
          ]}
        />
        <button
          type="button"
          onClick={() =>
            onChange({ price: 'all', inch: 'all', weight: 'all', cpu: 'all', gpu: 'all' })
          }
          className="shrink-0 rounded-lg bg-gradient-to-r from-indigo-600 to-violet-600 px-6 py-2.5 text-sm font-bold text-white transition hover:opacity-90"
        >
          초기화
        </button>
      </div>
    </div>
  )
}
