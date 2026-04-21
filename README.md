# Retail Supply Chain Optimization Analysis

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
  SELECT Segment, round(sum(Profit), 2) as Profit_By_Segment
FROM orderFactTable 
WHERE Profit > 0
GROUP BY Segment
ORDER BY 2 desc

 /* The Consumer made the highest profit in this segment  $35,427.03
    while the Home Office made the lowset profit in this segment $13,657.04 */
```
###  6. Which Top 5 customers made the most profit?
```sql
SELECT TOP 5 customer_Name,round(sum(Profit), 2) as Profit_By_CustomerName
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

 SELECT sub_category,count(PRODUCTkey) as Totalproduct
 FROM DimProduct
 GROUP BY sub_category

 /*
 Bookcases	48
 Chairs	    87
 Furnishings	186
 Tables	    34  */
```
## Insight/Finding

## Recommendations

## Challenges



