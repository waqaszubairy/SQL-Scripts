WITH ContosoProducts
AS (SELECT *
    FROM   dbo.DimProduct
    WHERE  BrandName                    = 'Contoso')
SELECT     cp.ProductName,
           dd.CalendarQuarter,
           COUNT(fos.SalesOrderNumber) AS NumOrders,
           SUM(fos.SalesQuantity)      AS QuantitySold
FROM       dbo.FactOnlineSales         AS fos
INNER JOIN dbo.DimDate                 AS dd
      ON   dd.Datekey                   = fos.DateKey
INNER JOIN ContosoProducts             AS cp
      ON   cp.ProductKey                = fos.ProductKey
GROUP BY   cp.ProductName,
           dd.CalendarQuarter
ORDER BY   cp.ProductName,
           dd.CalendarQuarter;