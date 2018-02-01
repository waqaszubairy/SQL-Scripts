



/**************************************************************************************************

Properties
==========
PROCEDURE NAME:		usp_Insert_New_Columns
DESCRIPTION:		This procedure inserts new columns to existing tables

					

Revision history
==============================================================================================
ChangeDate		Author		Version		Narrative
============	======		=======		======================================================
04-OCT-2017		WZ			REL12194	Drop Constraints
			
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
		@ConstraintName NVARCHAR(250)=''
		



DROP TABLE IF EXISTS #DropConstraints
CREATE TABLE #DropConstraints 
(
ID INT IDENTITY(1,1),
SchemaName NVARCHAR(50),
TableName NVARCHAR(200),
ColumnName NVARCHAR (200)

)


INSERT INTO #DropConstraints (SchemaName, TableName, ColumnName)
VALUES 
('Staging','G2_LegalPartyTaxResidency','Is871mTaxResidency'),
('Transform','DimLegalPartyTaxResidency_Delta','Is871mTaxResidency'),
('OLAP','DimLegalPartyTaxResidency','Is871mTaxResidency')


SELECT 
	@Counter = MIN(ID),
	@MaxCounter = MAX(ID)
FROM 
	#DropConstraints




	WHILE @Counter<=@MaxCounter
	BEGIN
		SELECT @SchemaName = SchemaName,
			   @TableName = TableName,
			   @ColumnName = ColumnName
		FROM 
			#DropConstraints
		WHERE 
			ID = @Counter

	SELECT
    @ConstraintName= default_constraints.name
	FROM 
    sys.all_columns
        INNER JOIN sys.tables 
			ON all_columns.object_id = tables.object_id
        INNER JOIN sys.schemas 
			ON tables.schema_id = schemas.schema_id
		INNER JOIN sys.default_constraints 
			ON all_columns.default_object_id = default_constraints.object_id
		WHERE 
			schemas.name = @SchemaName
			AND tables.name = @TableName
			AND all_columns.name = @ColumnName
	
	IF @ConstraintName<>''
		BEGIN
			SET @SQL = 'ALTER TABLE '+@SchemaName+'.'+@TableName+
							' DROP CONSTRAINT '+@ConstraintName
			EXEC (@SQL)
		END
		SET @Counter = @Counter+1
	END




