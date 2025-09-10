/* ======================================================
   USE YOUR DATABASE
====================================================== */
USE [CRM];
GO

/* ======================================================
   DROP / CREATE TABLES
====================================================== */
IF OBJECT_ID('dbo.tbl_crm_accounts_status', 'U') IS NOT NULL DROP TABLE dbo.tbl_crm_accounts_status;
CREATE TABLE dbo.tbl_crm_accounts_status (
    id INT IDENTITY(1,1) PRIMARY KEY,
    status NVARCHAR(64) NOT NULL DEFAULT ('')
);

IF OBJECT_ID('dbo.tbl_crm_accounts', 'U') IS NOT NULL DROP TABLE dbo.tbl_crm_accounts;
CREATE TABLE dbo.tbl_crm_accounts (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    name NVARCHAR(150) NULL,
    date_entered DATETIME NULL,
    date_modified DATETIME NULL,
    modified_user_id NVARCHAR(255) NULL,
    created_by NVARCHAR(255) NULL,
    description NVARCHAR(MAX) NULL,
    deleted BIT DEFAULT 0,
    assigned_user_id NVARCHAR(255) NULL,
    account_type NVARCHAR(50) NULL,
    industry NVARCHAR(50) NULL,
    annual_revenue NVARCHAR(100) NULL,
    phone_fax NVARCHAR(100) NULL,
    billing_address_street NVARCHAR(150) NULL,
    billing_address_city NVARCHAR(100) NULL,
    billing_address_state NVARCHAR(100) NULL,
    billing_address_postalcode NVARCHAR(20) NULL,
    billing_address_country NVARCHAR(255) NULL,
    rating NVARCHAR(100) NULL,
    phone_office NVARCHAR(100) NULL,
    phone_alternate NVARCHAR(100) NULL,
    website NVARCHAR(255) NULL,
    ownership NVARCHAR(100) NULL,
    employees NVARCHAR(10) NULL,
    ticker_symbol NVARCHAR(10) NULL,
    shipping_address_street NVARCHAR(150) NULL,
    shipping_address_city NVARCHAR(100) NULL,
    shipping_address_state NVARCHAR(100) NULL,
    shipping_address_postalcode NVARCHAR(20) NULL,
    shipping_address_country NVARCHAR(255) NULL,
    parent_id NVARCHAR(255) NULL,
    sic_code NVARCHAR(10) NULL,
    campaign_id NVARCHAR(255) NULL,
    status INT NOT NULL,
    FOREIGN KEY (status) REFERENCES dbo.tbl_crm_accounts_status (id)
);

IF OBJECT_ID('dbo.tbl_calls', 'U') IS NOT NULL DROP TABLE dbo.tbl_calls;
CREATE TABLE dbo.tbl_calls (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    name NVARCHAR(50) NULL,
    date_entered DATETIME NULL,
    date_modified DATETIME NULL,
    modified_user_id NVARCHAR(255) NULL,
    created_by NVARCHAR(255) NULL,
    description NVARCHAR(MAX) NULL,
    deleted BIT DEFAULT 0,
    assigned_user_id NVARCHAR(255) NULL,
    duration_hours INT NULL,
    duration_minutes INT NULL,
    date_start DATETIME NULL,
    date_end DATETIME NULL,
    parent_type NVARCHAR(255) NULL,
    status NVARCHAR(100) DEFAULT 'Planned',
    direction NVARCHAR(100) NULL,
    parent_id NVARCHAR(255) NULL,
    reminder_time INT DEFAULT -1,
    outlook_id NVARCHAR(255) NULL
);

IF OBJECT_ID('dbo.tbl_email_lists', 'U') IS NOT NULL DROP TABLE dbo.tbl_email_lists;
CREATE TABLE dbo.tbl_email_lists (
    id NVARCHAR(255) PRIMARY KEY,
    email_address NVARCHAR(150) UNIQUE NOT NULL,
    email_address_caps NVARCHAR(255) NULL,
    opt_out BIT DEFAULT 0,
    date_created DATETIME NULL
);

IF OBJECT_ID('dbo.tbl_marketing_template', 'U') IS NOT NULL DROP TABLE dbo.tbl_marketing_template;
CREATE TABLE dbo.tbl_marketing_template (
    id NVARCHAR(255) PRIMARY KEY,
    subject NVARCHAR(255) NOT NULL,
    body NVARCHAR(MAX) NULL
);

IF OBJECT_ID('dbo.tbl_marketing_campaign', 'U') IS NOT NULL DROP TABLE dbo.tbl_marketing_campaign;
CREATE TABLE dbo.tbl_marketing_campaign (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email_id NVARCHAR(255) NOT NULL,
    template_id NVARCHAR(255) NOT NULL,
    campaign_date DATETIME NOT NULL,
    FOREIGN KEY (template_id) REFERENCES dbo.tbl_marketing_template (id),
    FOREIGN KEY (email_id) REFERENCES dbo.tbl_email_lists (id)
);

IF OBJECT_ID('dbo.tbl_bugs', 'U') IS NOT NULL DROP TABLE dbo.tbl_bugs;
CREATE TABLE dbo.tbl_bugs (
    id NVARCHAR(255) PRIMARY KEY,
    name NVARCHAR(255) NULL,
    date_entered DATETIME NULL,
    date_modified DATETIME NULL,
    modified_user_id NVARCHAR(255) NULL,
    created_by NVARCHAR(255) NULL,
    description NVARCHAR(MAX) NULL,
    deleted BIT DEFAULT 0,
    assigned_user_id NVARCHAR(255) NULL,
    bug_number INT DEFAULT 0,
    type NVARCHAR(255) NULL,
    status NVARCHAR(100) NULL,
    priority NVARCHAR(100) NULL,
    resolution NVARCHAR(255) NULL,
    work_log NVARCHAR(MAX) NULL,
    found_in_release NVARCHAR(255) NULL,
    fixed_in_release NVARCHAR(255) NULL,
    source NVARCHAR(255) NULL,
    product_category NVARCHAR(255) NULL
);

IF OBJECT_ID('dbo.tbl_product', 'U') IS NOT NULL DROP TABLE dbo.tbl_product;
CREATE TABLE dbo.tbl_product (
    id NVARCHAR(255) PRIMARY KEY,
    name NVARCHAR(150) NULL,
    description NVARCHAR(MAX) NULL,
    price DECIMAL(10,2),
    quantity INT DEFAULT 0
);
GO

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

/* ======================================================
   POPULATE 1000 SAMPLE ROWS
====================================================== */
DECLARE @i INT=1;
WHILE @i<=1000
BEGIN
    DECLARE @account_uuid UNIQUEIDENTIFIER=NEWID();
    DECLARE @user_uuid NVARCHAR(255)=CAST(NEWID() AS NVARCHAR(255));
    DECLARE @call_uuid UNIQUEIDENTIFIER=NEWID();
    DECLARE @product_uuid NVARCHAR(255)=CAST(NEWID() AS NVARCHAR(255));
    DECLARE @email_uuid NVARCHAR(255)=CAST(NEWID() AS NVARCHAR(255));
    DECLARE @template_uuid NVARCHAR(255)=CAST(NEWID() AS NVARCHAR(255));
    DECLARE @bug_uuid NVARCHAR(255)=CAST(NEWID() AS NVARCHAR(255));
    DECLARE @status_id INT=(@i%4)+1;

    INSERT INTO dbo.tbl_crm_accounts (id,name,date_entered,date_modified,modified_user_id,created_by,description,deleted,assigned_user_id,account_type,industry,annual_revenue,
        phone_fax,billing_address_street,billing_address_city,billing_address_state,billing_address_postalcode,billing_address_country,rating,phone_office,
        phone_alternate,website,ownership,employees,ticker_symbol,shipping_address_street,shipping_address_city,shipping_address_state,shipping_address_postalcode,
        shipping_address_country,parent_id,sic_code,campaign_id,status)
    VALUES (@account_uuid,'Company '+CAST(@i AS NVARCHAR),GETDATE(),GETDATE(),@user_uuid,@user_uuid,NULL,0,@user_uuid,'Customer','Technology',NULL,NULL,
        'Street '+CAST(@i AS NVARCHAR),'City '+CAST(@i AS NVARCHAR),'State '+CAST(@i AS NVARCHAR),'100'+CAST(@i AS NVARCHAR),'Country '+CAST(@i AS NVARCHAR),NULL,
        '(123) 456-789'+CAST(@i AS NVARCHAR),NULL,'www.company'+CAST(@i AS NVARCHAR)+'.com',NULL,NULL,NULL,'Street '+CAST(@i AS NVARCHAR),'City '+CAST(@i AS NVARCHAR),
        'State '+CAST(@i AS NVARCHAR),'100'+CAST(@i AS NVARCHAR),'Country '+CAST(@i AS NVARCHAR),NULL,NULL,NULL,@status_id);

    INSERT INTO dbo.tbl_calls (id,name,date_entered,date_modified,modified_user_id,created_by,description,deleted,assigned_user_id,duration_hours,duration_minutes,
        date_start,date_end,parent_type,status,direction,parent_id,reminder_time,outlook_id)
    VALUES (@call_uuid,'Call '+CAST(@i AS NVARCHAR),DATEADD(DAY,-2,GETDATE()),GETDATE(),@user_uuid,@user_uuid,NULL,0,@user_uuid,1,30,GETDATE(),DATEADD(MINUTE,30,GETDATE()),
        'Accounts','Planned','Outbound',@account_uuid,-1,NULL);

    INSERT INTO dbo.tbl_product (id,name,description,price,quantity)
    VALUES (@product_uuid,'Product '+CAST(@i AS NVARCHAR),'Description for product '+CAST(@i AS NVARCHAR),9.99,100);

    INSERT INTO dbo.tbl_email_lists (id,email_address,email_address_caps,opt_out,date_created)
    VALUES (@email_uuid,'user'+CAST(@i AS NVARCHAR)+'@securecrm.com','USER'+CAST(@i AS NVARCHAR)+'@securecrm.COM',0,GETDATE());

    INSERT INTO dbo.tbl_marketing_template (id,subject,body)
    VALUES (@template_uuid,'Marketing Subject '+CAST(@i AS NVARCHAR),'Marketing body content for '+CAST(@i AS NVARCHAR));

    INSERT INTO dbo.tbl_marketing_campaign (email_id,template_id,campaign_date)
    VALUES (@email_uuid,@template_uuid,DATEADD(DAY,10,GETDATE()));

    INSERT INTO dbo.tbl_bugs (id,name,date_entered,date_modified,modified_user_id,created_by,description,deleted,assigned_user_id,bug_number,type,status,priority,resolution,work_log,found_in_release,fixed_in_release,source,product_category)
    VALUES (@bug_uuid,'Bug '+CAST(@i AS NVARCHAR),DATEADD(DAY,-2,GETDATE()),GETDATE(),@user_uuid,@user_uuid,NULL,0,@user_uuid,@i,NULL,'Assigned','Medium',NULL,NULL,NULL,NULL,NULL,NULL);

    SET @i+=1;
END
GO

/* ======================================================
   CREATE LOGINS & USERS + GRANTS
====================================================== */
USE [master];
GO
IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name='john')  CREATE LOGIN [john] WITH PASSWORD='Password1!';
IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name='jason') CREATE LOGIN [jason] WITH PASSWORD='Password1!';
IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name='polly') CREATE LOGIN [polly] WITH PASSWORD='Password1!';
IF NOT EXISTS (SELECT * FROM sys.sql_logins WHERE name='liher') CREATE LOGIN [liher] WITH PASSWORD='Password1!';
GO

USE [CRM];
GO
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name='john')  CREATE USER [john] FOR LOGIN [john];
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name='jason') CREATE USER [jason] FOR LOGIN [jason];
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name='polly') CREATE USER [polly] FOR LOGIN [polly];
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name='liher') CREATE USER [liher] FOR LOGIN [liher];

GRANT SELECT,INSERT,UPDATE ON SCHEMA::dbo TO [john];
GRANT SELECT,INSERT,UPDATE ON SCHEMA::dbo TO [jason];
GRANT EXECUTE ON SCHEMA::dbo TO [john];
GRANT EXECUTE ON SCHEMA::dbo TO [jason];

ALTER SERVER ROLE sysadmin ADD MEMBER [polly];
ALTER SERVER ROLE sysadmin ADD MEMBER [liher];
GO
