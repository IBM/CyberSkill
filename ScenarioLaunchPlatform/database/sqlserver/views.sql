/* ======================================================
   VIEWS
====================================================== */
-- All accounts with their status text
CREATE VIEW dbo.vwAccountsWithStatus AS
SELECT a.id,
       a.name,
       s.status AS status_name,
       a.date_entered,
       a.website,
       a.phone_office
FROM dbo.tbl_crm_accounts a
JOIN dbo.tbl_crm_accounts_status s ON a.status = s.id;

-- All marketing campaigns with email address and template subject
CREATE VIEW dbo.vwMarketingCampaignDetail AS
SELECT c.id,
       e.email_address,
       t.subject AS template_subject,
       c.campaign_date
FROM dbo.tbl_marketing_campaign c
JOIN dbo.tbl_email_lists e ON c.email_id = e.id
JOIN dbo.tbl_marketing_template t ON c.template_id = t.id;
GO
