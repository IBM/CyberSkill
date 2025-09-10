/* ======================================================
   AUDIT TABLE
====================================================== */
IF OBJECT_ID('dbo.tbl_audit_log') IS NOT NULL
    DROP TABLE dbo.tbl_audit_log;
GO

CREATE TABLE dbo.tbl_audit_log (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(128),
    ActionType NVARCHAR(10),
    RecordID NVARCHAR(255),
    ChangedBy NVARCHAR(128) DEFAULT SUSER_SNAME(),
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO


/* ======================================================
   TRIGGER ON tbl_crm_accounts
====================================================== */
IF OBJECT_ID('dbo.trg_tbl_crm_accounts_audit') IS NOT NULL
    DROP TRIGGER dbo.trg_tbl_crm_accounts_audit;
GO

CREATE TRIGGER dbo.trg_tbl_crm_accounts_audit
ON dbo.tbl_crm_accounts
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert log for inserted records
    INSERT INTO dbo.tbl_audit_log (TableName, ActionType, RecordID)
    SELECT 'tbl_crm_accounts','INSERT', CAST(id AS NVARCHAR(255))
    FROM inserted
    WHERE NOT EXISTS (SELECT 1 FROM deleted WHERE deleted.id = inserted.id);

    -- Insert log for updated records
    INSERT INTO dbo.tbl_audit_log (TableName, ActionType, RecordID)
    SELECT 'tbl_crm_accounts','UPDATE', CAST(id AS NVARCHAR(255))
    FROM inserted
    INNER JOIN deleted ON inserted.id = deleted.id;

    -- Insert log for deleted records
    INSERT INTO dbo.tbl_audit_log (TableName, ActionType, RecordID)
    SELECT 'tbl_crm_accounts','DELETE', CAST(id AS NVARCHAR(255))
    FROM deleted
    WHERE NOT EXISTS (SELECT 1 FROM inserted WHERE inserted.id = deleted.id);
END;
GO


/* ======================================================
   TRIGGER TO UPDATE date_modified
====================================================== */
IF OBJECT_ID('dbo.trg_tbl_crm_accounts_upd_date') IS NOT NULL
    DROP TRIGGER dbo.trg_tbl_crm_accounts_upd_date;
GO

CREATE TRIGGER dbo.trg_tbl_crm_accounts_upd_date
ON dbo.tbl_crm_accounts
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE a
    SET date_modified = GETDATE()
    FROM dbo.tbl_crm_accounts a
    INNER JOIN inserted i ON a.id = i.id;
END;
GO


/* ======================================================
   TRIGGER TO SOFT DELETE
====================================================== */
IF OBJECT_ID('dbo.trg_tbl_bugs_softdelete') IS NOT NULL
    DROP TRIGGER dbo.trg_tbl_bugs_softdelete;
GO

CREATE TRIGGER dbo.trg_tbl_bugs_softdelete
ON dbo.tbl_bugs
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE b
    SET deleted = 1
    FROM dbo.tbl_bugs b
    INNER JOIN deleted d ON b.id = d.id;
END;
GO


