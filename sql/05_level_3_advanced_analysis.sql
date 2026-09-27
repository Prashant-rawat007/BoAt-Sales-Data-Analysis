
-- ========================================================================================
-- Question 14: Which months showed significant month-over-month revenue growth or decline?
-- ========================================================================================
-- Significant revenue movement is defined as a month-over-month change of ±10% or more.


with monthly_Sales as(
 select
  date_format(OrderDate,'%Y-%m') as month,
  round(sum(NetSales),2) as total_revenue
from sales_data
where nullif(trim(CancellationReason),'') is null
and nullif(trim(ReturnReason),'') is null
group by month
),
performance as (
    select 
     month,
     total_revenue,
    lag(total_revenue) over(order by month ) as previous_month_sales,
    total_revenue - lag(total_revenue) over(order by month) as revenue_changes,
    round(
        ((total_revenue - lag(total_revenue) over(order by month)) /
        lag(total_revenue) over(order by month))*100 ,2) as revenue_change_pct
	from monthly_sales
 )
select
    month,
    total_revenue,
	previous_month_sales,
    revenue_changes,
    revenue_change_pct,
    CASE
     WHEN revenue_change_pct >= 10 THEN 'Significant Growth'
     WHEN revenue_change_pct <= -10 THEN 'Significant Decline'
     WHEN revenue_change_pct IS NULL THEN 'No Previous Month'
    ELSE 'Not Significant'
   END as revenue_performance
from  performance;


-- ===========================================================================================================================
-- Question 15: Which products generate high revenue despite relatively low quantities sold, indicating higher-value products?
-- ===========================================================================================================================

WITH product AS (
    SELECT
        p.ProductName AS Product_Name,
        SUM(s.Quantity) AS unit_sold,
        ROUND(SUM(s.NetSales), 2) AS total_revenue
    FROM Product_Details p
    JOIN Sales_Data s
        ON p.ProductID = s.ProductID
    WHERE NULLIF(TRIM(s.CancellationReason), '') IS NULL
      AND NULLIF(TRIM(s.ReturnReason), '') IS NULL
    GROUP BY p.ProductID, p.ProductName
),
ranked_products AS (
    SELECT
        Product_Name,
        unit_sold,
        total_revenue,
        DENSE_RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS Revenue_Rank,
        DENSE_RANK() OVER (
            ORDER BY unit_sold
        ) AS Quantity_Rank,
        NTILE(4) OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_quartile,
        NTILE(4) OVER (
            ORDER BY unit_sold
        ) AS quantity_quartile,
        ROUND(total_revenue / unit_sold, 2) AS revenue_per_unit
    FROM product
)
SELECT
    Product_Name,
    unit_sold,
    total_revenue,
    Revenue_Rank,
    Quantity_Rank,
    revenue_quartile,
    quantity_quartile,
    revenue_per_unit
FROM ranked_products
WHERE revenue_quartile = 2
  AND quantity_quartile = 2
ORDER BY total_revenue DESC;

-- ===============================================================================
-- Question 16: Within each product category, which product is the revenue leader?
-- ===============================================================================

with product_revenue as(
select 
  p.category as category,
  p.ProductName as ProductName,
  round(sum(s.NetSales) , 2) as revenue
from product_details p
join sales_data s
on p.productID = s.productID
where nullif(trim(s.cancellationReason) ,'') is null
and nullif(trim(s.ReturnReason),'') is null
group by p.category, p.ProductName
),
top_products as(
select
 category,
 ProductName,
 revenue,
 dense_rank() over(partition by category order by revenue desc) as rnk
from product_revenue
)
select 
  category,
  ProductName,
  revenue,
  rnk
from top_products
where rnk = 1;

-- ========================================================================================
-- Question 17: Which product categories have shown the strongest revenue growth over time?
-- ========================================================================================


WITH category_yearly_sales AS (
    SELECT
        p.Category,
        YEAR(s.OrderDate) AS sales_year,
        ROUND(SUM(s.NetSales), 2) AS total_revenue
    FROM Product_Details p
    JOIN Sales_Data s
        ON p.ProductID = s.ProductID
    WHERE NULLIF(TRIM(s.CancellationReason), '') IS NULL
      AND NULLIF(TRIM(s.ReturnReason), '') IS NULL
    GROUP BY
        p.Category,
        YEAR(s.OrderDate)
),
category_growth AS (
    SELECT
        Category,
        SUM(CASE
            WHEN sales_year = 2023 THEN total_revenue
            ELSE 0
        END) AS revenue_2023,
        SUM(CASE
            WHEN sales_year = 2024 THEN total_revenue
            ELSE 0
        END) AS revenue_2024
    FROM category_yearly_sales
    GROUP BY Category
)
SELECT
    Category,
    ROUND(revenue_2023, 2) AS revenue_2023,
    ROUND(revenue_2024, 2) AS revenue_2024,
    ROUND(revenue_2024 - revenue_2023, 2) AS revenue_change,
    ROUND(
        ((revenue_2024 - revenue_2023) / revenue_2023) * 100,
        2
    ) AS growth_pct
FROM category_growth
ORDER BY growth_pct DESC;


-- =============================================================================
-- Question 18: Which product categories perform best within each sales channel?
-- =============================================================================
with top_category as (
select 
    c.ChannelName as Channel_Name,
    p.category as category,
    Round(Sum(NetSales) , 2) as revenue,
    dense_rank() over(partition by c.ChannelName order by Round(Sum(s.NetSales) , 2) desc) rnk
from sales_channel c 
join sales_data s
on c.channelID = s.channelID
join product_details p
on s.productID = p.productID
where nullif(trim(s.cancellationReason), '') is null
and nullif(trim(s.ReturnReason) ,'') is null
group by Channel_Name,category
)
select 
   Channel_Name,
   Category,
   revenue,
   rnk
from top_category
where rnk = 1;


-- ==================================================================================
-- Question 19: Which product category is the revenue leader in each customer region?
-- ==================================================================================

with top_category as (
select
   C.region,
   p.category,
   round(sum(s.NetSales) ,2 ) as revenue,
   dense_rank() over(partition by C.region order by round(sum(s.NetSales) ,2 ) desc) as rnk
from product_details p
join sales_data s
on p.productId = s.productId
join customer_details C
on C.customerID = s.CustomerId
where nullif(trim(s.CancellationReason) , '') is null
and nullif(trim(s.ReturnReason) , '') is null
group by c.region , p.category)

select
  region,
  category,
  revenue,
  rnk
from top_category
where rnk = 1;

-- =================================================================================
-- Question 20: How has each sales channel's revenue contribution changed over time?
-- =================================================================================

WITH contribution AS (
    SELECT
        YEAR(s.OrderDate) AS year,
        c.ChannelName AS channel,
        ROUND(SUM(s.NetSales), 2) AS channel_revenue,
        ROUND(
            SUM(s.NetSales)
            / SUM(SUM(s.NetSales)) OVER(PARTITION BY YEAR(s.OrderDate))
            * 100,
            2
        ) AS contribution
    FROM Sales_Data s
    JOIN Sales_Channel c
        ON s.ChannelID = c.ChannelID
    WHERE NULLIF(TRIM(s.CancellationReason), '') IS NULL
      AND NULLIF(TRIM(s.ReturnReason), '') IS NULL
    GROUP BY YEAR(s.OrderDate), c.ChannelName
)
SELECT
    channel,
    MAX(CASE WHEN year = 2023 THEN contribution END) AS contribution_2023,
    MAX(CASE WHEN year = 2024 THEN contribution END) AS contribution_2024,
    ROUND(
        MAX(CASE WHEN year = 2024 THEN contribution END) -
        MAX(CASE WHEN year = 2023 THEN contribution END),
        2
    ) AS contribution_change
FROM contribution
GROUP BY channel
ORDER BY channel;
