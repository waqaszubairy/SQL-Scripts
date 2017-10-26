




DECLARE 
	@Counter INT = 0,
	@MaxCounter INT = 0,
	@TableName varchar(50),
	@Schema varchar(30);

DROP TABLE IF EXISTS #AllFactTables
CREATE TABLE #AllFactTables 
(
ID INT IDENTITY(1,1),
FactTableName NVARCHAR(250),
SchemaName NVARCHAR(250)
)

DROP TABLE IF EXISTS #BusMatrix
CREATE TABLE #BusMatrix
(
FactTableName NVARCHAR(250),
DimensionTableName NVARCHAR(250),
DimensionSK	NVARCHAR(250)
)




INSERT INTO #AllFactTables (FactTableName,SchemaName)
SELECT t.name,s.name FROM sys.tables t
	INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
WHERE t.name LIKE 'Fact%'
	AND s.name = 'OLAP'



SELECT @Counter = MIN(ID), @MaxCounter = MAX(ID) FROM #AllFactTables


WHILE @Counter<=@MaxCounter
	BEGIN
		SELECT 
			@TableName = FactTableName,
			@Schema = SchemaName
		FROM 
			#AllFactTables WHERE ID = @Counter

			;WITH tab
				AS
				(
				SELECT object_id, name AS TableName 
				FROM sys.tables
				WHERE name = @TableName and schema_id = schema_id(@schema)
				)
			INSERT INTO #BusMatrix (FactTableName, DimensionTableName, DimensionSK)
			SELECT 
				@TableName AS FactTable,
				DimSK.DimensionTable AS DimensionTable,
				c.name AS DimensionSK
			FROM 
				sys.columns c
					Inner join tab t 
						ON c.object_id = t.object_id
					Inner join
						(
						select t.name as DimensionTable, c.name AS DimensionSK from sys.tables t
							inner join sys.columns c on c.object_id =t.object_id
						where c.is_identity=1
						and t.name like 'Dim%'
						and t.name not like '%REL%'
						)DimSK
						ON Dimsk.DimensionSK = c.name


			WHERE
				c.name like '%Key%'   --Whatever foreign key pattern is used in naming the dimension table keys


	SET @Counter=@Counter+1
END

SELECT * FROM #BusMatrix





