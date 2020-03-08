IF OBJECT_ID('dbo.t1') IS NOT NULL
  DROP TABLE dbo.t1 ;
 
CREATE TABLE dbo.tx
  (
    i INT ,
    t TEXT ,
    c1 INT DEFAULT CHECKSUM(NEWID()) ,
    c2 INT DEFAULT CHECKSUM(NEWID())
  ) ;
 
INSERT  INTO dbo.tx
        ( i ,
          t
        )
        SELECT  n ,
                REPLICATE('X', 200 + ( CHECKSUM(NEWID()) % 10 ))
        FROM    dbo.GetNums(1000000) ;



set statistics time  on
SELECT ln, COUNT(1) cnt FROM
    (SELECT LEN(CAST(t AS NVARCHAR(MAX))) ln FROM dbo.tx)  X GROUP BY ln  option (maxdop 1);

