-- paypal_database_design.sql

-- 1. Create Tables

-- Create Customers table
-- This table stores information about customers.
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,       -- Unique ID for each customer
    name VARCHAR(100) NOT NULL,        -- Customer's full name
    email VARCHAR(100) NOT NULL UNIQUE, -- Customer's email address (must be unique)
    phone_number VARCHAR(20),          -- Customer's phone number
    address TEXT                        -- Customer's address
);

-- Create Merchants table
-- This table stores information about merchants.
CREATE TABLE Merchants (
    merchant_id INT PRIMARY KEY,        -- Unique ID for each merchant
    merchant_name VARCHAR(100) NOT NULL, -- Merchant's business name
    business_type VARCHAR(50),          -- Type of business (e.g., Retail, Restaurant)
    contact_info VARCHAR(100)           -- Merchant's contact information (email/phone)
);

-- Create Transactions table
-- This table stores transaction details.
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,     -- Unique ID for each transaction
    customer_id INT,                    -- Foreign key to Customers table
    merchant_id INT,                    -- Foreign key to Merchants table
    amount DECIMAL(10, 2) NOT NULL,      -- Transaction amount
    currency VARCHAR(10) NOT NULL,       -- Currency used in the transaction
    transaction_date DATE NOT NULL,      -- Date of transaction
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),  -- Link to Customers table
    FOREIGN KEY (merchant_id) REFERENCES Merchants(merchant_id)   -- Link to Merchants table
);

-- 2. Insert Sample Data

-- Insert data into Customers table
-- Adding sample customer records
INSERT INTO Customers (customer_id, name, email, phone_number, address)
VALUES
    (1, 'Alice Johnson', 'alice.johnson@email.com', '555-1234', '123 Elm St, Springfield'),
    (2, 'Bob Smith', 'bob.smith@email.com', '555-5678', '456 Oak St, Springfield'),
    (3, 'Charlie Brown', 'charlie.brown@email.com', '555-9876', '789 Pine St, Springfield');

-- Insert data into Merchants table
-- Adding sample merchant records
INSERT INTO Merchants (merchant_id, merchant_name, business_type, contact_info)
VALUES
    (1, 'TechStore', 'Retail', 'techstore@email.com'),
    (2, 'Foodies', 'Restaurant', 'foodies@email.com'),
    (3, 'GadgetWorld', 'Retail', 'gadgetworld@email.com');

-- Insert data into Transactions table
-- Adding sample transaction records
INSERT INTO Transactions (transaction_id, customer_id, merchant_id, amount, currency, transaction_date)
VALUES
    (1, 1, 1, 250.50, 'USD', '2024-10-15'),
    (2, 2, 2, 45.00, 'USD', '2024-11-01'),
    (3, 3, 1, 300.75, 'USD', '2024-11-10'),
    (4, 1, 3, 99.99, 'USD', '2024-10-20'),
    (5, 2, 2, 75.00, 'USD', '2024-10-25'),
    (6, 3, 3, 120.50, 'USD', '2024-11-05');

-- 3. Querying Data

-- Retrieve transaction history for a specific customer
-- Query to get all transactions for customer with ID 1
SELECT 
    t.transaction_id,
    t.amount,
    t.currency,
    m.merchant_name,
    t.transaction_date
FROM 
    Transactions t
JOIN 
    Merchants m ON t.merchant_id = m.merchant_id
WHERE 
    t.customer_id = 1;

-- List all merchants who have processed at least one transaction in the last 30 days
-- Query to get merchants who have processed transactions within the last 30 days
SELECT DISTINCT
    m.merchant_name,
    m.business_type,
    m.contact_info
FROM
    Merchants m
JOIN
    Transactions t ON m.merchant_id = t.merchant_id
WHERE
    t.transaction_date >= CURRENT_DATE - INTERVAL '30 days';

-- 4. Advanced SQL Concepts

-- Calculate the total transaction amount for each merchant in the last year
-- Query to calculate the total transaction volume for each merchant over the past year
SELECT 
    m.merchant_name,
    SUM(t.amount) AS total_transaction_amount
FROM 
    Transactions t
JOIN 
    Merchants m ON t.merchant_id = m.merchant_id
WHERE 
    t.transaction_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY 
    m.merchant_name
ORDER BY 
    total_transaction_amount DESC;

-- Retrieve a list of all transactions along with customer and merchant names
-- Query to join transactions with customers and merchants
SELECT 
    t.transaction_id,
    c.name AS customer_name,
    m.merchant_name,
    t.amount,
    t.currency,
    t.transaction_date
FROM 
    Transactions t
JOIN 
    Customers c ON t.customer_id = c.customer_id
JOIN 
    Merchants m ON t.merchant_id = m.merchant_id
ORDER BY 
    t.transaction_date;

-- Find customers who have not made any transactions in the last 6 months
-- Query to find customers who have no transactions in the last 6 months
SELECT 
    c.customer_id,
    c.name
FROM 
    Customers c
WHERE 
    c.customer_id NOT IN (
        SELECT t.customer_id
        FROM Transactions t
        WHERE t.transaction_date >= CURRENT_DATE - INTERVAL '6 months'
    );

-- Find the top 5 merchants by transaction volume in the last year
-- Query to retrieve the top 5 merchants by total transaction volume over the last year
SELECT 
    m.merchant_name,
    SUM(t.amount) AS total_transaction_volume
FROM 
    Transactions t
JOIN 
    Merchants m ON t.merchant_id = m.merchant_id
WHERE 
    t.transaction_date >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY 
    m.merchant_name
ORDER BY 
    total_transaction_volume DESC
LIMIT 5;

