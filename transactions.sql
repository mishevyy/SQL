
/*----------------------------Управление транзакциями-----------------------------------------------*/
-- Транзакция является единственной единицей работы. Если транзакция выполнена успешно, все модификации данных, 
-- сделанные в течение транзакции, принимаются и становятся постоянной частью базы данных. 
-- Если в результате выполнения транзакции происходят ошибки и должна быть произведена отмена или выполнен откат, 
-- все модификации данных будут отменены.

/*--------------------------------------------------------------------------------------------------*/
/*----------------------------BEGIN TRANSACTION-----------------------------------------------------*/

-- BEGIN TRANSACTION -- Отмечает начальную точку явной локальной транзакции
-- BEGIN { TRAN | TRANSACTION }   
--     [ { transaction_name | @tran_name_variable }  
--       [ WITH MARK [ 'description' ] ]  
--     ]  
-- [ ; ]  

-- Использование явной транзакции
BEGIN TRANSACTION;  
DELETE FROM HumanResources.JobCandidate  
    WHERE JobCandidateID = 13;  
COMMIT; 

-- Откат транзакции
CREATE TABLE ValueTable (id INT);  
BEGIN TRANSACTION;  
       INSERT INTO ValueTable VALUES(1);  
       INSERT INTO ValueTable VALUES(2);  
ROLLBACK; 

-- Присвоение транзакции имени
DECLARE @TranName VARCHAR(20);  
SELECT @TranName = 'MyTransaction';  
  
BEGIN TRANSACTION @TranName;  
USE AdventureWorks2012;  
DELETE FROM AdventureWorks2012.HumanResources.JobCandidate  
    WHERE JobCandidateID = 13;  
  
COMMIT TRANSACTION @TranName;  
GO  

-- Пометка транзакции
BEGIN TRANSACTION CandidateDelete  
    WITH MARK N'Deleting a Job Candidate';  
GO  
USE AdventureWorks2012;  
GO  
DELETE FROM AdventureWorks2012.HumanResources.JobCandidate  
    WHERE JobCandidateID = 13;  
GO  
COMMIT TRANSACTION CandidateDelete;  
GO  


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------COMMIT TRANSACTION----------------------------------------------------*/

-- COMMIT TRANSACTION
-- Отмечает успешное завершение явной или неявной транзакции. Если значение @@TRANCOUNT равно 1, 
-- то инструкция COMMIT TRANSACTION делает все изменения, произведенные с начала транзакции, 
-- постоянной частью базы данных, освобождает ресурсы транзакции и уменьшает значение параметра @@TRANCOUNT до 0. 
-- Если значение @@TRANCOUNT больше 1, инструкция COMMIT TRANSACTION уменьшает 
-- значение @@TRANCOUNT только на 1 и оставляет транзакцию активной.
-- COMMIT [ { TRAN | TRANSACTION }  [ transaction_name | @tran_name_variable ] ] [ WITH ( DELAYED_DURABILITY = { OFF | ON } ) ]  
-- [ ; ] 
BEGIN TRANSACTION;   
DELETE FROM HumanResources.JobCandidate  
    WHERE JobCandidateID = 13;   
COMMIT TRANSACTION; 


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------ROLLBACK TRANSACTION--------------------------------------------------*/

-- ROLLBACK TRANSACTION - отмена транзакции
-- ROLLBACK { TRAN | TRANSACTION }   
--      [ transaction_name | @tran_name_variable  
--      | savepoint_name | @savepoint_variable ]   
-- [ ; ]

USE tempdb;  
GO  
CREATE TABLE ValueTable ([value] INT);  
GO  
  
DECLARE @TransactionName VARCHAR(20) = 'Transaction1';  
  
BEGIN TRAN @TransactionName  
       INSERT INTO ValueTable VALUES(1), (2);  
ROLLBACK TRAN @TransactionName;  
  
INSERT INTO ValueTable VALUES(3),(4);  
  
SELECT [value] FROM ValueTable;  
  
DROP TABLE ValueTable; 


/*--------------------------------------------------------------------------------------------------*/
/*----------------------------SAVE TRANSACTION------------------------------------------------------*/

-- SAVE TRANSACTION - Устанавливает точку сохранения внутри транзакции.
-- SAVE { TRAN | TRANSACTION } { savepoint_name | @savepoint_variable }  
-- [ ; ]
USE AdventureWorks2012;  
GO  
IF EXISTS (SELECT name FROM sys.objects  
           WHERE name = N'SaveTranExample')  
    DROP PROCEDURE SaveTranExample;  
GO  
CREATE PROCEDURE SaveTranExample  
    @InputCandidateID INT  
AS  
    -- Detect whether the procedure was called  
    -- from an active transaction and save  
    -- that for later use.  
    -- In the procedure, @TranCounter = 0  
    -- means there was no active transaction  
    -- and the procedure started one.  
    -- @TranCounter > 0 means an active  
    -- transaction was started before the   
    -- procedure was called.  
    DECLARE @TranCounter INT;  
    SET @TranCounter = @@TRANCOUNT;  
    IF @TranCounter > 0  
        -- Procedure called when there is  
        -- an active transaction.  
        -- Create a savepoint to be able  
        -- to roll back only the work done  
        -- in the procedure if there is an  
        -- error.  
        SAVE TRANSACTION ProcedureSave;  
    ELSE  
        -- Procedure must start its own  
        -- transaction.  
        BEGIN TRANSACTION;  
    -- Modify database.  
    BEGIN TRY  
        DELETE HumanResources.JobCandidate  
            WHERE JobCandidateID = @InputCandidateID;  
        -- Get here if no errors; must commit  
        -- any transaction started in the  
        -- procedure, but not commit a transaction  
        -- started before the transaction was called.  
        IF @TranCounter = 0  
            -- @TranCounter = 0 means no transaction was  
            -- started before the procedure was called.  
            -- The procedure must commit the transaction  
            -- it started.  
            COMMIT TRANSACTION;  
    END TRY  
    BEGIN CATCH  
        -- An error occurred; must determine  
        -- which type of rollback will roll  
        -- back only the work done in the  
        -- procedure.  
        IF @TranCounter = 0  
            -- Transaction started in procedure.  
            -- Roll back complete transaction.  
            ROLLBACK TRANSACTION;  
        ELSE  
            -- Transaction started before procedure  
            -- called, do not roll back modifications  
            -- made before the procedure was called.  
            IF XACT_STATE() <> -1  
                -- If the transaction is still valid, just  
                -- roll back to the savepoint set at the  
                -- start of the stored procedure.  
                ROLLBACK TRANSACTION ProcedureSave;  
                -- If the transaction is uncommitable, a  
                -- rollback to the savepoint is not allowed  
                -- because the savepoint rollback writes to  
                -- the log. Just return to the caller, which  
                -- should roll back the outer transaction.  
  
        -- After the appropriate rollback, echo error  
        -- information to the caller.  
        DECLARE @ErrorMessage NVARCHAR(4000);  
        DECLARE @ErrorSeverity INT;  
        DECLARE @ErrorState INT;  
  
        SELECT @ErrorMessage = ERROR_MESSAGE();  
        SELECT @ErrorSeverity = ERROR_SEVERITY();  
        SELECT @ErrorState = ERROR_STATE();  
  
        RAISERROR (@ErrorMessage, -- Message text.  
                   @ErrorSeverity, -- Severity.  
                   @ErrorState -- State.  
                   );  
    END CATCH  
GO    