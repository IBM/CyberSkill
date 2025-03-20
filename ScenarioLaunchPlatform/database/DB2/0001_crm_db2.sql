--#SET TERMINATOR @
DROP TABLE crm.tbl_crm_accounts_status;
DROP TABLE crm.tbl_crm_accounts;
DROP TABLE crm.tbl_calls;
DROP TABLE crm.tbl_email_lists;
DROP TABLE crm.tbl_marketing_template;
DROP TABLE crm.tbl_marketing_campaign;
DROP TABLE crm.tbl_bugs;
DROP TABLE crm.tbl_product;

-- Create tbl_crm_accounts_status
CREATE TABLE crm.tbl_crm_accounts_status (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    status VARCHAR(64) NOT NULL DEFAULT ''
);

-- Create tbl_crm_accounts
CREATE TABLE crm.tbl_crm_accounts (
    id CHAR(36) NOT NULL PRIMARY KEY,
    name VARCHAR(150),
    date_entered TIMESTAMP,
    date_modified TIMESTAMP,
    modified_user_id CHAR(36),
    created_by CHAR(36),
    description CLOB,
    deleted SMALLINT DEFAULT 0,
    assigned_user_id CHAR(36),
    account_type VARCHAR(50),
    industry VARCHAR(50),
    annual_revenue VARCHAR(100),
    phone_fax VARCHAR(100),
    billing_address_street VARCHAR(150),
    billing_address_city VARCHAR(100),
    billing_address_state VARCHAR(100),
    billing_address_postalcode VARCHAR(20),
    billing_address_country VARCHAR(255),
    rating VARCHAR(100),
    phone_office VARCHAR(100),
    phone_alternate VARCHAR(100),
    website VARCHAR(255),
    ownership VARCHAR(100),
    employees VARCHAR(10),
    ticker_symbol VARCHAR(10),
    shipping_address_street VARCHAR(150),
    shipping_address_city VARCHAR(100),
    shipping_address_state VARCHAR(100),
    shipping_address_postalcode VARCHAR(20),
    shipping_address_country VARCHAR(255),
    parent_id CHAR(36),
    sic_code VARCHAR(10),
    campaign_id CHAR(36),
    status INTEGER NOT NULL
);
ALTER TABLE crm.tbl_crm_accounts FOREIGN KEY (status) REFERENCES crm.tbl_crm_accounts_status(id) ON UPDATE NO ACTION ON DELETE CASCADE;

-- Create tbl_calls
CREATE TABLE crm.tbl_calls (
    id CHAR(36) NOT NULL PRIMARY KEY,
    name VARCHAR(50),
    date_entered TIMESTAMP,
    date_modified TIMESTAMP,
    modified_user_id CHAR(36),
    created_by CHAR(36),
    description CLOB,
    deleted SMALLINT DEFAULT 0,
    assigned_user_id CHAR(36),
    duration_hours INTEGER,
    duration_minutes INTEGER,
    date_start VARCHAR(50),
    date_end VARCHAR(50),
    parent_type VARCHAR(255),
    status VARCHAR(100) DEFAULT 'Planned',
    direction VARCHAR(100),
    parent_id CHAR(36),
    reminder_time INTEGER DEFAULT -1,
    outlook_id VARCHAR(255)
);

-- Create tbl_email_lists
CREATE TABLE crm.tbl_email_lists (
    id CHAR(36) NOT NULL,
    email_address VARCHAR(150) NOT NULL UNIQUE,
    email_address_caps VARCHAR(255),
    opt_out SMALLINT DEFAULT 0,
    date_created TIMESTAMP,
    PRIMARY KEY (id)
);

-- Create tbl_marketing_template
CREATE TABLE crm.tbl_marketing_template (
    id CHAR(36) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    body CLOB,
    PRIMARY KEY (id)
);

-- Create tbl_marketing_campaign
CREATE TABLE crm.tbl_marketing_campaign (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email_id CHAR(36) NOT NULL ,
    template_id CHAR(36) NOT NULL,
    campaign_date TIMESTAMP NOT NULL
);

ALTER TABLE crm.tbl_marketing_campaign FOREIGN KEY (email_id) REFERENCES crm.tbl_email_lists(id) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE crm.tbl_marketing_campaign FOREIGN KEY (template_id) REFERENCES crm.tbl_marketing_template(id) ON UPDATE NO ACTION ON DELETE CASCADE;


-- Create tbl_bugs
CREATE TABLE crm.tbl_bugs (
    id CHAR(36) NOT NULL PRIMARY KEY,
    name VARCHAR(255),
    date_entered VARCHAR(255),
    date_modified VARCHAR(255),
    modified_user_id CHAR(36),
    created_by CHAR(36),
    description CLOB,
    deleted SMALLINT DEFAULT 0,
    assigned_user_id CHAR(36),
    bug_number INTEGER DEFAULT 0,
    type VARCHAR(255),
    status VARCHAR(100),
    priority VARCHAR(100),
    resolution VARCHAR(255),
    work_log CLOB,
    found_in_release VARCHAR(255),
    fixed_in_release VARCHAR(255),
    source VARCHAR(255),
    product_category VARCHAR(255)
);

-- Create tbl_product
CREATE TABLE crm.tbl_product (
    id VARCHAR(25) NOT NULL PRIMARY KEY,
    name VARCHAR(150),
    description CLOB,
    price DECIMAL(10,2),
    quantity INTEGER DEFAULT 0
);

-- User Management
--CREATE USER POLLY WITH PASSWORD 'Password1!';
--CREATE USER JOHN WITH PASSWORD 'Password1!';
--CREATE USER JASON WITH PASSWORD 'Password1!';
--CREATE USER LIHER WITH PASSWORD 'Password1!';

GRANT CONNECT ON DATABASE TO USER john;
GRANT CONNECT ON DATABASE TO USER jason;
GRANT CONNECT ON DATABASE TO USER polly;
GRANT CONNECT ON DATABASE TO USER liher;

GRANT DBADM ON DATABASE TO polly;
GRANT DBADM ON DATABASE TO liher;
GRANT CREATEIN, ALTERIN, DROPIN ON SCHEMA crm TO john;
GRANT CREATEIN, ALTERIN, DROPIN ON SCHEMA crm TO jason;

GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_crm_accounts_status TO jason;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_crm_accounts TO jason;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_calls TO jason;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_email_lists TO jason;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_marketing_template TO jason;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_marketing_campaign TO jason;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_bugs TO jason;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_product TO jason;

GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_crm_accounts_status TO john;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_crm_accounts TO john;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_calls TO john;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_email_lists TO john;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_marketing_template TO john;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_marketing_campaign TO john;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_bugs TO john;
GRANT SELECT, INSERT, UPDATE ON TABLE crm.tbl_product TO john;

-- DB2 likes this names specifically as there is no command to allow for all. It will have to be part of the setup for a Mal Proc use case
--GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA crm TO JOHN;
--GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA crm TO JOHN;
--GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA crm TO JASON;
--GRANT EXECUTE ON ALL PROCEDURES IN SCHEMA crm TO JASON;

CREATE OR REPLACE PROCEDURE PopulateTables()
LANGUAGE SQL
BEGIN
    DECLARE i INT DEFAULT 0;

    -- Populate tbl_crm_accounts_status
    WHILE i < 10 DO
        INSERT INTO crm.tbl_crm_accounts_status (status) 
        VALUES (
            CASE 
                WHEN RAND() < 0.1 THEN 'RFP' 
                WHEN RAND() < 0.2 THEN 'Holding' 
                WHEN RAND() < 0.3 THEN 'Call Back' 
                WHEN RAND() < 0.4 THEN 'Negotiation' 
                WHEN RAND() < 0.5 THEN 'Closed Won' 
                WHEN RAND() < 0.6 THEN 'Closed Lost' 
                WHEN RAND() < 0.7 THEN 'Pending Approval' 
                WHEN RAND() < 0.8 THEN 'On Hold' 
                WHEN RAND() < 0.9 THEN 'Under Review' 
                ELSE 'Prospect' 
            END
        );
        SET i = i + 1;
    END WHILE;

    SET i = 0;
    
    -- Populate tbl_crm_accounts
    WHILE i < 1000 DO
        INSERT INTO crm.tbl_crm_accounts (id, name, date_entered, date_modified, modified_user_id, created_by, description, deleted, assigned_user_id, account_type, industry, annual_revenue, phone_fax, billing_address_street, billing_address_city, billing_address_state, billing_address_postalcode, billing_address_country, rating, phone_office, phone_alternate, website, ownership, employees, ticker_symbol, shipping_address_street, shipping_address_city, shipping_address_state, shipping_address_postalcode, shipping_address_country, parent_id, sic_code, campaign_id, status) 
        VALUES (
            SUBSTR(HEX(SYSIBM.GENERATE_UNIQUE()), 1, 25), 
            'MegaCorp_' || i, 
            CURRENT TIMESTAMP, 
            CURRENT TIMESTAMP, 
            HEX(SYSIBM.GENERATE_UNIQUE()), 
            HEX(SYSIBM.GENERATE_UNIQUE()), 
            CASE 
                WHEN RAND() < 0.2 THEN 'Innovator in AI-driven analytics.' 
                WHEN RAND() < 0.4 THEN 'Pioneering next-gen cloud computing.' 
                WHEN RAND() < 0.6 THEN 'Transforming industries with automation.' 
                WHEN RAND() < 0.8 THEN 'Redefining customer engagement with AI.' 
                ELSE 'Trailblazer in quantum computing solutions.' 
            END, 
            0, 
            HEX(SYSIBM.GENERATE_UNIQUE()), 
            'Enterprise', 
            'Technology', 
            '500M+', 
            '555-1234', 
            '42 Innovation Blvd', 
            'Tech City', 
            'Futurist State', 
            '54321', 
            'Global', 
            '5-Star', 
            '555-5678', 
            '555-8765', 
            'www.megacorp.com', 
            'Public', 
            '5000+', 
            'MGC', 
            '10 Silicon Way', 
            'Tech City', 
            'Futurist State', 
            '67890', 
            'Global', 
            NULL, 
            'SIC123', 
            NULL, 
            (SELECT id FROM crm.tbl_crm_accounts_status ORDER BY RAND() FETCH FIRST 1 ROW ONLY)
        );
        SET i = i + 1;
    END WHILE;

    SET i = 0;

    -- Populate tbl_calls
    WHILE i < 1000 DO
        INSERT INTO crm.tbl_calls (id, name, date_entered, date_modified, modified_user_id, created_by, description, deleted, assigned_user_id, duration_hours, duration_minutes, date_start, date_end, parent_type, status, direction, parent_id, reminder_time, outlook_id) 
        VALUES (
            SUBSTR(HEX(SYSIBM.GENERATE_UNIQUE()), 1, 25), 
            'Strategic Meeting_' || i, 
            CURRENT TIMESTAMP, 
            CURRENT TIMESTAMP, 
            HEX(SYSIBM.GENERATE_UNIQUE()), 
            HEX(SYSIBM.GENERATE_UNIQUE()), 
            'Discussing groundbreaking innovations.', 
            0, 
            HEX(SYSIBM.GENERATE_UNIQUE()), 
            INT(RAND() * 5), 
            INT(RAND() * 60), 
            CURRENT TIMESTAMP, 
            CURRENT TIMESTAMP, 
            'Tech Conference', 
            'Confirmed', 
            'Inbound', 
            HEX(SYSIBM.GENERATE_UNIQUE()), 
            -1, 
            NULL
        );
        SET i = i + 1;
    END WHILE;

    SET i = 0;

    -- Populate tbl_email_lists
    WHILE i < 1000 DO
        INSERT INTO crm.tbl_email_lists (id, email_address, email_address_caps, opt_out, date_created) 
        VALUES (
            SUBSTR(HEX(SYSIBM.GENERATE_UNIQUE()), 1, 25), 
            'user' || i || '@domain.com', 
            UPPER('user' || i || '@domain.com'), 
            0, 
            CURRENT TIMESTAMP
        );
        SET i = i + 1;
    END WHILE;

    SET i = 0;

    -- Populate tbl_marketing_template
    WHILE i < 1000 DO
        INSERT INTO crm.tbl_marketing_template (id, subject, body) 
        VALUES (
            SUBSTR(HEX(SYSIBM.GENERATE_UNIQUE()), 1, 25), 
            'Revolutionizing the Future_' || i, 
            'Join us as we redefine the industry with cutting-edge technology.'
        );
        SET i = i + 1;
    END WHILE;

    SET i = 0;

    -- Populate tbl_marketing_campaign
    WHILE i < 1000 DO
        INSERT INTO crm.tbl_marketing_campaign (email_id, template_id, campaign_date) 
        VALUES (
            (SELECT id FROM crm.tbl_email_lists ORDER BY RAND() FETCH FIRST 1 ROW ONLY), 
            (SELECT id FROM crm.tbl_marketing_template ORDER BY RAND() FETCH FIRST 1 ROW ONLY), 
            CURRENT TIMESTAMP
        );
        SET i = i + 1;
    END WHILE;

    SET i = 0;

    -- Populate tbl_bugs
    WHILE i < 1000 DO
        INSERT INTO crm.tbl_bugs (id, name, date_entered, date_modified, modified_user_id, created_by, description, deleted, assigned_user_id, bug_number, type, status, priority, resolution, work_log, found_in_release, fixed_in_release, source, product_category) 
        VALUES (
            SUBSTR(HEX(SYSIBM.GENERATE_UNIQUE()), 1, 25), 
            'AI Glitch_' || i, 
            CURRENT TIMESTAMP, 
            CURRENT TIMESTAMP, 
            HEX(SYSIBM.GENERATE_UNIQUE()), 
            HEX(SYSIBM.GENERATE_UNIQUE()), 
            'Neural network miscalculation causing unexpected insights.', 
            0, 
            HEX(SYSIBM.GENERATE_UNIQUE()), 
            INT(RAND() * 1000), 
            'AI Module', 
            'Open', 
            'Critical', 
            'In Progress', 
            'Investigating deep learning anomalies.', 
            'v3.2', 
            'v3.3', 
            'AI Lab', 
            'Machine Learning'
        );
        SET i = i + 1;
    END WHILE;

END
