-- ======================================================================
/* Question 1: What are the key overall sales metrics -
total revenue, total orders, total units sold, and average order value? */
-- =======================================================================

SELECT
    ROUND(SUM(NetSales), 2) AS total_revenue,
    COUNT(SalesID) AS total_orders,
    SUM(Quantity) AS total_units_sold,
    ROUND(SUM(NetSales) / COUNT(SalesID), 2) AS avg_order_value
FROM Sales_Data
WHERE NULLIF(TRIM(CancellationReason), '') IS NULL
AND NULLIF(TRIM(ReturnReason), '') is null;


-- ====================================================================================
-- Question 2: Which sales channels generate the most revenue, orders, and units sold?
-- ====================================================================================

select
  c.channelname as channel_name,
  c.channelscope as channel_type,
  round(sum(d.NetSales),2) as total_revenue,
  count(d.salesId) as total_order,
  sum(d.quantity) as total_unit_sold
from sales_data d
join sales_channel c
on d.channelId = c.channelId
WHERE NULLIF(TRIM(CancellationReason), '') IS NULL AND
      NULLIF(TRIM(ReturnReason), '') is null
group by 
   c.channelId,
   c.channelname,
   c.channelscope
order by total_revenue desc;


-- =======================================================================
-- Question 3: Which regions contribute the most revenue and orders?
-- =======================================================================

select
  c.region,
  round(sum(d.NetSales), 2) as total_revenue,
  count(d.salesId) as total_order,
  sum(d.quantity) as total_unit_sold
from Sales_data d
join customer_details c
  on d.customerId = c.customerId
where nullif(trim(d.cancellationReason),'') is null
and nullif(trim(d.ReturnReason), '') is null
group by c.region
order by total_revenue desc;


-- ===============================================================
-- Question 4: Which product categories generate the most revenue?
-- ===============================================================

select
   p.category,
   round(sum(d.NetSales),2) as total_revenue
from product_details p
join sales_data d
on p.productId = d.productId
where nullif(trim(d.cancellationReason),'') is null
and nullif(trim(d.ReturnReason),'') is null
group by p.category
order by total_revenue desc;


-- ==================================================================
-- Question 5:Which product sub-categories generate the most revenue?
-- ==================================================================

select
    p.SubCategory,
    round(sum(d.NetSales),2) as total_revenue
from product_details p
join sales_data d
on p.productId = d.productId
where nullif(trim(d.cancellationReason),'') is null
and nullif(trim(d.ReturnReason), '') is null
group by p.subcategory
order by total_revenue desc;


-- ===============================================================================================================
-- Question 6:Which delivery partners handle the highest number of orders, and how does their sales value compare?
-- ===============================================================================================================

select 
    d.DeliveryPartnerID,
    d.PartnerName,
    Count(s.salesId) as total_order,
    round(sum(s.NetSales),2) as total_revenue
from Delivery_partner_data d
join Sales_data s
on d.deliveryPartnerId = s.deliveryPartnerId
where nullif(trim(s.CancellationReason),'') is null
and nullif(trim(s.ReturnReason),'') is null
group by D.deliveryPartnerID, D.partnerName
order by total_order desc;
