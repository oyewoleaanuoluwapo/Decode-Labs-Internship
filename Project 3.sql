Create Database DecodeLabs_Project3;
Go
Use DecodeLabs_Project3;
Go

If Object_ID('ecommerce_orders', 'u') Is Not Null
Drop Table ecommerce_orders;
Go

Create Table ecommerce_orders (
OrderID Varchar(20) Primary Key,
OrderDate Date Not Null,
CustomerID Varchar(20) Not Null,
Product Varchar(50) Not Null,
Quantity Int Not Null,
UnitPrice Decimal(10,2) Not Null,
TotalPrice Decimal(10,2) Not Null,
PaymentMethod Varchar(20) Null,
Clean_CouponCode Varchar(20) Null
);
Go


Bulk Insert ecommerce_orders
From 'C:\Users\USER\Desktop\DecodeLabs Internship\Order Sheet.csv'
With (
FirstRow = 2,
FieldTerminator =',',
RowTerminator = '0x0a',
TabLock
);
Go

Select Count(*) As Total_Records From ecommerce_orders;
Go
---Revenue and Volume Analysis
Select
Product,
Count(OrderID) As TotalOrders,
Sum(Quantity) As TotalUnitsSold,
Sum(TotalPrice) As TotalRevenue,
Round(Avg(UnitPrice), 2) As AvgUnitPrice
From ecommerce_orders
Group By Product
Order By TotalRevenue DESC;
Go

----High Performing Categories
Select
Product,
Sum(TotalPrice) As TotalRevenue,
Count(Distinct CustomerID) As UniqueBuyers
From ecommerce_orders
Group By Product
Having Sum(TotalPrice) >175000
Order By TotalRevenue DESC;
Go

----Percentage Revenue Contribution
With CategorySales As (
Select
Product,
Sum(TotalPrice) As Revenue
From ecommerce_orders
Group By Product
)
Select
Product,
Revenue,
Round((Revenue * 100.00) / Sum(Revenue) Over(), 2) As PercentageContribution
From CategorySales
Order By PercentageContribution DESC;
Go