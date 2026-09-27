
-- =================================================================================================================
-- Question 7: How has monthly revenue changed over time, and which months experienced the highest and lowest sales?
-- =================================================================================================================

with monthly_sales as (
 select
   date_format(orderDate, '%Y-%m') as month,
   round(sum(NetSales),2) as total_revenue
 from sales_data
 where nullif(trim(CancellationReason),'') is null
 and nullif(trim(ReturnReason),'') is null
 group by month
 )
 
select 
    month,
    total_revenue,
    LAG(total_revenue) OVER(ORDER BY month) as previous_month_revenue,
  
    total_revenue - LAG(total_revenue) OVER(ORDER BY month)
     as revenue_change,
     
    round(
	   (
          (total_revenue - LAG(total_revenue) OVER(ORDER BY month))
          /LAG(total_revenue) OVER(ORDER BY month)
          )*100,
          2
	   ) as revenue_change_pct
from monthly_sales;

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(OrderDate, '%Y-%m') AS month,
        ROUND(SUM(NetSales), 2) AS total_revenue
    FROM Sales_Data
    WHERE NULLIF(TRIM(CancellationReason), '') IS NULL
      AND NULLIF(TRIM(ReturnReason), '') IS NULL
    GROUP BY month
)

SELECT
    month,
    total_revenue
FROM monthly_sales
ORDER BY total_revenue DESC
LIMIT 1; 

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(OrderDate, '%Y-%m') AS month,
        ROUND(SUM(NetSales), 2) AS total_revenue
    FROM Sales_Data
    WHERE NULLIF(TRIM(CancellationReason), '') IS NULL
      AND NULLIF(TRIM(ReturnReason), '') IS NULL
    GROUP BY month
)

SELECT
    month,
    total_revenue
FROM monthly_sales
ORDER BY total_revenue asc
LIMIT 1;


-- =====================================================================================================================
-- Question 8:Which 10 products generated the highest revenue, and what percentage of total revenue did they contribute?
-- ======================================================================================================================

with products as (
   SELECT
     p.productId,
     p.productName as productName,
     ROUND(SUM(s.NetSales), 2) AS product_revenue
   FROM Product_Details p
   JOIN Sales_Data s
     ON p.ProductID = s.ProductID
   WHERE NULLIF(TRIM(s.CancellationReason), '') IS NULL
   AND NULLIF(TRIM(s.ReturnReason), '') IS NULL
   GROUP BY p.productID,p.ProductName
   ORDER BY product_revenue DESC
   LIMIT 10
),
total_revenue as(
   SELECT
      sum(NetSales) as total
   from Sales_Data 
   WHERE NULLIF(TRIM(CancellationReason), '') IS NULL
   AND NULLIF(TRIM(ReturnReason), '') IS NULL   
)
select 
    p.productName,
    p.product_revenue,
    round((p.product_revenue/t.total)*100,2) as total_revenue_pct
from products p
cross join total_revenue t
order by product_revenue Desc;
  
  
-- ====================================================================================================
-- Question 9: Which products are the best sellers by quantity, and do they also generate high revenue?
-- ====================================================================================================


with by_quantity as(
select 
  p.productName as product_name,
  sum(s.quantity) as total_unit_sold,
  round(sum(s.NetSales), 2) as total_revenue
from product_details p
join sales_data s
on p.productID = s.productID
where nullif(trim(cancellationReason),'') is null
and nullif(trim(ReturnReason),'') is null
group by p.productID , p.productName
order by total_unit_sold desc
limit 10)

select 
  product_name,
  total_unit_sold,
  total_revenue,
  dense_rank() over(order by total_unit_sold desc) as top_products
from by_quantity ;
  
  
-- =========================================================================================
-- Queston 10: Which customer segments generate the highest revenue and average order value?
-- =========================================================================================

 
 select
   c.Segment,
   round(sum(s.NetSales),2) as total_revenue,
   round(sum(s.NetSales)/count(s.SalesID),2) as avg_order_value
from Customer_details c
join sales_data s
on c.customerID = s.customerID
where nullif(trim(CancellationReason),'') is null
and nullif(trim(ReturnReason),'') is null
group by c.segment
order by total_revenue desc;


-- ==========================================================================
-- Question 11: How many customers are new customers versus repeat customers?
-- ==========================================================================

select
   case 
    when count(*) = 1 then 'One time Customer'
    else 'Repeated Customer'
   END as customer_type,
   count(*)
from (
	select
      CustomerID,
      count(*) as order_count
	from sales_data
    where nullif(trim(cancellationReason),'') is null
    and nullif(trim(ReturnReason), '') is null
    group by CustomerID
    ) as customer_order
group by 
  case
    when order_count = 1 then 'One time Customer'
    else 'Repeated Customer'
  End;


-- ===============================================================================================================
-- Question 12: How much revenue is generated by repeat customers compared with customers who purchased only once?
-- ===============================================================================================================

with customer_revenue as(
select
   Customer_type,
   sum(total_revenue) as total_revenue
from (
	select
      CustomerID,
      case 
          when count(*) = 1 then 'One time Customer'
          else 'Repeated Customer'
      END as customer_type,
      sum(NetSales) as total_revenue
	from sales_data
    where nullif(trim(cancellationReason),'') is null
    and nullif(trim(ReturnReason), '') is null
    group by CustomerID
    ) as customer_orders
group by 
  customer_type )

select
 customer_type,
 total_revenue,
 Round(
     total_revenue / sum(total_revenue) over() * 100,
     2
) as Revenue_share_pct
from customer_revenue;


-- =======================================================================
-- Question 13: Which sales channels have the highest average order value?
-- =======================================================================

select 
  c.ChannelName,
  sum(s.Netsales) as total_revenue ,
  count(s.SalesID) as order_count,
  round(sum(s.NetSales)/count(s.salesID),2) as  average_order_value
from sales_channel c
join Sales_data s
on c.ChannelID = s.ChannelID
where nullif(trim(s.cancellationReason),'') is null
and nullif(trim(s.ReturnReason),'') is null
group by c.channelID
order by average_order_value desc;
