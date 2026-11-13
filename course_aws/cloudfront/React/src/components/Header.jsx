export default function Header({ searchText, onSearchChange }) {
  return (
    <header className="relative overflow-hidden bg-gradient-to-br from-indigo-600 to-violet-600">
      <div className="pointer-events-none absolute -right-20 -top-20 h-72 w-72 rounded-full bg-white/5" />
      <div className="pointer-events-none absolute -left-10 bottom-0 h-52 w-52 rounded-full bg-white/5" />

      <div className="relative mx-auto max-w-7xl px-6 py-8 sm:px-10">
        <div className="flex items-center gap-3">
          <div className="flex h-14 w-14 flex-col items-center justify-center gap-1 rounded-xl border-2 border-white/40 bg-white/10">
            <div className="h-4 w-6 rounded-sm border-2 border-white" />
            <div className="h-1 w-8 rounded-full bg-white" />
          </div>
          <div>
            <h1 className="text-2xl font-extrabold text-white sm:text-3xl">노트북마켓</h1>
            <p className="text-xs text-indigo-100 sm:text-sm">
              최신 노트북, 한눈에 비교하고 최저가로 구매하세요
            </p>
          </div>
        </div>

        <div className="mx-auto mt-6 max-w-2xl">
          <div className="flex items-center gap-2 rounded-full bg-white p-1.5 shadow-lg shadow-indigo-900/20">
            <input
              type="text"
              value={searchText}
              onChange={(e) => onSearchChange(e.target.value)}
              placeholder="찾으시는 노트북 모델명을 입력해보세요"
              className="w-full flex-1 rounded-full bg-transparent px-4 py-2 text-sm text-slate-700 outline-none placeholder:text-slate-400"
            />
            <button
              type="button"
              className="shrink-0 rounded-full bg-gradient-to-r from-indigo-600 to-violet-600 px-6 py-2.5 text-sm font-bold text-white transition hover:opacity-90"
            >
              검색
            </button>
          </div>
        </div>
      </div>
    </header>
  )
}
