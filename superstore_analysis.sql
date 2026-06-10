-- ============================================================
-- SUPERSTORE SALES ANALYSIS
-- Author   : rowan aymn
-- Database : PostgreSQL — superstore
-- Dataset  : Sample Superstore (Tableau)
-- Purpose  : End-to-end business analysis covering revenue,
--            profitability, geography, customer segments,
--            product performance, time trends, and returns.
-- ============================================================


-- ============================================================
-- SECTION 1: REVENUE & PROFIT BY CATEGORY
-- Business Question: Which product categories drive the most
-- revenue and profit for the business?
-- ============================================================

-- Q1: Total sales revenue by category
SELECT
    p."Category",
    ROUND(SUM(oi."Sales")::numeric, 2) AS total_sales
FROM order_items oi
JOIN products p ON oi."Product ID" = p."Product ID"
GROUP BY p."Category"
ORDER BY total_sales DESC;


-- Q2: Total sales by sub-category (deeper product drill-down)
SELECT
    p."Sub-Category",
    ROUND(SUM(oi."Sales")::numeric, 2) AS total_sales
FROM order_items oi
JOIN products p ON oi."Product ID" = p."Product ID"
GROUP BY p."Sub-Category"
ORDER BY total_sales DESC;


-- Q3: Total profit by category
-- Insight: High sales doesn't always mean high profit.
-- Compare with Q1 to spot margin issues.
SELECT
    p."Category",
    ROUND(SUM(oi."Profit")::numeric, 2) AS total_profit
FROM order_items oi
JOIN products p ON oi."Product ID" = p."Product ID"
GROUP BY p."Category"
ORDER BY total_profit DESC;


-- Q4: Categories with NEGATIVE profit (loss-making)
-- Insight: Where is the business actively losing money?
SELECT
    p."Category",
    ROUND(SUM(oi."Profit")::numeric, 2) AS total_profit
FROM order_items oi
JOIN products p ON oi."Product ID" = p."Product ID"
GROUP BY p."Category"
HAVING SUM(oi."Profit") < 0;


-- ============================================================
-- SECTION 2: PRODUCT PERFORMANCE
-- Business Question: Which specific products are top performers
-- and which are dragging down profitability?
-- ============================================================

-- Q5: Top 10 products by revenue
SELECT
    p."Product Name",
    ROUND(SUM(oi."Sales")::numeric, 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi."Product ID" = p."Product ID"
GROUP BY p."Product Name"
ORDER BY total_revenue DESC
LIMIT 10;


-- Q6: Products with negative profit (loss-makers)
-- Insight: These products cost the business money — candidates
-- for repricing, discontinuation, or discount review.
SELECT
    p."Product Name",
    ROUND(SUM(oi."Profit")::numeric, 2) AS total_profit
FROM order_items oi
JOIN products p ON oi."Product ID" = p."Product ID"
GROUP BY p."Product Name"
HAVING SUM(oi."Profit") < 0
ORDER BY total_profit ASC;


-- Q7: Window Function — Rank products within each category by sales
-- Insight: Who are the top performers inside each category?
-- RANK() is a window function — it ranks without collapsing rows.
SELECT
    p."Category",
    p."Product Name",
    ROUND(SUM(oi."Sales")::numeric, 2) AS total_sales,
    RANK() OVER (
        PARTITION BY p."Category"
        ORDER BY SUM(oi."Sales") DESC
    ) AS rank_in_category
FROM order_items oi
JOIN products p ON oi."Product ID" = p."Product ID"
GROUP BY p."Category", p."Product Name"
ORDER BY p."Category", rank_in_category;


-- ============================================================
-- SECTION 3: GEOGRAPHIC ANALYSIS
-- Business Question: Which states and regions generate the most
-- revenue, and where should the business focus to grow?
-- ============================================================

-- Q8: CTE — Top 5 states by total sales
-- Using a CTE (Common Table Expression) for clean, readable code.
WITH state_sales AS (
    SELECT
        g."State",
        ROUND(SUM(oi."Sales")::numeric, 2) AS total_sales
    FROM orders o
    JOIN geography g ON o."Postal Code" = g."Postal Code"
    JOIN order_items oi ON o."Order ID" = oi."Order ID"
    GROUP BY g."State"
)
SELECT *
FROM state_sales
ORDER BY total_sales DESC
LIMIT 5;


-- ============================================================
-- SECTION 4: TIME-BASED TREND ANALYSIS
-- Business Question: Is the business growing year over year?
-- ============================================================

-- Q9: Year-over-year sales and profit trend
-- Insight: Are both revenue and profit growing together?
-- A growing revenue with shrinking profit signals a margin problem.
SELECT
    EXTRACT(YEAR FROM o."Order Date") AS year,
    ROUND(SUM(oi."Sales")::numeric, 2)   AS total_sales,
    ROUND(SUM(oi."Profit")::numeric, 2)  AS total_profit
FROM orders o
JOIN order_items oi ON o."Order ID" = oi."Order ID"
GROUP BY year
ORDER BY year;


-- ============================================================
-- SECTION 5: CUSTOMER SEGMENT ANALYSIS
-- Business Question: Which customer segment is most valuable?
-- This directly informs the ML segmentation model.
-- ============================================================

-- Q10: Revenue, order count, and average order value by segment
SELECT
    c."Segment",
    COUNT(DISTINCT o."Order ID")             AS total_orders,
    ROUND(SUM(oi."Sales")::numeric, 2)       AS total_revenue,
    ROUND(AVG(oi."Sales")::numeric, 2)       AS avg_order_value
FROM customers c
JOIN orders o     ON c."Customer ID" = o."Customer ID"
JOIN order_items oi ON o."Order ID"  = oi."Order ID"
GROUP BY c."Segment"
ORDER BY total_revenue DESC;


-- ============================================================
-- SECTION 6: RETURNS ANALYSIS
-- Business Question: Which categories have the highest return
-- rates? High returns destroy profit and signal quality issues.
-- ============================================================

-- Q11: Return rate by category (LEFT JOIN to include non-returned orders)
-- LEFT JOIN ensures we keep ALL orders, even those not returned.
SELECT
    p."Category",
    COUNT(DISTINCT oi."Order ID")  AS total_orders,
    COUNT(DISTINCT r."Order ID")   AS returned_orders,
    ROUND(
        COUNT(DISTINCT r."Order ID") * 100.0 /
        COUNT(DISTINCT oi."Order ID"), 2
    ) AS return_rate_pct
FROM order_items oi
JOIN products p   ON oi."Product ID" = p."Product ID"
LEFT JOIN returns r ON oi."Order ID" = r."Order ID"
GROUP BY p."Category"
ORDER BY return_rate_pct DESC;


-- ============================================================
-- END OF ANALYSIS
-- Key Findings Summary:
--   - Technology leads in revenue; Office Supplies in volume
--   - Furniture shows profit margin concerns (review discounts)
--   - Consumer segment drives the most revenue
--   - Technology has the highest return rate (7.97%)
--   - Business shows consistent YoY growth
-- Next Step: Python EDA + ML return prediction model
-- ============================================================
