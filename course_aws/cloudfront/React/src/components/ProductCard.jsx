export default function ProductCard({ product, isWished, onToggleWish }) {
  const { name, company, image, price, inch, weight, cpuVendor, gpuType, rating, reviewCount, isPopular, isNew } =
    product

  const filledStars = Math.round(rating)
  const stars = '★'.repeat(filledStars) + '☆'.repeat(5 - filledStars)

  return (
    <div className="flex flex-col overflow-hidden rounded-2xl bg-white shadow-md shadow-slate-900/5 transition hover:-translate-y-1 hover:shadow-xl">
      <div className="relative m-4 mb-0 h-44 overflow-hidden rounded-xl bg-gradient-to-br from-indigo-50 to-violet-50">
        <img src={image} alt={name} className="h-full w-full object-contain p-3" loading="lazy" />

        {isPopular && (
          <span className="absolute left-2 top-2 rounded bg-orange-500 px-2 py-1 text-[11px] font-bold text-white">
            인기
          </span>
        )}
        {!isPopular && isNew && (
          <span className="absolute left-2 top-2 rounded bg-indigo-500 px-2 py-1 text-[11px] font-bold text-white">
            NEW
          </span>
        )}

        <button
          type="button"
          onClick={() => onToggleWish(product.id)}
          className="absolute right-2 top-2 flex h-8 w-8 items-center justify-center rounded-full bg-white/95 text-base shadow"
          aria-label="찜하기"
        >
          <span className={isWished ? 'text-red-500' : 'text-slate-400'}>{isWished ? '♥' : '♡'}</span>
        </button>
      </div>

      <div className="flex flex-1 flex-col p-4">
        <span className="mb-2 inline-block w-fit rounded-full bg-indigo-50 px-3 py-1 text-xs font-semibold text-indigo-600">
          {company}
        </span>

        <h3 className="line-clamp-2 min-h-[2.6em] text-[15px] font-semibold text-slate-800">{name}</h3>

        <div className="mt-1 flex items-center gap-1 text-xs">
          <span className="text-amber-500">{stars}</span>
          <span className="text-slate-400">
            {rating} ({reviewCount})
          </span>
        </div>

        <p className="mt-2 text-xl font-extrabold text-orange-600">{price}</p>

        <div className="mt-3 flex flex-wrap gap-1.5">
          <span className="rounded-md border border-slate-200 bg-slate-50 px-2 py-1 text-[11px] text-slate-600">
            {inch}
          </span>
          <span className="rounded-md border border-slate-200 bg-slate-50 px-2 py-1 text-[11px] text-slate-600">
            {weight}
          </span>
          <span className="rounded-md border border-slate-200 bg-slate-50 px-2 py-1 text-[11px] text-slate-600">
            {cpuVendor}
          </span>
          <span className="rounded-md border border-slate-200 bg-slate-50 px-2 py-1 text-[11px] text-slate-600">
            {gpuType}
          </span>
        </div>

        <button
          type="button"
          className="mt-4 w-full rounded-lg bg-gradient-to-r from-indigo-600 to-violet-600 py-2.5 text-sm font-bold text-white transition hover:opacity-90"
        >
          상세보기
        </button>
      </div>
    </div>
  )
}
