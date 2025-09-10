
/* ======================================================
   SEED DATA
====================================================== */
INSERT INTO dbo.tbl_crm_accounts_status (status) VALUES 
('lead'),('opportunity'),('customer/won'),('archive');

INSERT INTO dbo.tbl_crm_accounts
(id,name,date_entered,date_modified,modified_user_id,created_by,description,deleted,assigned_user_id,account_type,industry,
annual_revenue,phone_fax,billing_address_street,billing_address_city,billing_address_state,billing_address_postalcode,
billing_address_country,rating,phone_office,phone_alternate,website,ownership,employees,ticker_symbol,shipping_address_street,
shipping_address_city,shipping_address_state,shipping_address_postalcode,shipping_address_country,parent_id,sic_code,campaign_id,status)
VALUES
('df61978a-f4cc-ff64-8de0-53e90f19a56a','B.H. Edwards Inc','2024-09-22 03:11:33','2024-09-24 03:11:33','seed_will_id','1',NULL,0,'seed_max_id','Customer','Technology',NULL,NULL,'1715 Scott Dr','Alabama','CA','14882','USA',NULL,'(847) 706-6877',NULL,'www.devim.edu',NULL,NULL,NULL,'1715 Scott Dr','Alabama','CA','14882','USA',NULL,NULL,NULL,1);

INSERT INTO dbo.tbl_calls
(id,name,date_entered,date_modified,modified_user_id,created_by,description,deleted,assigned_user_id,duration_hours,duration_minutes,
date_start,date_end,parent_type,status,direction,parent_id,reminder_time,outlook_id)
VALUES
('e854b40d-414e-6c8d-d2b7-53e90f7b0f77','Left a message',DATEADD(DAY,-2,GETDATE()),GETDATE(),'1','1',NULL,0,'seed_max_id',0,30,'2014-12-28 09:30:00','2014-12-28 10:00:00','Accounts','Planned','Outbound','df61978a-f4cc-ff64-8de0-53e90f19a56a',-1,NULL);

INSERT INTO dbo.tbl_product VALUES ('d67f8d9d','Detergent','Keep the clothes cleaner with this detergent',4.80,10);

INSERT INTO dbo.tbl_email_lists VALUES ('d67f8d9d-7c28-00df-47f1-53e90f54066f','jim@securecrm.com','JIM@SECURECRM.COM',0,DATEADD(DAY,-2,GETDATE()));

INSERT INTO dbo.tbl_marketing_template VALUES ('53e90f54066f','Free Detergent with new technology','Keep the clothes cleaner with this detergent');

INSERT INTO dbo.tbl_marketing_campaign (email_id,template_id,campaign_date)
VALUES ('d67f8d9d-7c28-00df-47f1-53e90f54066f','53e90f54066f',DATEADD(DAY,10,GETDATE()));

INSERT INTO dbo.tbl_bugs
(id,name,date_entered,date_modified,modified_user_id,created_by,description,deleted,assigned_user_id,bug_number,type,status,priority,
resolution,work_log,found_in_release,fixed_in_release,source,product_category)
VALUES
('e4f7505c-0a0e-f582-f406-53e90f8a5637','Error occurs while running count query',DATEADD(DAY,-2,GETDATE()),GETDATE(),'1','1',NULL,0,'seed_max_id',1,NULL,'Assigned','Medium',NULL,NULL,NULL,NULL,NULL,NULL);
GO