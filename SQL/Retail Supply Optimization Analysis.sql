--1. To create DimCustomers Table

SELECT * INTO DimCustomer
FROM
    (SELECT Customer_ID, Customer_Name FROM Retail_Supply ) AS DimC
    select * from DimCustomer

  --To show and remove duplicate

With CTE_DimL
AS
 
 ( select  Customer_ID, Customer_Name, ROW_NUMBER() over(partition by  Customer_ID, Customer_Name 
    order by customer_ID asc)  as Row_num
    from DimCustomer)

delete from cte_diml
where row_num > 1

-- 2.To create DimLocation Table

SELECT * INTO DimLocation
FROM
    (SELECT Postal_code,country, state, city, region  FROM Retail_Supply ) AS DimL

    select * from DimLocation

--To show and remove duplicate

With CTE_Dimll
AS
 
 (SELECT Postal_code,country, state, city, region , ROW_NUMBER() over(partition by Postal_code,country, state, city, region  
    order by Postal_code asc)  as Row_num
    from DimLocation)

delete from cte_dimll
where row_num > 1

--3. To create DimProduct Table

SELECT * INTO DimProduct
FROM
    (SELECT Product_id, product_name, category, sub_category FROM Retail_Supply ) AS DimP
   
select * from Retail_Supply
--To show and remove duplicate

With CTE_DimP
AS
 
 ( select  Product_id, product_name, category, sub_category, ROW_NUMBER() over(partition by  Product_id,
   product_name, category, sub_category 
    order by Product_id asc)  as Row_num
    from DimProduct)

delete from cte_dimp
where row_num > 1

--4. To create Fact Table

SELECT * INTO orderFactTable
FROM
    (SELECT Order_ID,Customer_ID,Segment, Postal_Code, Product_id, Retail_Sales_People,Order_Date,
    Ship_Mode, Ship_Date,  Returned, Sales, Quantity,Discount,Profit 
    fROM Retail_Supply ) as facttable
--To show and remove duplicate

With facttable
AS
(SELECT order_ID,Customer_ID,Segment, Postal_Code, Product_id, Retail_Sales_People,Order_Date,
    Ship_Mode, Ship_Date,  Returned, Sales, Quantity,Discount,Profit  ,
    ROW_NUMBER () over (partition by 
    Order_ID,Customer_ID,Segment, Postal_Code, Product_id, Retail_Sales_People,Order_Date,
    Ship_Mode, Ship_Date,  Returned, Sales, Quantity,Discount,Profit  
    order by order_id) as Row_num
    from orderFactTable)

delete from  facttable
where row_num > 1
 
     select * from DimProduct
     where Product_ID =   'FUR-FU-10004091'

       -- To add a surogate key called product key to serve as a unique identifier for the table DimProduct

    Alter Table DimProduct
    add Productkey int identity (1,1) primary key;

   -- Add the surogate key to OrderfactTable

    Alter table orderfacttable
    add Productkey int;

    update orderFactTable 
    set Productkey  = DimProduct.Productkey
    from orderFactTable 
    Join dimProduct   
   on  orderFactTable.product_id =dimproduct.product_id

   -- To drop product_id which is no longer a unique identifier in both DimProuct & OrderFactTable

   Alter Table dimproduct 
   drop column product_id;
   
   Alter Table orderfacttable 
   drop column product_id;


 --  EXPLORATORY ANALYSIS

 --1. WHAT WAS THE AVERAGE DELIVERY DAY FOR DIFFERENT PRODUCT SUB_CATEGORY
   

Select sub_category, Avg(DATEDIFF(day,order_date, ship_date)) as AvgDeliveryDays
from orderFactTable oft
Left join DimProduct dp
on oft.Productkey = dp.Productkey
Group by sub_category

/* It takes an Average of 32 days to deliver products in the Chairs and Bookcases subcategory,
and an average of 34 days to deliver products in the Furnishings subcategory
and an average of 36 days to delivery products in the Tables subcategory */   

-- 2. WHAT WAS THE AVERAGE DELIVERY DAYS FOR EACH SEGMENT?

SELECT Segment, Avg(DATEDIFF(day,order_date, ship_date)) as AvgDeliveryDays
from orderFactTable 
Group BY Segment
order by 2 

/* It takes an average of 31 delivery days to get the products to the Home Office segment 
   and an average of 34 delivery days to deliver products to the consumer segment
   and an average of 35 delivery days to deliver products to the corporate segment */ 
   
   -- 3A. WHAT ARE THE TOP 5 FASTEST DELIVERY PRODUCT?
   select * from DimProduct
   
    select * from orderFactTable

 select top 5 product_name, DATEDIFF(day,order_date, ship_date) as AvgDeliveryDays
from orderFactTable oft
Left join DimProduct dp
on oft.Productkey = dp.Productkey
order by 2 

/* THE TOP 5 FASTEST DELIVERED PRODUCTS WITH 0 DELIVERY DAYS ARE:
Sauder Camden County Barrister Bookcase, Planked Cherry Finish
Sauder Inglewood Library Bookcases
O'Sullivan 2-Shelf Heavy-Duty Bookcases
O'Sullivan Plantations 2-Door Library in Landvery Oak
O'Sullivan Plantations 2-Door Library in Landvery Oak*/      

 -- 3B. WHAT ARE THE TOP 5 SLOWEST DELIVERY PRODUCTS ?

Select top 5 product_name, DATEDIFF(day,order_date, ship_date) as AvgDeliveryDays
From orderFactTable oft
Left join DimProduct dp
On oft.Productkey = dp.Productkey
Order by 2 desc 

/* THE TOP 5 SLOWEST DELIVERED PRODUCTS WITH 214 DELIVERY DAYS ARE:
   Bush Mission Pointe Library
   Hon Multipurpose Stacking Arm Chairs
   Global Ergonomic Managers Chair
   Tensor Brushed Steel Torchiere Floor Lamp
   Howard Miller 11-1/2" Diameter Brentwood Wall Clock */

   -- 4. WHAT PRODUCT SUBCATEGORY GENERATED MOST PROFIT?

Select sub_category, round(sum(Profit), 2) as Profit_By_Subcategory
From orderFactTable oft
Left join DimProduct dp
On oft.Productkey = dp.Productkey
where Profit > 0
group by sub_category
 /* The  Product Chair made the highest profit in this subcategory  $36,471.1
    while the product Table made the lowset profit in this subcategory $8,358.33*/

   -- 5. WHAT PRODUCT SEGMENT GENERATED MOST PROFIT?

Select Segment, round(sum(Profit), 2) as Profit_By_Segment
From orderFactTable 
where Profit > 0
group by Segment
order by 2 desc

 /* The Consumer made the highest profit in this segment  $35,427.03
    while the Home Office made the lowset profit in this segment $13,657.04 */

    -- 6. WHICH TOP 5 CUSTOMERS GENERATED MOST PROFIT?

Select top 5 customer_Name,round(sum(Profit), 2) as Profit_By_CustomerName
From orderFactTable oft
join DimCustomer dc
on oft.Customer_ID = dc.Customer_ID
where Profit > 0
group by Customer_Name
order by 2 desc

/* Customer with the highest generated profit are:
1.   Laura Armstrong	 $1,156.17  
2.   Joe Elijah	         $1,121.6
3.   Seth Vernon	     $1,047.14
4.   Quincy Jones   	 $1,013.13
5.   Maria Etezadi	     $822.65  */

-- 7. WHAT IS THE TOTAL NUMBER OF PRODUCT BY SUBCATEGORY

   SELECT sub_category,count(PRODUCTkey) as Totalproduct
   from DimProduct
   group by sub_category

   /*
   Bookcases	48
   Chairs	    87
   Furnishings	186
   Tables	    34  */
      
      
      
     
   