

/**************************************************************************************************

Properties
==========
PROCEDURE NAME:		usp_Insert_New_Columns
DESCRIPTION:		This procedure inserts new columns to existing tables

					

Revision history
==============================================================================================
ChangeDate		Author		Version		Narrative
============	======		=======		======================================================
02-OCT-2017		WZ			REL12194	Created
			
**************************************************************************************************/


DECLARE @CNT INT = 0,
		@TableName NVARCHAR(250),
		@SchemaName NVARCHAR(100),
		@ColumnName NVARCHAR(250),
		@DataType_Length NVARCHAR(500),
		@Nullability NVARCHAR(100),
		@SQL NVARCHAR(MAX),
		@Counter INT,
		@MaxCounter INT,
		@Operation NVARCHAR(10) = 'Add'



DROP TABLE IF EXISTS #ColumnToAdd 
CREATE TABLE #ColumnToAdd 
(
ID INT IDENTITY(1,1),
SchemaName NVARCHAR(50),
TableName NVARCHAR(200),
ColumnName NVARCHAR (200),
DataType_Length NVARCHAR(500),
Nullability NVARCHAR(100)
)


INSERT INTO #ColumnToAdd (SchemaName, TableName, ColumnName,DataType_Length,Nullability)
VALUES 
('OLAP','DimClient','AffiliateBtag_Demo','NVARCHAR(250)','NOT NULL DEFAULT ''_NA'''),
('Transform','DimClient_Delta','AffiliateBtag_Demo','NVARCHAR(250)','NULL DEFAULT ''_NA'''),
('Transform','Intraday_DimClient_Delta','AffiliateBtag_Demo','NVARCHAR(250)','NULL DEFAULT ''_NA''')



SELECT 
	@Counter = MIN(ID),
	@MaxCounter = MAX(ID)
FROM 
	#ColumnToAdd


WHILE @Counter<=@MaxCounter
	BEGIN
		SELECT @SchemaName = SchemaName,
			   @TableName = TableName,
			   @ColumnName = ColumnName,
			   @DataType_Length = DataType_Length,
			   @Nullability = Nullability
		FROM 
			#ColumnToAdd
		WHERE 
			ID = @Counter

        SELECT @CNT=COUNT(1)
		FROM sys.tables t
			INNER JOIN sys.columns c ON c.OBJECT_ID = t.object_id
			INNER JOIN sys.schemas s ON s.schema_id = t.schema_id
		WHERE 
			t.name = @TableName
			AND s.name = @SchemaName
			AND c.name  = @ColumnName

		IF @CNT=0 AND @Operation = 'Add'
			BEGIN
				SET @SQL = 
					'ALTER TABLE '+@SchemaName+'.'+@TableName
					+ ' ADD '+@ColumnName+' '+@DataType_Length+' '+@Nullability
				EXEC (@SQL)
					
			END
		
		IF @CNT>0 AND @Operation = 'Drop'
			BEGIN
				SET @SQL = 
					'ALTER TABLE '+@SchemaName+'.'+@TableName
					+ ' DROP COLUMN '+@ColumnName
				EXEC (@SQL)
					
		END
		SET @Counter = @Counter+1
		SET @CNT=0 
	END

