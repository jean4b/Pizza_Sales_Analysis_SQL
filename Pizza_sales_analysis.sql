# Retrieve top 10 most purchased pizzas
select pizza_name, count(*) as total_sold
from pizza_sales
group by pizza_name
order by total_sold desc limit 10

# Retrieve 10 least purchased pizzas
select pizza_name, count(*) as total_sold
from pizza_sales
group by pizza_name
order by total_sold limit 10

# Retrieve top 10 most revenue generated pizza
select pizza_name, sum(total_price) as total_revenue
from pizza_sales
group by pizza_name
order by total_revenue desc limit 10

# Retrieve top 10 least revenue generated pizza
select pizza_name, sum(total_price) as total_revenue
from pizza_sales
group by pizza_name
order by total_revenue limit 10

# Summary of pizza name, amount solde, total revenue, and revenue per amount sold ratio
SELECT
    pizza_name,
    SUM(quantity) AS amount_sold,
    SUM(total_price) AS total_revenue,
    ROUND((SUM(total_price) / SUM(quantity)),2) AS revenue_per_amount_sold_ratio
FROM
    pizza_sales
GROUP BY
    pizza_name
ORDER BY
	revenue_per_amount_sold_ratio DESC LIMIT 10;

# Retrieve distinct pizza categories and total amount sold
select pizza_category, count(*) as total_sold
from pizza_sales
group by pizza_category

# Retrieve distinct pizza categories and total amount sold
select pizza_category, sum(total_price) as total_revenue
from pizza_sales
group by pizza_category

# Summary of pizza category, amount solde, total revenue, and revenue per amount sold ratio
SELECT
    pizza_category,
    SUM(quantity) AS amount_sold,
    SUM(total_price) AS total_revenue,
    ROUND((SUM(total_price) / SUM(quantity)),2) AS revenue_per_amount_sold_ratio
FROM
    pizza_sales
GROUP BY
    pizza_category
ORDER BY
	revenue_per_amount_sold_ratio DESC LIMIT 10;

# Retrieve distinct pizza size and total amount sold
select pizza_size, count(*) as total_sold
from pizza_sales
group by pizza_size
order by total_sold desc

# Retrieve distinct order date revene obtained
select order_date, sum(total_price) as total_revenue
from pizza_sales
group by order_date


# Retrieve each order date (month, day) total revenue generated
WITH RevenuePerDate AS (
	SELECT 
		order_date,
		SUM(total_price) AS revenue_generated
	FROM 
		pizza_sales
	GROUP BY 
		order_date
    ORDER BY 
		revenue_generated DESC
)

, RevenueDateSummary AS (
	SELECT
		order_date,
		SUBSTRING(order_date, 4, 2) AS month,
		SUBSTRING(order_date, 1, 2) AS day,
		revenue_generated
	FROM
		RevenuePerDate
)
## Revenue per month
SELECT month, ROUND((sum(revenue_generated)), 1) as revenue
FROM RevenueDateSummary
GROUP BY month
ORDER BY revenue DESC

# max product per month
WITH MonthlyMaxRevenue AS (
    SELECT 
        SUBSTRING(order_date, 4, 2) AS month,
        MAX(total_price) AS max_revenue
    FROM 
        pizza_sales
    GROUP BY 
        SUBSTRING(order_date, 4, 2)
)

SELECT 
    m.month,
    p.pizza_name,
    m.max_revenue AS max_revenue_per_month
FROM 
    MonthlyMaxRevenue m
JOIN 
    pizza_sales p ON SUBSTRING(p.order_date, 4, 2) = m.month AND p.total_price = m.max_revenue;

# each month most revenue generated pizza
WITH MonthlyMaxRevenue AS (
    SELECT 
        SUBSTRING(order_date, 4, 2) AS month,
        MAX(total_price) AS max_revenue
    FROM 
        pizza_sales
    GROUP BY 
        SUBSTRING(order_date, 4, 2)
)

SELECT 
    m.month,
    GROUP_CONCAT(DISTINCT p.pizza_name ORDER BY p.pizza_name SEPARATOR ', ') AS distinct_pizza_name_per_month,
    GROUP_CONCAT(DISTINCT p.pizza_category ORDER BY p.pizza_category SEPARATOR ', ') AS distinct_pizza_category_per_month,
    GROUP_CONCAT(DISTINCT p.pizza_size ORDER BY p.pizza_size SEPARATOR ', ') AS distinct_pizza_size_per_month,
    GROUP_CONCAT(DISTINCT m.max_revenue ORDER BY m.max_revenue SEPARATOR ', ') AS distinct_max_revenue_per_month
FROM 
    MonthlyMaxRevenue m
JOIN 
    pizza_sales p ON SUBSTRING(p.order_date, 4, 2) = m.month AND p.total_price = m.max_revenue
GROUP BY 
    m.month;
    
# order id: number of orders and total revenue
select order_id, count(*), sum(total_price)
from pizza_sales
group by order_id
order by count(*) desc

# monthly summary: most purchased pizza, most purchased pizza category, and most purchased pizza size
SELECT SUBSTRING(order_date, 4, 2) AS month, SUM(total_price) AS total_price_per_month,
    (
        SELECT pizza_name
        FROM pizza_sales
        WHERE SUBSTRING(order_date, 4, 2) = SUBSTRING(ps.order_date, 4, 2)
        GROUP BY pizza_name
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS most_purchased_pizza_name,
    (
        SELECT pizza_category
        FROM pizza_sales
        WHERE SUBSTRING(order_date, 4, 2) = SUBSTRING(ps.order_date, 4, 2)
        GROUP BY pizza_category
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS most_purchased_pizza_category,
    (
        SELECT pizza_size
        FROM pizza_sales
        WHERE SUBSTRING(order_date, 4, 2) = SUBSTRING(ps.order_date, 4, 2)
        GROUP BY pizza_size
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS most_purchased_pizza_size
FROM 
    pizza_sales ps
GROUP BY 
    SUBSTRING(order_date, 4, 2);


