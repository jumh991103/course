import { useMemo, useState } from 'react'
import rawProducts from './data/laptops.json'
import Header from './components/Header'
import Tabs from './components/Tabs'
import FilterBar from './components/FilterBar'
import ProductGrid from './components/ProductGrid'
import Pagination from './components/Pagination'

const PAGE_SIZE = 8

function enrichProducts(products) {
  return products.map((p) => {
    const rating = Math.round((4 + ((p.id * 7) % 10) / 10) * 10) / 10
    const reviewCount = 40 + ((p.id * 37) % 300)
    return {
      ...p,
      rating,
      reviewCount,
      isPopular: rating >= 4.7,
      isNew: p.name.includes('2026'),
    }
  })
}

function matchesPrice(priceNumber, bucket) {
  if (bucket === 'all') return true
  if (bucket === 'under100') return priceNumber < 1_000_000
  if (bucket === '100to200') return priceNumber >= 1_000_000 && priceNumber < 2_000_000
  if (bucket === '200to300') return priceNumber >= 2_000_000 && priceNumber < 3_000_000
  if (bucket === 'over300') return priceNumber >= 3_000_000
  return true
}

function matchesWeight(weightNumber, bucket) {
  if (bucket === 'all') return true
  if (bucket === 'under1.5') return weightNumber < 1.5
  if (bucket === '1.5to2') return weightNumber >= 1.5 && weightNumber < 2
  if (bucket === 'over2') return weightNumber >= 2
  return true
}

const PRODUCTS = enrichProducts(rawProducts)
const COMPANIES = ['전체', ...new Set(PRODUCTS.map((p) => p.company))]
const INCH_OPTIONS = [...new Set(PRODUCTS.map((p) => p.inchNumber))].sort((a, b) => a - b)

export default function App() {
  const [search, setSearch] = useState('')
  const [activeCompany, setActiveCompany] = useState('전체')
  const [filters, setFilters] = useState({ price: 'all', inch: 'all', weight: 'all', cpu: 'all', gpu: 'all' })
  const [page, setPage] = useState(1)
  const [wishlist, setWishlist] = useState(new Set())

  const filtered = useMemo(() => {
    return PRODUCTS.filter((p) => {
      if (activeCompany !== '전체' && p.company !== activeCompany) return false
      if (search.trim() && !p.name.toLowerCase().includes(search.trim().toLowerCase())) return false
      if (!matchesPrice(p.priceNumber, filters.price)) return false
      if (filters.inch !== 'all' && p.inchNumber !== Number(filters.inch)) return false
      if (!matchesWeight(p.weightNumber, filters.weight)) return false
      if (filters.cpu !== 'all' && p.cpuVendor !== filters.cpu) return false
      if (filters.gpu !== 'all' && p.gpuType !== filters.gpu) return false
      return true
    })
  }, [activeCompany, search, filters])

  const totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE))
  const currentPage = Math.min(page, totalPages)
  const pageItems = filtered.slice((currentPage - 1) * PAGE_SIZE, currentPage * PAGE_SIZE)

  function updateFilters(next) {
    setFilters(next)
    setPage(1)
  }

  function selectCompany(company) {
    setActiveCompany(company)
    setPage(1)
  }

  function toggleWish(id) {
    setWishlist((prev) => {
      const next = new Set(prev)
      if (next.has(id)) next.delete(id)
      else next.add(id)
      return next
    })
  }

  return (
    <div className="min-h-screen bg-slate-100">
      <Header
        searchText={search}
        onSearchChange={(v) => {
          setSearch(v)
          setPage(1)
        }}
      />
      <Tabs companies={COMPANIES} active={activeCompany} onChange={selectCompany} />
      <FilterBar filters={filters} onChange={updateFilters} inchOptions={INCH_OPTIONS} />

      <main className="mx-auto max-w-7xl px-6 py-8 sm:px-10">
        <div className="mb-4 flex items-center justify-between">
          <p className="text-sm text-slate-500">
            전체 상품 <span className="font-bold text-slate-800">{filtered.length}건</span>
          </p>
        </div>

        <ProductGrid products={pageItems} wishlist={wishlist} onToggleWish={toggleWish} />
        <Pagination page={currentPage} totalPages={totalPages} onChange={setPage} />
      </main>

      <footer className="bg-slate-900 py-6 text-center text-xs text-white/70">
        © 2026 노트북마켓 · 강의용 화면설계 예제 사이트
      </footer>
    </div>
  )
}
