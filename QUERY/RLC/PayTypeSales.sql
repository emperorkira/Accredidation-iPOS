SELECT 
[TrnSales].[Id] AS [SalesId], 
FORMAT(SUM(IIF( ([TrnCollection].[IsCancelled] = 0 OR [TrnCollection].[IsCancelled] IS NULL) AND ([TrnCollectionLine].[Amount] > 0 OR [TrnCollectionLine].[Amount] IS NOT NULL) AND ([TrnCollectionLine].[PayTypeId] = [MstPayType].[Id] AND [MstPayType].[PayType] = 'Cash'), [TrnCollectionLine].[Amount], 0)), '0.00000') AS [TotalCashSales], 
FORMAT(SUM(IIF( ([TrnCollection].[IsCancelled] = 0 OR [TrnCollection].[IsCancelled] IS NULL) AND ([TrnCollectionLine].[Amount] > 0 OR [TrnCollectionLine].[Amount] IS NOT NULL) AND ([TrnCollectionLine].[PayTypeId] = [MstPayType].[Id] AND [MstPayType].[PayType] = 'Gift Certificate'), [TrnCollectionLine].[Amount], 0)), '0.00000')  AS [TotalGiftCertificateSales],
FORMAT(SUM(IIF( ([TrnCollection].[IsCancelled] = 0 OR [TrnCollection].[IsCancelled] IS NULL) AND ([TrnCollectionLine].[Amount] > 0 OR [TrnCollectionLine].[Amount] IS NOT NULL) AND ([TrnCollectionLine].[PayTypeId] = [MstPayType].[Id] AND [MstPayType].[PayType] = 'Gcash' OR [MstPayType].[PayType] = 'PayMaya' OR [MstPayType].[PayType] = 'GrabPay' OR [MstPayType].[PayType] = 'FoodPanda') , [TrnCollectionLine].[Amount], 0)), '0.00000')  AS [TotalOnlineSales],
FORMAT(SUM(IIF( ([TrnCollection].[IsCancelled] = 0 OR [TrnCollection].[IsCancelled] IS NULL) AND ([TrnCollectionLine].[Amount] > 0 OR [TrnCollectionLine].[Amount] IS NOT NULL) AND ([TrnCollectionLine].[PayTypeId] = [MstPayType].[Id] AND [MstPayType].[PayType] = 'Mastercard'), [TrnCollectionLine].[Amount], 0)), '0.00000') AS [TotalMastercardSales],
FORMAT(SUM(IIF( ([TrnCollection].[IsCancelled] = 0 OR [TrnCollection].[IsCancelled] IS NULL) AND ([TrnCollectionLine].[Amount] > 0 OR [TrnCollectionLine].[Amount] IS NOT NULL) AND ([TrnCollectionLine].[PayTypeId] = [MstPayType].[Id] AND [MstPayType].[PayType] = 'Visa'), [TrnCollectionLine].[Amount], 0)), '0.00000') AS [TotalVisaSales],
FORMAT(SUM(IIF( ([TrnCollection].[IsCancelled] = 0 OR [TrnCollection].[IsCancelled] IS NULL) AND ([TrnCollectionLine].[Amount] > 0 OR [TrnCollectionLine].[Amount] IS NOT NULL) AND ([TrnCollectionLine].[PayTypeId] = [MstPayType].[Id] AND [MstPayType].[PayType] = 'Diners'), [TrnCollectionLine].[Amount], 0)),'0.00000') AS [TotalDinersSales], 
FORMAT(SUM(IIF( ([TrnCollection].[IsCancelled] = 0 OR [TrnCollection].[IsCancelled] IS NULL) AND ([TrnCollectionLine].[Amount] > 0 OR [TrnCollectionLine].[Amount] IS NOT NULL) AND ([TrnCollectionLine].[PayTypeId] = [MstPayType].[Id] AND [MstPayType].[PayType] = 'JCB'), [TrnCollectionLine].[Amount], 0)), '0.00000') AS [TotalJCBSales], 
FORMAT(SUM(IIF( ([TrnCollection].[IsCancelled] = 0 OR [TrnCollection].[IsCancelled] IS NULL) AND ([TrnCollectionLine].[Amount] > 0 OR [TrnCollectionLine].[Amount] IS NOT NULL) AND ([TrnCollectionLine].[PayTypeId] = [MstPayType].[Id] AND [MstPayType].[PayType] = 'Credit Card'), [TrnCollectionLine].[Amount], 0)), '0.00000') AS [TotalCreditCardSales], 
FORMAT(IIF( ([TrnCollection].[IsCancelled] = 0 OR [TrnCollection].[IsCancelled] IS NULL) AND ([TrnCollectionLine].[PayTypeId] = [MstPayType].[Id] AND [MstPayType].[PayType] = 'Credit Card'), [TotalTax].[TotalTaxAmount], 0), '0.00000') AS [TotalCreditCardTax], 
FORMAT(SUM(IIF( ([TrnCollection].[IsCancelled] = 0 OR [TrnCollection].[IsCancelled] IS NULL) AND ([TrnCollectionLine].[Amount] > 0 OR [TrnCollectionLine].[Amount] IS NOT NULL) AND ([TrnCollectionLine].[PayTypeId] = [MstPayType].[Id] AND [MstPayType].[PayType] <> 'Credit Card' AND  [MstPayType].[PayType] <> 'Cash' AND  [MstPayType].[PayType] <> 'Gift Certificate' ), [TrnCollectionLine].[Amount], 0)), '0.00000') AS [TotalOtherTenderSales], 
[MstTerminal].[Terminal] AS [Terminal Number], 
[SysCurrent].[SMPOSSerialNumber] AS [Serial Number] 
INTO [TmpPayTypeSales]
FROM (((((TrnSales LEFT JOIN TrnCollection ON [TrnSales].[Id] = [TrnCollection].[SalesId]) 
LEFT JOIN TrnCollectionLine ON [TrnCollectionLine].[CollectionId] = [TrnCollection].[Id]) 
LEFT JOIN (SELECT [SalesId], SUM([TaxAmount]) AS [TotalTaxAmount] FROM [TrnSalesLine] GROUP BY [SalesId])  AS [TotalTax] ON [TrnSales].[Id] = TotalTax.[SalesId]) 
LEFT JOIN [SysCurrent] ON [TrnSales].[TerminalId] = [SysCurrent].[TerminalId]) 
LEFT JOIN [MstPayType] ON [MstPayType].Id = [TrnCollectionLine].[PayTypeId]) 
LEFT JOIN [MstTerminal] ON [SysCurrent].[TerminalId] = [MstTerminal].[Id]
WHERE
    [TrnSales].[IsLocked] 
    AND DAY([TrnSales].EntryDateTime) = DAY(Date()) 
    AND MONTH([TrnSales].EntryDateTime) = MONTH(Date()) 
    AND YEAR([TrnSales].[EntryDateTime]) = YEAR(Date())
GROUP BY [TrnSales].[Id], [MstTerminal].[Terminal], [SysCurrent].[SMPOSSerialNumber],
FORMAT(IIF( ([TrnCollection].[IsCancelled] = 0 OR [TrnCollection].[IsCancelled] IS NULL) AND ([TrnCollectionLine].[PayTypeId] = [MstPayType].[Id] AND [MstPayType].[PayType] = 'Credit Card'), [TotalTax].[TotalTaxAmount], 0), '0.00000')

HAVING SUM(IIF(([TrnCollectionLine].[Amount] > 0 OR [TrnCollectionLine].[Amount] IS NOT NULL), [TrnCollectionLine].[Amount], 0))

















SELECT 
    TrnSales.Id AS SalesId, 
    FORMAT(SUM(TotalTax.TotalTaxAmount), '0.00000') AS TotalCreditCardTax, 
    MstTerminal.Terminal AS [Terminal Number], 
    SysCurrent.SMPOSSerialNumber AS [Serial Number]
INTO TmpPayTypeSales
FROM 
    (((((TrnSales 
    LEFT JOIN TrnCollection ON TrnSales.Id = TrnCollection.SalesId) 
    LEFT JOIN TrnCollectionLine ON TrnCollection.Id = TrnCollectionLine.CollectionId) 
    LEFT JOIN 
        (SELECT 
            TrnSalesLine.SalesId, 
            SUM(TrnSalesLine.TaxAmount) AS TotalTaxAmount
        FROM 
            ((TrnSalesLine 
            LEFT JOIN TrnCollection ON TrnSalesLine.SalesId = TrnCollection.SalesId)
            LEFT JOIN TrnCollectionLine ON TrnCollection.Id = TrnCollectionLine.CollectionId)
            LEFT JOIN MstPayType ON TrnCollectionLine.PayTypeId = MstPayType.Id
        WHERE 
            MstPayType.PayType = 3
        GROUP BY 
            TrnSalesLine.SalesId
        ) AS TotalTax 
    ON TrnSales.Id = TotalTax.SalesId) 
    LEFT JOIN SysCurrent ON TrnSales.TerminalId = SysCurrent.TerminalId) 
    LEFT JOIN MstPayType ON MstPayType.Id = TrnCollectionLine.PayTypeId) 
    LEFT JOIN MstTerminal ON SysCurrent.TerminalId = MstTerminal.Id
GROUP BY 
    TrnSales.Id, 
    MstTerminal.Terminal, 
    SysCurrent.SMPOSSerialNumber
HAVING 
    SUM(IIF(TrnCollectionLine.Amount > 0 OR TrnCollectionLine.Amount IS NOT NULL, TrnCollectionLine.Amount, 0)) > 0;
