import ProductCard from './ProductCard'

export default function ProductGrid({ products, wishlist, onToggleWish }) {
  if (products.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center rounded-2xl bg-white py-24 text-center shadow-sm">
        <p className="text-lg font-semibold text-slate-700">조건에 맞는 상품이 없습니다</p>
        <p className="mt-1 text-sm text-slate-400">필터 조건을 변경해보세요</p>
      </div>
    )
  }

  return (
    <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
      {products.map((product) => (
        <ProductCard
          key={product.id}
          product={product}
          isWished={wishlist.has(product.id)}
          onToggleWish={onToggleWish}
        />
      ))}
    </div>
  )
}
