create database olist;
use olist;

-- question 1
-- weekday vs weekend payment stats
SELECT 
    CASE 
        WHEN WEEKDAY(o.order_purchase_timestamp) IN (5, 6) THEN 'Weekend' 
        ELSE 'Weekday' 
    END AS day_type,
    COUNT(p.payment_value) AS total_payments,
    SUM(p.payment_value) AS total_payment_amount
FROM olist_order_payments_dataset p
JOIN olist_orders_dataset o 
    ON p.order_id = o.order_id
GROUP BY day_type;


-- question 2
-- average shipping days for different states
SELECT 
    g.geolocation_state AS State, 
    ROUND(AVG(oi.price), 2) AS Average_Sales
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o 
    ON oi.order_id = o.order_id
JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
JOIN olist_geolocation_dataset g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_state
ORDER BY Average_Sales DESC;

-- question 3
-- relationships between shipping days and review scores
SELECT 
    r.review_score AS Review_Score,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS Avg_Shipping_Days,
    COUNT(o.order_id) AS Order_Count
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r
    ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY r.review_score
ORDER BY Review_Score;

-- question 4
-- number of orders by payment type
SELECT 
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_orders DESC;

-- question 5
-- top 10 seller count states
SELECT 
    seller_state, 
    COUNT(seller_id) AS seller_count
FROM olist_sellers_dataset
GROUP BY seller_state
ORDER BY seller_count DESC
LIMIT 10;

-- question 6
-- top 10 coustomer count states
SELECT 
    customer_state, 
    COUNT(customer_id) AS customer_count
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY customer_count DESC
LIMIT 10;

-- question 7
-- average delivery time by day of the month
SELECT 
    DAY(o.order_purchase_timestamp) AS order_day,
    AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS avg_delivery_days
FROM olist_orders_dataset o
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY order_day
ORDER BY order_day;

-- question 8
-- year wise payments
SELECT 
    YEAR(o.order_purchase_timestamp) AS payment_year,
    SUM(p.payment_value) AS total_payments
FROM olist_order_payments_dataset p
JOIN olist_orders_dataset o ON p.order_id = o.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY payment_year
ORDER BY payment_year;

-- question 9
-- bottom 10 products by payments
SELECT 
    p.product_id, 
    pr.product_category_name, 
    SUM(op.payment_value) AS total_payments
FROM olist_order_payments_dataset op
JOIN olist_orders_dataset o ON op.order_id = o.order_id
JOIN olist_order_items_dataset p ON o.order_id = p.order_id
JOIN olist_products_dataset pr ON p.product_id = pr.product_id
GROUP BY p.product_id, pr.product_category_name
ORDER BY total_payments ASC
LIMIT 10;

-- question 10
-- order count by delivery status
SELECT 
    order_status,
    COUNT(order_id) AS order_count
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY order_count DESC;











