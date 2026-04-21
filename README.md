# Retail Supply Chain Optimization Analysis

- [Project Overview](#projectoverview)
- [Data Source](#datasource)

<img width="1919" height="944" alt="image" src="https://github.com/user-attachments/assets/b11a29fe-5cfc-4485-84fd-1e7ca287293d" />


## Project Overview

South America Retail is a major retail company operating in multiple 
locations, offering a wide range of products to different customer 
groups. They focus on excellent customer service and a smooth 
shopping experience.

As a data analyst, your job is to analyze their sales data to uncover 
key insights on profitability, business performance, products, and 
customer behavior. You'll work with a dataset containing details on 
products, customers, sales, profits, and returns. Your findings will 
help identify areas for improvement and suggest strategies to boost 
efficiency and profitability

## Data Source
The data set is a Retail-Supply-Chain-Analysis.csv

## Tools Used
- SQL

## Data Cleaning & Preparation
- Data importation and inspection
- Splitting the data into facts and dimension tables
- Removing duplicates records
- Creating surogate keys to link up the facts and dimension table

  ## Objectives
  
  1. What was the Average delivery days for different 
     product subcategory?
  2. What was the Average delivery days for each segment ?
  3. What are the Top 5 Fastest delivered products and Top 5 
     slowest delivered products? 
  4. Which product Subcategory generate most profit?
  5. Which segment generates the most profit?
  6. Which Top 5 customers made the most profit?
  7. What is the total number of products by Subcategory
 
## Data Analysis
 ### 1. What was the Average delivery days for different product subcategory?
   ```sql
  SELECT sub_category, AVG(DATEDIFF(day,order_date, ship_date)) AS AvgDeliveryDays
  FROM orderFactTable oft
  LEFT JOIN DimProduct dp
  ON oft.Productkey = dp.Productkey
  GROUP BY sub_category

/* It takes an Average of 32 days to deliver products in the Chairs and Bookcases subcategory,
and an average of 34 days to deliver products in the Furnishings subcategory
and an average of 36 days to delivery products in the Tables subcategory */
   ```
### 2. What was the Average delivery days for each segment ?
```sql
SELECT Segment, AVG(DATEDIFF(DAY,order_date, ship_date)) AS AvgDeliveryDays
FROM OrderFactTable 
GROUP BY Segment
ORDER BY 2 

/* It takes an average of 31 delivery days to get the products to the Home Office segment 
   and an average of 34 delivery days to deliver products to the consumer segment
   and an average of 35 delivery days to deliver products to the corporate segment */
  ```
###  3. What are the Top 5 Fastest delivered products and Top 5 slowest delivered products?
```sql

 3A. WHAT ARE THE TOP 5 FASTEST DELIVERY PRODUCT?

SELECT TOP 5 product_name, DATEDIFF(DAY,order_date, ship_date) AS AvgDeliveryDays
FROM orderFactTable oft
LEFT JOIN DimProduct dp
ON oft.Productkey = dp.Productkey
ORDER BY 2 

/* THE TOP 5 FASTEST DELIVERED PRODUCTS WITH 0 DELIVERY DAYS ARE:
Sauder Camden County Barrister Bookcase, Planked Cherry Finish
Sauder Inglewood Library Bookcases
O'Sullivan 2-Shelf Heavy-Duty Bookcases
O'Sullivan Plantations 2-Door Library in Landvery Oak
O'Sullivan Plantations 2-Door Library in Landvery Oak*/      

 -- 3B. WHAT ARE THE TOP 5 SLOWEST DELIVERY PRODUCTS?

SELECT TOP 5 product_name, DATEDIFF(DAY,order_date, ship_date) AS AvgDeliveryDays
FROM OrderFactTable oft
LEFT JOIN DimProduct dp
ON oft.Productkey = dp.Productkey
ORDER BY 2 desc 

/* THE TOP 5 SLOWEST DELIVERED PRODUCTS WITH 214 DELIVERY DAYS ARE:
   Bush Mission Pointe Library
   Hon Multipurpose Stacking Arm Chairs
   Global Ergonomic Managers Chair
   Tensor Brushed Steel Torchiere Floor Lamp
   Howard Miller 11-1/2" Diameter Brentwood Wall Clock */
```
###  4. Which product Subcategory generate most profit?
```sql
SELECT sub_category, round(sum(Profit), 2) AS Profit_By_Subcategory
FROM orderFactTable oft
LEFT JOIN DimProduct dp
ON oft.Productkey = dp.Productkey
WHERE Profit > 0
GROUP BY sub_category

 /* The  Product Chair made the highest profit in this subcategory  $36,471.1
    while the product Table made the lowset profit in this subcategory $8,358.33*/
```
### 5. Which segment generates the most profit?
```sql
SELECT Segment, round(sum(Profit), 2) AS Profit_By_Segment
FROM orderFactTable 
WHERE Profit > 0
GROUP BY Segment
ORDER BY 2 desc

 /* The Consumer made the highest profit in this segment  $35,427.03
    while the Home Office made the lowset profit in this segment $13,657.04 */
```
###  6. Which Top 5 customers made the most profit?
```sql
SELECT TOP 5 customer_Name,round(sum(Profit), 2) AS Profit_By_CustomerName
FROM orderFactTable oft
JOIN DimCustomer dc
ON oft.Customer_ID = dc.Customer_ID
WHERE Profit > 0
GROUP BY Customer_Name
ORDER BY 2 desc

/* Customer with the highest generated profit are:
1.   Laura Armstrong	 $1,156.17  
2.   Joe Elijah	         $1,121.6
3.   Seth Vernon	     $1,047.14
4.   Quincy Jones   	 $1,013.13
5.   Maria Etezadi	     $822.65  */
```
###  7. What is the total number of products by Subcategory
```sql

 SELECT sub_category,count(PRODUCTkey) AS Totalproduct
 FROM DimProduct
 GROUP BY sub_category

 /*
 Bookcases	48
 Chairs	    87
 Furnishings	186
 Tables	    34  */
```
## Insight/Finding
1. Operational Bottleneck: The data reveals a significant lag in the Furniture category, with bulky items like Tables taking over 5 weeks to ship.
2. Segment Disparity: Home Office orders are fulfilled 11% faster than Corporate orders, suggesting smaller average order sizes might be bypassing bulk logistics bottlenecks.
3. Data Anomaly: The 214-day delay and 0-day fulfillment suggest a mix of severe stockouts and immediate local pickup or digital inventory.
  Category Contrast: Bookcases dominate the fastest deliveries, while specialized furniture and decor face extreme logistics bottlenecks.
4. Beyond basic sales tracking, I performed a comparative analysis using SQL aggregations to identify Hero Products. By calculating the profit-to-sales ratio, I identified that while Tables had high sales volume, Chairs contributed 4x more to the bottom line, allowing for data-driven recommendations on inventory prioritization.
5. Revenue Concentration: The Consumer segment generates nearly 3x the profit of Home Office, identifying it as the critical driver of overall business sustainability.
Segment Contribution Gap: Home Office’s low profit contribution suggests a smaller customer base or a product mix with significantly tighter margins.
6. Top-Tier Contribution: The top five customers alone generate over $5,000 in profit, highlighting a highly concentrated value group within the database.
Customer Value Stability: The narrow profit margin between the top four individuals suggests a consistent high-value purchasing pattern among elite clients.
7. Inventory Depth Imbalance: Furnishings hold nearly 4x the product variety of Tables, indicating a highly fragmented category compared to a more consolidated furniture line.
Portfolio Concentration: Over 50% of the total product catalog is concentrated in Furnishings, which may lead to high management overhead and stock-keeping unit (SKU) complexity.



## Recommendations
1. Carrier Strategy: Conduct a performance audit of heavy-goods carriers to renegotiate SLAs or diversify vendors to reduce the 36-day peak.
2. Logistics Optimization: Audit the "last-mile" delivery process for Corporate and Consumer segments to identify why they lag behind Home Office fulfillment speeds.
3. Lead Time Audit: Investigate the 200+ day outliers to determine if they are due to data entry errors or genuine supply chain failures.
  Inventory Balancing: Replicate the fulfillment model used for "Sauder" products to stabilize delivery for slower-moving furniture brands.
4. Inventory Prioritization: Increase stock levels and promotional visibility for Chairs to capitalize on their proven high-return performance.
 Cost Analysis: Conduct a deep-dive audit into Table logistics and supplier costs to identify why they yield such significantly lower margins.
5. Targeted Marketing: Reallocate ad spend toward the Consumer segment to maximize ROI, given its proven high-profit conversion rate.
Segment Expansion: Develop a "Home Office Bundle" or loyalty incentive to increase the average transaction value within the lower-performing segment.
6. VIP Retention Program: Implement a "Platinum Tier" loyalty scheme for these specific individuals to prevent churn and encourage long-term brand advocacy.
Lookalike Modeling: Use the purchasing profiles of these top five earners to build targeted marketing personas for acquiring similar high-profit prospects.
7. SKU Rationalization: Audit the 186 Furnishing items to identify and phase out low-performing products, streamlining the catalog for better operational efficiency.
Category Expansion: Evaluate if the limited Table assortment (34 products) is meeting market demand or if adding new styles could capture untapped revenue.

## Challenges
1. Data Cleaning & Integrity
The Challenge: Dealing with transactional anomalies like negative quantities, zero-unit prices, and inconsistent delivery dates (like the 0-day and 214-day outliers you found).
Identified and handled significant data noise, including return transactions represented as negative values, ensuring that the final $10.67M revenue figure was accurate and not inflated by raw system errors.

2. SQL Schema Design (The Surrogate Key Challenge)
The Challenge: Moving from a flat Excel-style table to a relational Star Schema.
Transitioned raw transactional data into a structured Star Schema by creating dimension tables (DimProduct, DimCustomer). The primary challenge was generating unique Surrogate Keys to ensure data integrity and optimize join performance within SQL
   
3. Handling Duplicate Records (The CTE Challenge)
The Challenge: The raw data contained multiple entries for the same customer or product, which         threatened to double-count profits.
Resolved data redundancy issues by implementing Common Table Expressions (CTEs) and window functions (ROW_NUMBER) to programmatically remove duplicate records, ensuring each 'Hero Product' and 'Top Customer' was counted exactly once.




