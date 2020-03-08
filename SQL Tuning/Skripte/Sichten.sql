use Northwind;
GO

select * from KundeProdKat;


SELECT dbo.Customers.CompanyName, dbo.Products.ProductNamel, dbo.Categories.CategoryName
FROM     dbo.Customers INNER JOIN
                  dbo.Orders ON dbo.Customers.CustomerID = dbo.Orders.CustomerID INNER JOIN
                  dbo.[Order Details] ON dbo.Orders.OrderID = dbo.[Order Details].OrderID INNER JOIN
                  dbo.Products ON dbo.[Order Details].ProductID = dbo.Products.ProductID INNER JOIN
                  dbo.Categories ON dbo.Products.CategoryID = dbo.Categories.CategoryID

--was ist schneller : Sicht oder die Originalabfrage?

--keine ;-)
--Warum sichten???  Sparen von Code, Recyclbar
--sichten verhalten sich wie tabellen..!
--SEL, INS, UP, DEL ..hmm brauchbar
--Rechte
select * from employees

