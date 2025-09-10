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
