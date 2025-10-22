-- Simple dataset to bootstrap the training database
CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    signup_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers (id),
    product TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE
);

INSERT INTO customers (email, full_name, signup_date) VALUES
    ('sara@example.com', 'Sara Connor', '2023-10-01'),
    ('lee@example.com', 'Lee Wong', '2023-11-15'),
    ('pat@example.com', 'Pat Brown', '2024-01-20')
ON CONFLICT (email) DO NOTHING;

INSERT INTO orders (customer_id, product, quantity, total_amount, order_date) VALUES
    ((SELECT id FROM customers WHERE email = 'sara@example.com'), 'Premium Plan', 1, 99.00, '2024-02-01'),
    ((SELECT id FROM customers WHERE email = 'lee@example.com'), 'Premium Plan', 1, 99.00, '2024-02-10'),
    ((SELECT id FROM customers WHERE email = 'pat@example.com'), 'Starter Plan', 1, 29.00, '2024-03-05')
ON CONFLICT DO NOTHING;

