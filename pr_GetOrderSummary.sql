CREATE PROCEDURE pr_GetOrderSummary(
	@StartDate DATETIME,
	@EndDate DATETIME,
	@EmployeeID INT = NULL,
	@CustomerID VARCHAR(10) = NULL
)
AS
BEGIN

SET NOCOUNT ON;

END