-- =========================================
-- BoAt Sales Data Analysis
-- File: 02_add_constraints.sql
-- Purpose: Add foreign key constraints
-- =========================================

-- 1. Customer Connection

ALTER TABLE Sales_Data
ADD CONSTRAINT fk_sales_customer
FOREIGN KEY (CustomerID)
REFERENCES Customer_Details(CustomerID);

-- 2. Product connection

ALTER TABLE Sales_Data
ADD CONSTRAINT fk_sales_product
FOREIGN KEY (ProductID)
REFERENCES Product_Details(ProductID);

-- 3. Sales Channel connection

ALTER TABLE Sales_Data
ADD CONSTRAINT fk_sales_channel
FOREIGN KEY (ChannelID)
REFERENCES Sales_Channel(ChannelID);

-- 4. Delivery Partner connection

ALTER TABLE Sales_Data
ADD CONSTRAINT fk_sales_delivery_partner
FOREIGN KEY (DeliveryPartnerID)
REFERENCES Delivery_Partner_Data(DeliveryPartnerID);
