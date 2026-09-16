Create Database DecodeLabs_EDA;
Go
USE DecodeLabs_EDA;
Go

--- Create the main Table
Create Table ecommerce_orders (
OrderID Varchar(20) Primary KEY,
OrderDate Date Not Null,
CustomerID Varchar(20) Not Null,
Product Varchar(50) Not Null,
Quantity Varchar(50) Not Null,
UnitPrice Decimal(10,2) Not Null,
TotalPrice Decimal(10,2) Not Null,
PaymentMethod Decimal(10,2) Not Null,
Ckean_CouponCode Varchar(20) Not Null
);
Go

IF OBJECT_ID('ecommerce_orders', 'U') IS NOT NULL DROP TABLE ecommerce_orders;
GO

Create Table ecommerce_orders (
OrderID Varchar(20) Primary KEY,
OrderDate Date Not Null,
CustomerID Varchar(20) Not Null,
Product Varchar(50) Not Null,
Quantity Varchar(50) Not Null,
UnitPrice Decimal(10,2) Not Null,
TotalPrice Decimal(10,2) Not Null,
PaymentMethod Varchar(50) Not Null,
Clean_CouponCode Varchar(20) Not Null
);
Go

Bulk Insert ecommerce_orders
From 'C:\Users\USER\Desktop\Order Sheet.csv'
With (
FirstRow = 2,
FieldTerminator = ',',
RowTerminator = '\n',
TabLock
);
Go

----Getting My Mean, Median and count
Select Distinct
Count(OrderID) Over() as Total_Count,
Round(Avg(Cast(TotalPrice As Float)) Over(), 2) As TotalPrice_Mean,
Percentile_Cont(0.5) Within Group(Order By Cast(TotalPrice As Float)) Over() As TotalPrice_Median,
Round(Avg(Cast(UnitPrice As Float)) Over(), 2) As UnitPrice_Mean,
Percentile_Cont(0.5) Within Group(Order By Cast(UnitPrice As Float)) Over() As UnitPrice_Median,
Round(Avg(Cast(Quantity As Float)) Over(), 2) As Quantity_Mean,
Percentile_Cont(0.5) Within Group( Order By Cast(Quantity As Int)) Over() As Quantity_Median,
Min(Cast(TotalPrice As Float)) Over() As TotalPrice_Min,
Max(Cast(TotalPrice As Float)) Over() As TotalPrice_Max,
Round(Sum(Cast(TotalPrice As Float)) Over(), 2) As Gross_Revenue
From ecommerce_Orders;
Go

----To Identify Top performing Products by Total revenue, Total Quantity sold and average transaction value
Select
Product,
Count(OrderID) As Order_Volume,
Sum(Cast(Quantity As INT)) As Total_Quantity_Sold,
Round(Sum(Cast(TotalPrice As float)), 2) As Total_Revenue,
Round(Avg(Cast(TotalPrice As float)), 2) As Avg_Order_Value
From ecommerce_Orders
Group By Product
Order By Total_Revenue DESC;
Go

-----Analysis by Payment Method
Select
PaymentMethod,
Count(OrderID) As Total_Transaction,
Round(Sum(Cast(TotalPrice As Float)), 2) As Total_Revenue,
Round((Sum(Cast(TotalPrice As Float)) * 100) / Sum(Sum(Cast(TotalPrice As Float))) Over(), 2) As Revenue_Percentage
From ecommerce_orders
Group By PaymentMethod
Order By Total_Revenue Desc;
Go


----Monthly Sales and revenue Trend
Select
Year(Cast(OrderDate As Date)) As Order_Year,
Month(Cast(OrderDate As Date)) As Order_Month,
DateName(Month, Cast(OrderDate As Date)) As Month_Name,
Count(OrderID) As Total_Orders,
Round(Sum(Cast(TotalPrice As Float)), 2) As Monthly_Revenue
From ecommerce_orders
Group BY 
Year(Cast(OrderDate As Date)),
Month(Cast(OrderDate As Date)),
DateName(Month, Cast(OrderDate As Date))
Order By Order_Year Asc, Order_Month Asc;
Go


---- Coupon Usage Trend
Select
IsNull(Clean_CouponCode, 'No Coupon') As Coupon_Code,
Count(OrderID) As Usage_Count,
Round(Sum(Cast(TotalPrice As Float)), 2) As Total_Revenue,
Round(Avg(Cast(TotalPrice As Float)), 2) As Avg_Order_Value
From ecommerce_orders
Group By Clean_CouponCode
Order By Usage_Count Desc;
Go