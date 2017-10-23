USE TestDB



--Data masking
CREATE TABLE MyTable
  ( MySSN VARCHAR (10) MASKED WITH (FUNCTION = 'default()') DEFAULT ('0000000000' )
 , MyName VARCHAR (200) DEFAULT ( ' ')
 , MyEmail VARCHAR (250) DEFAULT ( '')
 , MyInt int
)
GO
INSERT dbo. MyTable
 ( MySSN , MyName, MyEmail , MyInt)
VALUES
 ( '1234567890', 'Steve Jones', 'SomeSteve@SomeDomain.com', 10 )


 SELECT * FROM MyTable


--Email Masking
ALTER TABLE MyTable
	ALTER COLUMN MyEmail VARCHAR(250) MASKED WITH (FUNCTION='email()') 