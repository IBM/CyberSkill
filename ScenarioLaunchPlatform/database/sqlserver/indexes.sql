/* ======================================================
   INDEXES
====================================================== */
-- Speed up lookups on tbl_crm_accounts by status
CREATE INDEX IX_tbl_crm_accounts_status ON dbo.tbl_crm_accounts (status);

-- Speed up search by email
CREATE INDEX IX_tbl_email_lists_email ON dbo.tbl_email_lists (email_address);

-- Speed up calls search by parent_id + date
CREATE INDEX IX_tbl_calls_parentid_date ON dbo.tbl_calls (parent_id, date_start);

-- Speed up bugs search by status + priority
CREATE INDEX IX_tbl_bugs_status_priority ON dbo.tbl_bugs (status, priority);
GO
