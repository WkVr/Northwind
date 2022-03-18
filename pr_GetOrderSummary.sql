CREATE PROCEDURE pr_GetOrderSummary(
	@StartDate DATETIME,
	@EndDate DATETIME,
	@EmployeeID INT = NULL,
	@CustomerID VARCHAR(10) = NULL
)
AS
BEGIN

SET NOCOUNT ON;

SELECT DISTINCT
	e.EmployeeFullName,
	s.CompanyName [Shipper Company Name],
	c.CompanyName [Customer Company Name],
	COUNT(o.OrderID) NumberOfOrders,
	MAX(o.OrderDate) [Date],
	o.Freight [TotalFreightCost],
	Count(od.ProductID)  [NumberOfDifferentProducts],
	SUM(od.UnitPrice * od.Quantity) [TotalOrderValue]
FROM Orders o
	INNER JOIN [Order Details] od
		ON o.OrderID = od.OrderID
	INNER JOIN (SELECT CONCAT(TitleOfCourtesy, ' ', FirstName, ' ', LastName) EmployeeFullName, EmployeeId FROM Employees) e 
		ON o.EmployeeID = e.EmployeeID
	INNER JOIN Shippers s 
		ON o.ShipVia = s.ShipperID
	INNER JOIN Customers c
		ON o.CustomerID = c.CustomerID
WHERE 
	o.OrderDate BETWEEN @StartDate AND @EndDate
	AND e.EmployeeID = CASE WHEN @EmployeeID IS NULL THEN e.EmployeeID ELSE @EmployeeID END
	AND c.CustomerID = CASE WHEN @CustomerID IS NULL THEN c.CustomerID ELSE @CustomerID END
GROUP BY
	DAY(o.OrderDate),
	e.EmployeeID, e.EmployeeFullName,
	c.CustomerID, c.CompanyName,
	s.ShipperID, s.CompanyName,
	o.Freight

END