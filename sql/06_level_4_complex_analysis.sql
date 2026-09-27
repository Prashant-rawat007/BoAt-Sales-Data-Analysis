
-- ==============================================================================================================
-- Question 21: Who are the top 10 customers by revenue, and what percentage of total revenue do they contribute?
-- ==============================================================================================================

with customer as (
select 
   c.customerID as customerID,
   round(Sum(s.Netsales) ,2) as customer_revenue,
   sum(sum(s.Netsales)) over() as total_revenue
from customer_details c
join sales_data s
on c.customerID = s.customerID
WHERE NULLIF(TRIM(s.CancellationReason), '') IS NULL
AND NULLIF(TRIM(s.ReturnReason), '') IS NULL
group by customerID
order by customer_revenue desc
limit 10
)
select
   customerID,
   customer_revenue,
   total_revenue,
   round((customer_revenue / total_revenue)*100 ,4) as Revenue_contribution
from customer;


-- ===============================================================================================
-- Question 22: What is the overall cancellation rate, and how does it vary across sales channels?
-- ===============================================================================================

WITH channel_total_order AS (
    SELECT
        channelName,
        COUNT(salesID) AS total_orders
    FROM sales_channel c
    JOIN sales_data s
        ON s.channelID = c.channelID
    GROUP BY channelName
),

channel_cancelled_order AS (
    SELECT
        channelName,
        COUNT(cancellationReason) AS cancelled_orders
    FROM sales_channel c
    JOIN sales_data s
        ON s.channelID = c.channelID
    WHERE NULLIF(TRIM(cancellationReason), '') IS NOT NULL
    GROUP BY channelName
),

cancelled_rate AS (
    SELECT
        t.channelName,
        t.total_orders,
        c.cancelled_orders,
        ROUND(
            (c.cancelled_orders / t.total_orders) * 100,
            2
        ) AS cancelled_rate
    FROM channel_total_order t
    JOIN channel_cancelled_order c
        ON t.channelName = c.channelName
),

overall_cancellation AS (
    SELECT
        COUNT(SalesID) AS total_orders,
        COUNT(
            CASE
                WHEN NULLIF(TRIM(CancellationReason), '') IS NOT NULL
                THEN 1
            END
        ) AS cancelled_orders,
        ROUND(
            COUNT(
                CASE
                    WHEN NULLIF(TRIM(CancellationReason), '') IS NOT NULL
                    THEN 1
                END
            ) / COUNT(SalesID) * 100,
            2
        ) AS cancellation_rate
    FROM Sales_Data
)

SELECT
    c.channelName,
    c.total_orders,
    c.cancelled_orders,
    c.cancelled_rate,
    o.cancellation_rate AS overall_cancellation_rate
FROM cancelled_rate c
CROSS JOIN overall_cancellation o;


-- ============================================================================================================================
-- Question 23: What are the most common cancellation reasons, and what proportion of cancellations does each reason represent?
-- ============================================================================================================================

with cancellation_reason as(
select 
     cancellationReason,
      count(*) as cancelled_orders
from Sales_data
where nullif(trim(cancellationReason),'') is not null
group by CancellationReason 
order by cancelled_orders desc
),
total_cancelled as (
SELECT
	COUNT(cancellationReason) AS total_cancelled_orders
FROM sales_data s
WHERE NULLIF(TRIM(cancellationReason), '') IS NOT NULL
)
select
   c.cancellationReason,
   c.cancelled_orders,
   round((c.cancelled_orders/t.total_cancelled_orders)*100,2) as cancellation_share
from cancellation_reason c
cross join total_cancelled t;


-- ===========================================================================================================
-- Question 24:Which products have unusually high cancellation rates compared with their overall sales volume?
-- ===========================================================================================================


WITH total_orders AS (
    SELECT
        productName,
        SUM(quantity) AS total_units_sold,
        COUNT(SalesID) AS total_order
    FROM product_details p
    JOIN sales_data s
        ON p.productID = s.productID
    GROUP BY productName
),
cancelled_order AS (
    SELECT
        productName,
        COUNT(CancellationReason) AS cancelled_order
    FROM product_details p
    JOIN sales_data s
        ON p.productID = s.productID
    WHERE NULLIF(TRIM(CancellationReason), '') IS NOT NULL
    GROUP BY productName
),
product_metrics AS (
    SELECT
        t.productName,
        t.total_units_sold,
        t.total_order,
        c.cancelled_order,
        ROUND((c.cancelled_order / t.total_order) * 100,2) AS cancellation_rate
    FROM total_orders t
    JOIN cancelled_order c
        ON t.productName = c.productName
),

ranked_products AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY total_units_sold) AS volume_row,
        ROW_NUMBER() OVER (ORDER BY cancellation_rate) AS rate_row,
        COUNT(*) OVER () AS total_products
    FROM product_metrics
),

medians AS (
    SELECT
        AVG(
            CASE
                WHEN volume_row IN (
                    FLOOR((total_products + 1) / 2),
                    CEIL((total_products + 1) / 2)
                )
                THEN total_units_sold
            END
        ) AS median_units_sold,

        AVG(
            CASE
                WHEN rate_row IN (
                    FLOOR((total_products + 1) / 2),
                    CEIL((total_products + 1) / 2)
                )
                THEN cancellation_rate
            END
        ) AS median_cancellation_rate
    FROM ranked_products
)

SELECT
    r.productName,
    r.total_units_sold,
    r.total_order,
    r.cancelled_order,
    r.cancellation_rate,
    ROUND(m.median_units_sold, 2) AS median_units_sold,
    ROUND(m.median_cancellation_rate, 2) AS median_cancellation_rate
FROM ranked_products r
CROSS JOIN medians m
WHERE r.cancellation_rate > m.median_cancellation_rate
  AND r.total_units_sold > m.median_units_sold
ORDER BY r.cancellation_rate DESC;


-- =========================================================================================================
-- Question 25:Which combination of Region + Sales Channel + Product Category generates the highest revenue?
-- =========================================================================================================

select
  c.region,
  s.channelName,
  p.Category,
  sum(d.Netsales) as revenue
from customer_details c
join sales_data d
on d.customerID = c.customerID
join product_details p
on p.productID = d.productID
join sales_channel s
on s.channelID = d.channelID
where nullif(trim(d.cancellationReason),'') is null
and nullif(trim(d.ReturnReason),'') is null
group by region,channelName,category
order by revenue desc
limit 1;
