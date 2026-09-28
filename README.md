# 🎧 BoAt Sales Data Analysis — SQL Project

## 📌 Project Overview

This project analyzes **BoAt sales data using MySQL** to uncover meaningful business insights related to sales performance, customers, products, sales channels, regions, cancellations, and revenue trends.

The project focuses on transforming raw sales data into structured business insights using **SQL**, covering basic analysis through advanced and complex analytical queries.

The analysis includes **25 business questions**, organized into four difficulty levels:

* Level 1 — Basic Analysis
* Level 2 — Intermediate Analysis
* Level 3 — Advanced Analysis
* Level 4 — Complex Analysis

The project is designed as a portfolio project for demonstrating practical **SQL and Data Analyst skills**.

---

## 🎯 Business Objectives

The main objectives of this project are:

* Analyze overall sales performance.
* Identify high-performing sales channels.
* Compare regional sales performance.
* Analyze category and subcategory revenue.
* Evaluate delivery partner performance.
* Understand monthly revenue trends.
* Identify top-performing products.
* Analyze customer purchasing behavior.
* Compare one-time and repeat customers.
* Calculate Average Order Value (AOV).
* Identify significant month-over-month growth and decline.
* Analyze high-value products.
* Compare category performance across channels and regions.
* Analyze customer revenue contribution.
* Understand cancellation patterns.
* Identify products with unusually high cancellation rates.
* Find the highest-revenue combination of region, channel, and category.

---

## 📂 Dataset

The dataset used in this project is the **BoAt Sales Analytics Dataset** available on Kaggle.

The dataset contains multiple CSV files representing different parts of the sales ecosystem.

### Tables Used

| Table                   | Description                                    |
| ----------------------- | ---------------------------------------------- |
| `Customer_Details`      | Customer-related information                   |
| `Delivery_Partner_Data` | Delivery partner information                   |
| `Product_Details`       | Product and product category information       |
| `Sales_Channel`         | Sales channel information                      |
| `Sales_Data`            | Sales transactions and order-level information |

---

## 🗄️ Database

The project was implemented using:

**Database:** MySQL
**Version:** MySQL 8.0.45

The tables were imported into MySQL and connected using primary-key and foreign-key relationships.

---

## 🔗 Table Relationships

The project uses a relational database structure where sales transactions connect with customer, product, channel, and delivery partner information.

Key identifiers include:

* `CustomerID`
* `SalesID`
* `ProductID`
* `DeliveryPartnerID`
* `ChannelID`

These relationships allow the analysis to combine transactional data with supporting dimension data.

---

## 🛠️ Tools & Technologies

* **MySQL 8.0.45**
* **SQL**
* **GitHub**
* **CSV Dataset**

### SQL Concepts Used

The project demonstrates practical use of:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* Aggregate Functions
* `COUNT()`
* `SUM()`
* `AVG()`
* `ROUND()`
* `CASE`
* `JOIN`
* `LEFT JOIN`
* Subqueries
* Common Table Expressions (CTEs)
* Window Functions
* `LAG()`
* `DENSE_RANK()`
* `NTILE()`
* `PERCENT_RANK()`
* `ROLLUP`
* `GROUPING()`
* Date Functions
* Conditional Aggregation
* Median-based analysis

---

# 📊 SQL Analysis

The analysis is divided into four levels according to query complexity.

---

# 🟢 Level 1 — Basic Analysis

File:

`sql/01_level_1_basic_analysis.sql`

### Q1. What are the overall sales performance metrics?

Analyzes:

* Total Revenue
* Total Orders
* Total Units Sold
* Average Order Value (AOV)

The analysis excludes both cancelled and returned transactions.

---

### Q2. Which sales channels generate the highest revenue?

Analyzes revenue, orders, and units sold across different sales channels.

This helps understand the contribution of different online and offline channels.

---

### Q3. Which regions generate the highest revenue?

Compares:

* Revenue
* Orders
* Units Sold

across customer regions.

---

### Q4. Which product categories generate the highest revenue?

Ranks product categories based on total revenue.

---

### Q5. Which product subcategories generate the highest revenue?

Analyzes revenue contribution at the subcategory level to identify the strongest product segments.

---

### Q6. Which delivery partners handle the highest number of orders and revenue?

Compares delivery partners using:

* Number of Orders
* Total Revenue

to understand delivery partner contribution.

---

# 🟡 Level 2 — Intermediate Analysis

File:

`sql/02_level_2_intermediate_analysis.sql`

### Q7. Which months have the highest and lowest sales, and how does revenue change month over month?

Analyzes monthly revenue and calculates:

* Previous Month Revenue
* Month-over-Month Revenue Change
* Month-over-Month Growth Percentage

This helps identify important revenue trends and fluctuations.

---

### Q8. What are the top 10 products by revenue?

Identifies the highest-revenue products and calculates their contribution to total revenue.

---

### Q9. What are the top 10 products by quantity sold?

Ranks products according to total units sold and compares their revenue contribution.

---

### Q10. Which customer segments generate the highest revenue?

Compares customer segments based on:

* Revenue
* Average Order Value

---

### Q11. How many customers are one-time customers versus repeat customers?

Customers are classified according to their number of orders:

* **One-time customers:** Customers with one order
* **Repeat customers:** Customers with more than one order

---

### Q12. How much revenue comes from repeat customers versus one-time customers?

Analyzes:

* Revenue from repeat customers
* Revenue from one-time customers
* Revenue share of each group

---

### Q13. Which sales channels have the highest Average Order Value?

Calculates AOV for each sales channel to compare the average value of transactions.

---

# 🟠 Level 3 — Advanced Analysis

File:

`sql/03_level_3_advanced_analysis.sql`

### Q14. Which months experienced significant revenue growth or decline?

Identifies months where month-over-month revenue changed by more than **±10%**.

This highlights significant positive and negative revenue movements.

---

### Q15. Which products fall into the second-highest revenue quartile and second-lowest quantity quartile?

Products are segmented using:

* Revenue quartiles
* Quantity-sold quartiles
* Revenue rank
* Quantity rank
* Revenue per unit

This helps identify products that generate relatively strong revenue while being positioned in a relatively lower unit-sales segment.

---

### Q16. What is the top-revenue product within each product category?

Uses window functions to rank products within each category and identify the highest-revenue product for every category.

---

### Q17. Which product categories showed the strongest revenue growth from 2023 to 2024?

Compares category revenue between 2023 and 2024 and calculates the change in revenue.

---

### Q18. What is the top-revenue product category within each sales channel?

Identifies the highest-revenue product category for every sales channel.

---

### Q19. What is the top-revenue product category within each customer region?

Ranks product categories within each region to identify the category generating the highest revenue in every region.

---

# 🔴 Level 4 — Complex Analysis

File:

`sql/04_level_4_complex_analysis.sql`

### Q20. How did each sales channel's revenue contribution change from 2023 to 2024?

Compares channel-level revenue contribution across 2023 and 2024.

The analysis includes:

* Channel revenue
* Total yearly revenue
* Channel revenue percentage
* Year-over-year contribution change

---

### Q21. Who are the top 10 customers by revenue, and what percentage of total revenue do they contribute?

Identifies the highest-value customers based on revenue and calculates their contribution to total revenue.

---

### Q22. What is the cancellation rate overall and by sales channel?

Calculates:

* Total orders
* Cancelled orders
* Cancellation rate

for the overall business and individual sales channels.

---

### Q23. What are the major cancellation reasons?

Analyzes cancellation reasons and calculates their percentage contribution to total cancellations.

---

### Q24. Which products have unusually high cancellation rates relative to their sales volume?

A product is considered to have an unusually high cancellation rate when:

* Its cancellation rate is **above the median cancellation rate**, and
* Its sales volume is **above the median unit sales**

This helps identify products that have both meaningful sales volume and relatively high cancellation rates.

---

### Q25. Which region + sales channel + category combination generates the highest revenue?

Combines:

* Region
* Sales Channel
* Product Category

to identify the highest-revenue business combination.

---

# 📈 Key Business Insights

## 💰 Overall Sales Performance

After excluding both cancelled and returned transactions:

* **Total Revenue:** ₹4,008,431,423.32
* **Total Orders:** 913,820
* **Total Units Sold:** 1,026,587
* **Average Order Value:** ₹4,386.46

This provides the baseline for the project's active-order analysis.

---

## 🛒 Sales Channel Performance

The major revenue-generating channels include:

| Sales Channel                    |           Revenue |
| -------------------------------- | ----------------: |
| Amazon India Online              | ₹1,162,159,967.29 |
| Flipkart Online                  |   ₹961,227,838.57 |
| boAt Official Website Online     |   ₹530,215,097.71 |
| Croma Offline                    |   ₹423,686,314.22 |
| Local Multi-brand Retail Offline |            ₹356M+ |

Amazon India and Flipkart account for substantial portions of the analyzed sales, while the official website and offline channels also contribute significant revenue.

---

## 🌎 Regional Performance

Revenue by region:

| Region  |           Revenue |
| ------- | ----------------: |
| North   | ₹1,129,197,165.03 |
| West    | ₹1,041,101,313.00 |
| South   |   ₹981,693,058.70 |
| Central |   ₹474,163,998.45 |
| East    |   ₹382,275,888.14 |

The analysis shows meaningful differences in revenue contribution across regions.

---

## 🎧 Category Performance

The highest-revenue categories include:

| Category              |           Revenue |
| --------------------- | ----------------: |
| True Wireless Earbuds | ₹1,433,754,290.09 |
| Smart Watches         |   ₹541,724,758.89 |
| Soundbars             |   ₹538,905,299.88 |
| Wireless Speakers     |   ₹458,537,815.90 |
| Headphones            |   ₹243,262,952.49 |

True Wireless Earbuds represent the largest revenue-generating category in the active-order analysis.

---

## 📦 Subcategory Performance

The major subcategories by revenue include:

| Subcategory           |           Revenue |
| --------------------- | ----------------: |
| Airdopes              | ₹1,433,754,290.09 |
| Wave / Lunar / Ultima |   ₹541,724,758.89 |
| Soundbars             |   ₹538,905,299.88 |
| Stone                 |   ₹458,537,815.90 |
| Rockerz               |   ₹243,262,952.49 |
| Neckbands             |   ₹208,782,745.81 |
| Energyshroom          |   ₹167,761,753.76 |
| PartyPal              |   ₹135,145,984.28 |
| Gaming Rockerz        |   ₹108,742,087.11 |
| Cinehead              |    ₹72,917,265.18 |

---

# 🔍 Important Analysis Rules

To ensure that revenue and sales-performance metrics represent completed transactions, the analysis excludes both cancelled and returned orders.

The filtering condition used throughout the project is:

```sql
WHERE NULLIF(TRIM(CancellationReason), '') IS NULL
  AND NULLIF(TRIM(ReturnReason), '') IS NULL
```

This prevents cancelled and returned transactions from being included in active-order revenue and sales calculations.

---

# 🧠 Key SQL Skills Demonstrated

This project demonstrates practical Data Analyst SQL skills including:

### Basic SQL

* Filtering data
* Aggregation
* Sorting
* Grouping
* Conditional logic

### Intermediate SQL

* Multi-table joins
* Subqueries
* Date-based analysis
* Customer segmentation
* Conditional aggregation

### Advanced SQL

* CTEs
* Window functions
* Ranking
* `LAG()`
* `DENSE_RANK()`
* `NTILE()`
* Revenue contribution analysis
* Quartile-based segmentation

### Complex SQL

* Multi-level CTE pipelines
* Median-based analysis
* Multi-dimensional analysis
* Cancellation analysis
* Year-over-year comparison
* Revenue contribution analysis

---

# 📁 Project Structure

```text
boat-sales-sql-analysis/
│
├── dataset/
│   ├── Customer_Details.csv
│   ├── Delivery_Partner_Data.csv
│   ├── Product_Details.csv
│   ├── Sales_Channel.csv
│   └── Sales_Data.csv
│
├── sql/
│   ├── 01_level_1_basic_analysis.sql
│   ├── 02_level_2_intermediate_analysis.sql
│   ├── 03_level_3_advanced_analysis.sql
│   └── 04_level_4_complex_analysis.sql
│
├── insights/
│   └── key_insights.md
│
├── screenshots/
│
└── README.md
```

---

# 🚀 Future Improvements

The project can be further extended by adding:

* Python-based Exploratory Data Analysis
* Data cleaning and preprocessing with Python
* Power BI dashboard
* Interactive sales dashboards
* Advanced customer segmentation
* Product-level profitability analysis
* Sales forecasting
* Automated reporting
* Additional business KPIs

---

# 📌 Project Highlights

This project demonstrates how SQL can be used to move from raw transactional data to business-oriented analysis.

The project covers the complete analytical flow:

```text
Raw CSV Data
      ↓
MySQL Database
      ↓
Data Relationships
      ↓
SQL Analysis
      ↓
Business Metrics
      ↓
Customer / Product / Channel Analysis
      ↓
Business Insights
```

---

# 👤 Author

**Prashant Rawat**

Aspiring Data Analyst

**Skills:**
SQL | Python | Power BI | Excel | Data Analysis

---

## ⭐ Project Goal

The goal of this project is to demonstrate practical **SQL and Data Analyst skills** by analyzing real-world BoAt sales data using **MySQL**.

This project focuses on the **SQL analysis phase**, covering data exploration, business questions, customer analysis, product performance, sales channels, regional performance, revenue trends, and cancellation analysis.

In the future, this project can be extended further using **Python for exploratory data analysis and data preprocessing** and **Power BI for interactive dashboards and data visualization**.
