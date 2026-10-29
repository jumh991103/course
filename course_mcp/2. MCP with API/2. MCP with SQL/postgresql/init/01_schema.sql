-- 강의용 샘플 스키마 (mcp_db)

CREATE TABLE IF NOT EXISTS customers (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    email       TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS products (
    id          SERIAL PRIMARY KEY,
    sku         TEXT NOT NULL UNIQUE,
    name        TEXT NOT NULL,
    price_cents INTEGER NOT NULL CHECK (price_cents >= 0),
    stock       INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE IF NOT EXISTS orders (
    id           SERIAL PRIMARY KEY,
    customer_id  INTEGER NOT NULL REFERENCES customers (id),
    product_id   INTEGER NOT NULL REFERENCES products (id),
    qty          INTEGER NOT NULL CHECK (qty > 0),
    ordered_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO customers (name, email) VALUES
    ('김민수', 'minsu@example.com'),
    ('이서연', 'seoyeon@example.com'),
    ('박지훈', 'jihoon@example.com')
ON CONFLICT (email) DO NOTHING;

INSERT INTO products (sku, name, price_cents, stock) VALUES
    ('SKU-001', '무선 키보드', 89000, 12),
    ('SKU-002', 'USB-C 케이블', 12000, 80),
    ('SKU-003', '노트북 스탠드', 45000, 5)
ON CONFLICT (sku) DO NOTHING;

INSERT INTO orders (customer_id, product_id, qty)
SELECT c.id, p.id, v.qty
FROM (VALUES
    ('minsu@example.com', 'SKU-001', 1),
    ('seoyeon@example.com', 'SKU-002', 2),
    ('jihoon@example.com', 'SKU-003', 1)
) AS v(email, sku, qty)
JOIN customers c ON c.email = v.email
JOIN products p ON p.sku = v.sku;
