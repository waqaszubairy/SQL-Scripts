


--Checking as a sepaerate user
CREATE USER mytest WITHOUT LOGIN
GRANT SELECT ON mytable TO mytest


EXECUTE AS USER = 'mytest'
GO
SELECT * FROM MyTable
