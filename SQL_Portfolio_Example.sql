/*
	What are the top 10 selling products for the year 2014
	by Quantity ?
*/

select top 10
	Product.Name,
	YEAR(SalesOrderDetail.ModifiedDate) as 'Year',
	SUM(OrderQty) as 'TotalQuantitySold'
from Sales.SalesOrderDetail

left join Production.Product on 
SalesOrderDetail.ProductID=Product.ProductID

where YEAR(SalesOrderDetail.ModifiedDate)=2012

group by Product.Name,YEAR(SalesOrderDetail.ModifiedDate)
order by YEAR(SalesOrderDetail.ModifiedDate),TotalQuantitySold desc


/*
	What are the top 10 selling products for the year 2014
	by Revenue ?
*/

select top 10
	Product.Name,
	YEAR(SalesOrderDetail.ModifiedDate) as 'Year',
	CAST(SUM(LineTotal) AS int)  as 'Revenue'
from Sales.SalesOrderDetail

left join Production.Product on 
SalesOrderDetail.ProductID=Product.ProductID

where YEAR(SalesOrderDetail.ModifiedDate)=2012

group by Product.Name,YEAR(SalesOrderDetail.ModifiedDate)
order by YEAR(SalesOrderDetail.ModifiedDate),Revenue desc

/*
	What are the Total Sales in a specifc time frame?
	lets say between 2013-06-01 and 2013-06-30
*/
select 
	SUM(SubTotal) as TotalSales
from Sales.SalesOrderHeader
where OrderDate >= '2013-06-01' and OrderDate <= '2013-06-30'

/*
	Who are the top spending customers?
*/

select top 10 
	c.CustomerID,
	SUM(od.LineTotal) AS TotalSpent
from Sales.SalesOrderHeader soh

left join Sales.Customer c ON 
soh.CustomerID = c.CustomerID

left join Sales.SalesOrderDetail od ON 
soh.SalesOrderID = od.SalesOrderID

group by c.CustomerID
order by TotalSpent desc;

/*
	What is the customer distribution by country?
*/

SELECT 
	sp.CountryRegionCode,
	count(*) as CustomerCount
FROM [AdventureWorks2017].[Sales].[Customer]
  
inner join Person.StateProvince sp on
Customer.TerritoryID=sp.TerritoryID

group by sp.CountryRegionCode
order by CustomerCount desc

/*
	What is the inventory level for each product?
*/

SELECT 
	p.ProductID
    ,p.Name as ProductName
	,SUM(pi.Quantity) as TotalQuantity
FROM [AdventureWorks2017].[Production].[Product] p

inner join Production.ProductInventory pi on
p.ProductID=pi.ProductID

group by p.ProductID,p.Name
order by TotalQuantity desc

/*
	What are the products that we are running low on stock ?
*/

SELECT 
	p.ProductID
    ,p.Name as ProductName
	,SUM(pi.Quantity) as TotalQuantity
FROM [AdventureWorks2017].[Production].[Product] p

inner join Production.ProductInventory pi on
p.ProductID=pi.ProductID

group by p.ProductID,p.Name
having SUM(pi.Quantity) < 75
order by TotalQuantity desc

/*
	What is the average order value  ?
*/

select 
	AVG(TotalDue) as AvgOrderValue 
from Sales.SalesOrderHeader

/*
	How many orders were placed within a particular time frame?
*/

select 
	Count(*) as TotalOrders
from Sales.SalesOrderHeader

where OrderDate>='2014-02-01' and OrderDate<='2014-02-06'

/*
	What is the avg shipping duration for orders  ?
*/

select
	AVG(DATEDIFF(DAY,OrderDate,ShipDate)) as ShippingDuration
from Sales.SalesOrderHeader
