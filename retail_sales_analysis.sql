/*
=========================================================
PROJECT: RETAIL SALES PERFORMANCE ANALYSIS
TOOLS: PostgreSQL, DBeaver, SQL
DATABASE: retail_sales
SCHEMA: public
TABLE: orders

OBJECTIVE:
Analyze retail sales performance, product profitability,
customer spending behavior, and sales trends to identify
business opportunities and potential losses.
=========================================================
*/


/* =====================================================
   1. DATA OVERVIEW
   ===================================================== */

-- 1.1 Retrieve sample records
SELECT *
FROM public.orders
LIMIT 10;


-- 1.2 Count total records
SELECT
    COUNT(*) AS total_records
FROM public.orders;
-- Result:
-- The dataset contains 9,994 records.


-- 1.3 Identify the transaction date range
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM public.orders;
-- Result:
-- The dataset covers transactions from 2017-01-03 to 2020-12-30.


-- 1.4 Count unique orders, customers, products, and cities
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_id) AS total_products,
    COUNT(DISTINCT city) AS total_cities
FROM public.orders;
-- Result:
-- The dataset contains 5009 unique orders,
-- 793 customers, 1862 products, and 531 cities.



/* =====================================================
   2. DATA VALIDATION
   ===================================================== */

-- 2.1 Check missing values in key columns
SELECT
    COUNT(*) FILTER (
        WHERE order_id IS NULL
    ) AS missing_order_ids,
    
    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS missing_customer_ids,
    
    COUNT(*) FILTER (
        WHERE product_id IS NULL
    ) AS missing_product_ids,
    
    COUNT(*) FILTER (
        WHERE sales IS NULL
    ) AS missing_sales,
    
    COUNT(*) FILTER (
        WHERE profit IS NULL
    ) AS missing_profit,
    
    COUNT(*) FILTER (
        WHERE order_date IS NULL
    ) AS missing_order_dates
FROM public.orders;
-- Result:
-- No missing values were found in the selected key columns.


-- 2.2 Identify Potential Duplicate Order-Product Combinations
SELECT
    order_id,
    product_id,
    COUNT(*) AS record_count
FROM public.orders
GROUP BY
    order_id,
    product_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC;
-- Result:
-- 8 order-product combinations were flagged for further inspection.

-- 2.2.1 Inspect Potential Duplicate Records
SELECT *
FROM public.orders
WHERE order_id IN (
    'CA-2019-140571',
    'CA-2020-152912',
    'CA-2018-103135',
    'US-2019-123750',
    'CA-2019-129714',
    'CA-2019-137043',
    'US-2017-150119',
    'CA-2020-118017'
)
ORDER BY order_id, product_id;

-- 2.2.2 Verify Exact Duplicate Records
SELECT
    order_id,
    customer_id,
    product_id,
    sales,
    quantity,
    discount,
    profit,
    category,
    subcategory,
    product_name,
    order_date,
    COUNT(*) AS duplicate_count
FROM public.orders
GROUP BY
    order_id,
    customer_id,
    product_id,
    sales,
    quantity,
    discount,
    profit,
    category,
    subcategory,
    product_name,
    order_date
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
-- Result:
-- 1 potential duplicate record identified
-- based on the selected columns.


-- 2.3 Check unusual numeric values
SELECT
    COUNT(*) FILTER (
        WHERE sales < 0
    ) AS negative_sales_records,
    
    COUNT(*) FILTER (
        WHERE quantity <= 0
    ) AS nonpositive_quantity_records,
    
    COUNT(*) FILTER (
        WHERE discount < 0 OR discount > 1
    ) AS discount_out_of_range_records
FROM public.orders;
-- Result:
-- No unusual numeric values were found in the selected columns.



/* =====================================================
   3. SALES PERFORMANCE ANALYSIS
   ===================================================== */

-- 3.1 Identify the top 5 cities by revenue
-- Business Question: Which cities generate the highest revenue?
SELECT
    city,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM public.orders
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 5;
-- Result:
-- New York City generated the highest revenue,
-- followed by Los Angeles and Seattle.


-- 3.2 Analyze sales performance by product category
-- Business Question: Which categories contribute most to sales?
SELECT
    category,
    SUM(quantity) AS total_quantity_sold,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit
FROM public.orders
GROUP BY category
ORDER BY total_revenue DESC;
-- Result:
-- Technology generated the highest revenue,
-- followed by Furniture.



/* =====================================================
   4. PRODUCT PERFORMANCE AND PROFITABILITY
   ===================================================== */

-- 4.1 Identify the top 10 best-selling products
-- Business Question: Which products sell the most units?
SELECT
    product_id,
    product_name,
    SUM(quantity) AS total_quantity_sold,
    SUM(sales) AS total_revenue
FROM public.orders
GROUP BY
    product_id,
    product_name
ORDER BY
    total_quantity_sold DESC
LIMIT 10;
-- Result:
-- Logitech P710e Mobile Speakerphone ranked first
-- in total units sold.


-- 4.2 Identify the top 10 most profitable products
-- Business Question: Which products generate the highest total profit?
SELECT
    product_id,
    product_name,
    SUM(quantity) AS total_quantity_sold,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit
FROM public.orders
GROUP BY
    product_id,
    product_name
ORDER BY total_profit DESC
LIMIT 10;
-- Result:
-- Canon imageCLASS 2200 Advanced Copier generated
-- the highest total profit.


-- 4.3 Identify products with negative cumulative profit
-- Business Question: Which products generate an overall loss?
SELECT
    product_id,
    product_name,
    SUM(quantity) AS total_quantity_sold,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit
FROM public.orders
GROUP BY
    product_id,
    product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC
LIMIT 10;
-- Result:
-- Several products recorded negative cumulative profit.
-- Cubify CubeX 3D Printer Double Head Print had the largest loss.


-- 4.4 Identify loss-making transaction records
-- Business Question: Which product-level records have negative profit?
SELECT
    order_id,
    order_date,
    city,
    customer_name,
    product_id,
    product_name,
    sales,
    quantity,
    discount,
    profit
FROM public.orders
WHERE profit < 0
ORDER BY profit ASC
LIMIT 20;
-- Result:
-- The 20 records with the lowest profit are displayed
-- to identify loss-making product transactions.



/* =====================================================
   5. CUSTOMER ANALYSIS
   ===================================================== */

-- 5.1 Calculate customer spending statistics
-- Business Question: How much do customers spend on average?
WITH customer_spending AS (
    SELECT
        customer_id,
        customer_name,
        SUM(sales) AS total_spending
    FROM public.orders
    WHERE customer_id IS NOT NULL
    GROUP BY
        customer_id,
        customer_name
)
SELECT
    COUNT(*) AS total_customers,
    ROUND(AVG(total_spending)::NUMERIC, 2) AS average_spending,
    ROUND(MIN(total_spending)::NUMERIC, 2) AS minimum_spending,
    ROUND(MAX(total_spending)::NUMERIC, 2) AS maximum_spending
FROM customer_spending;
-- Result:
-- Average customer spending was 2896.85,
-- ranging from 4.83 to 25043.1.


-- 5.2 Identify the top 10 customers by spending
-- Business Question: Which customers have the highest total spending?
SELECT
    customer_id,
    customer_name,
    SUM(sales) AS total_spending,
    COUNT(DISTINCT order_id) AS total_orders
FROM public.orders
WHERE customer_id IS NOT NULL
GROUP BY
    customer_id,
    customer_name
ORDER BY total_spending DESC
LIMIT 10;
-- Result:
-- Sean Miller recorded the highest total spending.


-- 5.3 Analyze performance by customer segment
-- Business Question: Which segments contribute most to revenue and profit?
SELECT
    segment,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity_sold
FROM public.orders
GROUP BY segment
ORDER BY total_revenue DESC;
-- Result:
-- Consumer contributed the highest revenue,
-- followed by Corporate.



/* =====================================================
   6. SALES TRENDS ANALYSIS
   ===================================================== */

-- 6.1 Analyze monthly sales and profit trends
-- Business Question: How do revenue and profit change over time?
SELECT
    DATE_TRUNC('month', order_date)::DATE AS order_month,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity_sold,
    COUNT(DISTINCT order_id) AS total_orders
FROM public.orders
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)::DATE
ORDER BY order_month;
-- Result:
-- Monthly revenue and profit fluctuated throughout the analysis period.
-- January 2017 recorded the highest monthly revenue.


-- 6.2 Compare annual sales performance
-- Business Question: How does sales performance vary by year?
SELECT
    EXTRACT(YEAR FROM order_date)::INTEGER AS order_year,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM public.orders
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_date)::INTEGER
ORDER BY order_year;
-- Result:
-- 2020 recorded the highest annual revenue, profit, and total orders.


/* =====================================================
   END OF ANALYSIS
   ===================================================== */