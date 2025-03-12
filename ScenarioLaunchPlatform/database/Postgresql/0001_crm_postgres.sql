DROP TABLE IF EXISTS tbl_crm_accounts_status CASCADE;
CREATE TABLE tbl_crm_accounts_status (
  id SERIAL PRIMARY KEY,
  status VARCHAR(64) NOT NULL DEFAULT ''
);

DROP TABLE IF EXISTS tbl_crm_accounts CASCADE;
CREATE TABLE tbl_crm_accounts (
  id UUID PRIMARY KEY,
  name VARCHAR(150) DEFAULT NULL,
  date_entered TIMESTAMP DEFAULT NULL,
  date_modified TIMESTAMP DEFAULT NULL,
  modified_user_id VARCHAR(255) DEFAULT NULL,
  created_by VARCHAR(255) DEFAULT NULL,
  description TEXT,
  deleted BOOLEAN DEFAULT FALSE,
  assigned_user_id VARCHAR(255) DEFAULT NULL,
  account_type VARCHAR(50) DEFAULT NULL,
  industry VARCHAR(50) DEFAULT NULL,
  annual_revenue VARCHAR(100) DEFAULT NULL,
  phone_fax VARCHAR(100) DEFAULT NULL,
  billing_address_street VARCHAR(150) DEFAULT NULL,
  billing_address_city VARCHAR(100) DEFAULT NULL,
  billing_address_state VARCHAR(100) DEFAULT NULL,
  billing_address_postalcode VARCHAR(20) DEFAULT NULL,
  billing_address_country VARCHAR(255) DEFAULT NULL,
  rating VARCHAR(100) DEFAULT NULL,
  phone_office VARCHAR(100) DEFAULT NULL,
  phone_alternate VARCHAR(100) DEFAULT NULL,
  website VARCHAR(255) DEFAULT NULL,
  ownership VARCHAR(100) DEFAULT NULL,
  employees VARCHAR(10) DEFAULT NULL,
  ticker_symbol VARCHAR(10) DEFAULT NULL,
  shipping_address_street VARCHAR(150) DEFAULT NULL,
  shipping_address_city VARCHAR(100) DEFAULT NULL,
  shipping_address_state VARCHAR(100) DEFAULT NULL,
  shipping_address_postalcode VARCHAR(20) DEFAULT NULL,
  shipping_address_country VARCHAR(255) DEFAULT NULL,
  parent_id VARCHAR(255) DEFAULT NULL,
  sic_code VARCHAR(10) DEFAULT NULL,
  campaign_id VARCHAR(255) DEFAULT NULL,
  status INTEGER NOT NULL,
  FOREIGN KEY (status) REFERENCES tbl_crm_accounts_status (id)
);

DROP TABLE IF EXISTS tbl_calls CASCADE;
CREATE TABLE tbl_calls (
  id UUID PRIMARY KEY,
  name VARCHAR(50) DEFAULT NULL,
  date_entered TIMESTAMP DEFAULT NULL,
  date_modified TIMESTAMP DEFAULT NULL,
  modified_user_id VARCHAR(255) DEFAULT NULL,
  created_by VARCHAR(255) DEFAULT NULL,
  description TEXT,
  deleted BOOLEAN DEFAULT FALSE,
  assigned_user_id VARCHAR(255) DEFAULT NULL,
  duration_hours INTEGER DEFAULT NULL,
  duration_minutes INTEGER DEFAULT NULL,
  date_start TIMESTAMP DEFAULT NULL,
  date_end TIMESTAMP DEFAULT NULL,
  parent_type VARCHAR(255) DEFAULT NULL,
  status VARCHAR(100) DEFAULT 'Planned',
  direction VARCHAR(100) DEFAULT NULL,
  parent_id VARCHAR(255) DEFAULT NULL,
  reminder_time INTEGER DEFAULT -1,
  outlook_id VARCHAR(255) DEFAULT NULL
);

DROP TABLE IF EXISTS tbl_email_lists CASCADE;
CREATE TABLE tbl_email_lists (
  id VARCHAR(255) PRIMARY KEY,
  email_address VARCHAR(150) UNIQUE NOT NULL,
  email_address_caps VARCHAR(255) DEFAULT NULL,
  opt_out BOOLEAN DEFAULT FALSE,
  date_created TIMESTAMP DEFAULT NULL
);

DROP TABLE IF EXISTS tbl_marketing_template CASCADE;
CREATE TABLE tbl_marketing_template (
  id VARCHAR(255) PRIMARY KEY,
  subject VARCHAR(255) NOT NULL,
  body TEXT
);

DROP TABLE IF EXISTS tbl_marketing_campaign CASCADE;
CREATE TABLE tbl_marketing_campaign (
  id SERIAL PRIMARY KEY,
  email_id VARCHAR(255) NOT NULL,
  template_id VARCHAR(255) NOT NULL,
  campaign_date TIMESTAMP NOT NULL,
  FOREIGN KEY (template_id) REFERENCES tbl_marketing_template (id),
  FOREIGN KEY (email_id) REFERENCES tbl_email_lists (id)
);

DROP TABLE IF EXISTS tbl_bugs CASCADE;
CREATE TABLE tbl_bugs (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) DEFAULT NULL,
  date_entered TIMESTAMP DEFAULT NULL,
  date_modified TIMESTAMP DEFAULT NULL,
  modified_user_id VARCHAR(255) DEFAULT NULL,
  created_by VARCHAR(255) DEFAULT NULL,
  description TEXT,
  deleted BOOLEAN DEFAULT FALSE,
  assigned_user_id VARCHAR(255) DEFAULT NULL,
  bug_number INTEGER DEFAULT 0,
  type VARCHAR(255) DEFAULT NULL,
  status VARCHAR(100) DEFAULT NULL,
  priority VARCHAR(100) DEFAULT NULL,
  resolution VARCHAR(255) DEFAULT NULL,
  work_log TEXT,
  found_in_release VARCHAR(255) DEFAULT NULL,
  fixed_in_release VARCHAR(255) DEFAULT NULL,
  source VARCHAR(255) DEFAULT NULL,
  product_category VARCHAR(255) DEFAULT NULL
);

DROP TABLE IF EXISTS tbl_product CASCADE;
CREATE TABLE tbl_product (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(150) DEFAULT NULL,
  description TEXT,
  price DECIMAL(10,2),
  quantity INTEGER DEFAULT 0
);

-- Insert Data
INSERT INTO tbl_crm_accounts_status (id, status) VALUES (1, 'lead'), (2, 'opportunity'), (3, 'customer/won'), (4, 'archive');

INSERT INTO tbl_crm_accounts VALUES
  ('df61978a-f4cc-ff64-8de0-53e90f19a56a', 'B.H. Edwards Inc', '2024-09-22 03:11:33', '2024-09-24 03:11:33', 'seed_will_id', '1', NULL, FALSE, 'seed_max_id', 'Customer', 'Technology', NULL, NULL, '1715 Scott Dr', 'Alabama', 'CA', '14882', 'USA', NULL, '(847) 706-6877', NULL, 'www.devim.edu', NULL, NULL, NULL, '1715 Scott Dr', 'Alabama', 'CA', '14882', 'USA', NULL, NULL, NULL, 1);

INSERT INTO tbl_calls VALUES ('e854b40d-414e-6c8d-d2b7-53e90f7b0f77', 'Left a message', NOW() - INTERVAL '2 days', NOW(), '1', '1', NULL, FALSE, 'seed_max_id', 0, 30, '2014-12-28 09:30:00', '2014-12-28 10:00:00', 'Accounts', 'Planned', 'Outbound', 'df61978a-f4cc-ff64-8de0-53e90f19a56a', -1, NULL);

INSERT INTO tbl_product VALUES ('d67f8d9d', 'Detergent', 'Keep the clothes cleaner with this detergent', 4.80, 10);

INSERT INTO tbl_email_lists VALUES ('d67f8d9d-7c28-00df-47f1-53e90f54066f', 'jim@securecrm.com', 'JIM@SECURECRM.COM', FALSE, NOW() - INTERVAL '2 days');

INSERT INTO tbl_marketing_template VALUES ('53e90f54066f', 'Free Detergent with new technology', 'Keep the clothes cleaner with this detergent');

INSERT INTO tbl_marketing_campaign (email_id, template_id, campaign_date) VALUES ('d67f8d9d-7c28-00df-47f1-53e90f54066f', '53e90f54066f', NOW() + INTERVAL '10 days');

INSERT INTO tbl_bugs VALUES ('e4f7505c-0a0e-f582-f406-53e90f8a5637', 'Error occurs while running count query', NOW() - INTERVAL '2 days', NOW(), '1', '1', NULL, FALSE, 'seed_max_id', 1, NULL, 'Assigned', 'Medium', NULL, NULL, NULL, NULL, NULL, NULL);

DO $$
DECLARE 
    i INT;
    account_uuid UUID;
    user_uuid VARCHAR;
    call_uuid UUID;
    product_uuid VARCHAR;
    email_uuid VARCHAR;
    template_uuid VARCHAR;
    bug_uuid VARCHAR;
    status_id INT;
BEGIN
  FOR i IN 1..1000 LOOP
    -- Generate UUIDs for foreign keys
    account_uuid := gen_random_uuid();
    user_uuid := gen_random_uuid();
    call_uuid := gen_random_uuid();
    product_uuid := gen_random_uuid();
    email_uuid := gen_random_uuid();
    template_uuid := gen_random_uuid();
    bug_uuid := gen_random_uuid();
    status_id := (i % 4) + 1;  -- Ensure status_id matches existing tbl_crm_accounts_status values (1 to 4)

    -- Insert into tbl_crm_accounts
    INSERT INTO tbl_crm_accounts (id, name, date_entered, date_modified, modified_user_id, created_by, 
                                  description, deleted, assigned_user_id, account_type, industry, annual_revenue,
                                  phone_fax, billing_address_street, billing_address_city, billing_address_state, 
                                  billing_address_postalcode, billing_address_country, rating, phone_office, 
                                  phone_alternate, website, ownership, employees, ticker_symbol, 
                                  shipping_address_street, shipping_address_city, shipping_address_state, 
                                  shipping_address_postalcode, shipping_address_country, parent_id, sic_code, 
                                  campaign_id, status) 
    VALUES (account_uuid, 'Company ' || i, NOW(), NOW(), user_uuid, user_uuid, NULL, FALSE, user_uuid, 
            'Customer', 'Technology', NULL, NULL, 'Street ' || i, 'City ' || i, 'State ' || i, '100' || i, 
            'Country ' || i, NULL, '(123) 456-789' || i, NULL, 'www.company' || i || '.com', NULL, NULL, 
            NULL, 'Street ' || i, 'City ' || i, 'State ' || i, '100' || i, 'Country ' || i, NULL, NULL, NULL, status_id);

    -- Insert into tbl_calls
    INSERT INTO tbl_calls (id, name, date_entered, date_modified, modified_user_id, created_by, 
                           description, deleted, assigned_user_id, duration_hours, duration_minutes, 
                           date_start, date_end, parent_type, status, direction, parent_id, reminder_time, outlook_id)
    VALUES (call_uuid, 'Call ' || i, NOW() - INTERVAL '2 days', NOW(), user_uuid, user_uuid, NULL, FALSE, user_uuid, 
            1, 30, NOW(), NOW() + INTERVAL '30 minutes', 'Accounts', 'Planned', 'Outbound', account_uuid, -1, NULL);

    -- Insert into tbl_product
    INSERT INTO tbl_product (id, name, description, price, quantity)
    VALUES (product_uuid, 'Product ' || i, 'Description for product ' || i, 9.99, 100);

    -- Insert into tbl_email_lists
    INSERT INTO tbl_email_lists (id, email_address, email_address_caps, opt_out, date_created)
    VALUES (email_uuid, 'user' || i || '@securecrm.com', 'USER' || i || '@securecrm.COM', FALSE, NOW());

    -- Insert into tbl_marketing_template
    INSERT INTO tbl_marketing_template (id, subject, body) 
    VALUES (template_uuid, 'Marketing Subject ' || i, 'Marketing body content for ' || i);

    -- Insert into tbl_marketing_campaign
    INSERT INTO tbl_marketing_campaign (email_id, template_id, campaign_date) 
    VALUES (email_uuid, template_uuid, NOW() + INTERVAL '10 days');

    -- Insert into tbl_bugs
    INSERT INTO tbl_bugs (id, name, date_entered, date_modified, modified_user_id, created_by, 
                          description, deleted, assigned_user_id, bug_number, type, status, priority, 
                          resolution, work_log, found_in_release, fixed_in_release, source, product_category) 
    VALUES (bug_uuid, 'Bug ' || i, NOW() - INTERVAL '2 days', NOW(), user_uuid, user_uuid, NULL, FALSE, user_uuid, 
            i, NULL, 'Assigned', 'Medium', NULL, NULL, NULL, NULL, NULL, NULL);
  END LOOP;
END $$;
/*
DO $$
BEGIN
    -- Check and create user1
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'john') THEN
        CREATE ROLE john WITH LOGIN
	CREATEDB
	CREATEROLE
	INHERIT
	REPLICATION
	BYPASSRLS
	CONNECTION LIMIT -1
	PASSWORD 'password';
    END IF;

    -- Check and create user2
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'jason') THEN
         CREATE ROLE jason WITH LOGIN
	CREATEDB
	CREATEROLE
	INHERIT
	REPLICATION
	BYPASSRLS
	CONNECTION LIMIT -1
	PASSWORD 'password';
    END IF;

    -- Check and create user3
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'polly') THEN
        CREATE ROLE polly WITH LOGIN
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	REPLICATION
	BYPASSRLS
	CONNECTION LIMIT -1
	PASSWORD 'password';
    END IF;

    -- Check and create user4
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'liher') THEN
        CREATE ROLE liher WITH LOGIN
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	REPLICATION
	BYPASSRLS
	CONNECTION LIMIT -1
	PASSWORD 'password';
    END IF;
END $$
*/
