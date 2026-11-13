// data/laptops.csv -> src/data/laptops.json 변환 스크립트
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = join(__dirname, '..')

function parseCsv(text) {
  const lines = text.replace(/\r\n/g, '\n').trim().split('\n')
  const headers = splitCsvLine(lines[0])
  return lines.slice(1).map((line) => {
    const cells = splitCsvLine(line)
    const row = {}
    headers.forEach((h, i) => {
      row[h] = cells[i] ?? ''
    })
    return row
  })
}

function splitCsvLine(line) {
  const cells = []
  let cur = ''
  let inQuotes = false
  for (let i = 0; i < line.length; i++) {
    const ch = line[i]
    if (inQuotes) {
      if (ch === '"' && line[i + 1] === '"') {
        cur += '"'
        i++
      } else if (ch === '"') {
        inQuotes = false
      } else {
        cur += ch
      }
    } else if (ch === '"') {
      inQuotes = true
    } else if (ch === ',') {
      cells.push(cur)
      cur = ''
    } else {
      cur += ch
    }
  }
  cells.push(cur)
  return cells
}

const csvText = readFileSync(join(ROOT, 'data', 'laptops.csv'), 'utf-8')
const rows = parseCsv(csvText)

const products = rows.map((row, idx) => {
  const priceNumber = Number(row['금액'].replace(/[^\d]/g, ''))
  const inchNumber = parseFloat(row['인치'])
  const weightNumber = parseFloat(row['무게'])
  const cpuVendor = row['CPU'].startsWith('AMD') ? 'AMD' : row['CPU'].startsWith('인텔') ? '인텔' : '기타'
  const gpuType = row['그래픽'].startsWith('외장그래픽') ? '외장그래픽' : '내장그래픽'
  const imageFile = row['이미지'].replace('images/', '')

  return {
    id: idx + 1,
    name: row['상품명'],
    company: row['회사명'],
    image: `/images/${imageFile}`,
    price: row['금액'],
    priceNumber,
    inch: row['인치'],
    inchNumber,
    weight: row['무게'],
    weightNumber,
    screen: row['화면'],
    cpu: row['CPU'],
    cpuVendor,
    graphics: row['그래픽'],
    gpuType,
    ram: row['램'],
  }
})

mkdirSync(join(ROOT, 'src', 'data'), { recursive: true })
writeFileSync(join(ROOT, 'src', 'data', 'laptops.json'), JSON.stringify(products, null, 2), 'utf-8')

console.log(`변환 완료: ${products.length}개 상품 -> src/data/laptops.json`)
