IF OBJECT_ID('tempdb..#Test') IS NOT NULL	
	DROP TABLE #Test
GO

CREATE TABLE #Test (
	RowID INT PRIMARY KEY,
	RowValue NVARCHAR(100)
)

BEGIN TRAN
	PRINT '#A - @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR(100))
	INSERT #Test VALUES(1, 'One');
	
	BEGIN TRAN
		PRINT '#B - @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR(100))
		INSERT #Test VALUES(2, 'Two');
	COMMIT TRAN 

	PRINT '#C - @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR(100))
	INSERT #Test VALUES(3, 'Three');

	-- ROLLBACK TRAN

COMMIT TRAN 
PRINT '#D - @@TRANCOUNT: ' + CAST(@@TRANCOUNT AS NVARCHAR(100))

SELECT * FROM #Test;


-------------------------------------------------
SET XACT_ABORT OFF; 

IF OBJECT_ID('tempdb..#Test') IS NOT NULL	
	DROP TABLE #Test
GO

CREATE TABLE #Test (
	RowID INT PRIMARY KEY,
	RowValue NVARCHAR(100)
)


BEGIN TRY
	BEGIN TRAN

	INSERT #Test VALUES (1, 'One')
	INSERT #Test VALUES (2, 'Two')
	--INSERT #Test VALUES (1, 'Three')

	PRINT 'Committing...'
	COMMIT TRAN
END TRY
BEGIN CATCH
	PRINT 'Rolling back...'
	ROLLBACK TRAN; 
	THROW
	-- Do any logging here
END CATCH
GO
SELECT * FROM #Test
GO