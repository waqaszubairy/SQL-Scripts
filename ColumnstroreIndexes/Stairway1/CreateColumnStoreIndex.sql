

DROP INDEX NCI_FactOnlineSales ON dbo.FactOnlineSales
GO
CREATE NONCLUSTERED COLUMNSTORE INDEX NCI_FactOnlineSales
ON dbo.FactOnlineSales
   (OnlineSalesKey,
    DateKey,
    StoreKey,
    ProductKey,
    PromotionKey,
    CurrencyKey,
    CustomerKey,
    SalesOrderNumber,
    SalesOrderLineNumber,
    SalesQuantity,
    SalesAmount,
    ReturnQuantity,
    ReturnAmount,
    DiscountQuantity,
    DiscountAmount,
    TotalCost,
    UnitCost,
    UnitPrice,
    ETLLoadID,
    LoadDate,
    UpdateDate);