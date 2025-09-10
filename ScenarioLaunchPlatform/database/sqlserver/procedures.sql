/* ======================================================
   STORED PROCEDURES
====================================================== */
-- Add a new CRM Account quickly
CREATE PROCEDURE dbo.uspAddCrmAccount
    @Name NVARCHAR(150),
    @Website NVARCHAR(255),
    @Phone NVARCHAR(100),
    @StatusId INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.tbl_crm_accounts (id,name,date_entered,date_modified,modified_user_id,created_by,deleted,assigned_user_id,account_type,industry,website,phone_office,status)
    VALUES (NEWID(),@Name,GETDATE(),GETDATE(),'system','system',0,'system','Customer','Technology',@Website,@Phone,@StatusId);
END;
GO

-- Get all calls for a given account
CREATE PROCEDURE dbo.uspGetCallsByAccount
    @AccountId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.tbl_calls WHERE parent_id=@AccountId ORDER BY date_start DESC;
END;
GO



EXEC dbo.uspAddCrmAccount @Name='New Co', @Website='https://newco.com', @Phone='(123)456-7890', @StatusId=1;
EXEC dbo.uspGetCallsByAccount @AccountId='df61978a-f4cc-ff64-8de0-53e90f19a56a';
