use crm;

DROP TABLE IF EXISTS tbl_crm_accounts_status;
CREATE TABLE tbl_crm_accounts_status (
  id int(11) NOT NULL AUTO_INCREMENT,
  status varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
UNLOCK TABLES;


DROP TABLE IF EXISTS tbl_crm_accounts;
CREATE TABLE tbl_crm_accounts (
  id varchar(36) NOT NULL,
  name varchar(150) DEFAULT NULL,
  date_entered datetime DEFAULT NULL,
  date_modified datetime DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description text,
  deleted tinyint(1) DEFAULT '0',
  assigned_user_id char(36) DEFAULT NULL,
  account_type varchar(50) DEFAULT NULL,
  industry varchar(50) DEFAULT NULL,
  annual_revenue varchar(100) DEFAULT NULL,
  phone_fax varchar(100) DEFAULT NULL,
  billing_address_street varchar(150) DEFAULT NULL,
  billing_address_city varchar(100) DEFAULT NULL,
  billing_address_state varchar(100) DEFAULT NULL,
  billing_address_postalcode varchar(20) DEFAULT NULL,
  billing_address_country varchar(255) DEFAULT NULL,
  rating varchar(100) DEFAULT NULL,
  phone_office varchar(100) DEFAULT NULL,
  phone_alternate varchar(100) DEFAULT NULL,
  website varchar(255) DEFAULT NULL,
  ownership varchar(100) DEFAULT NULL,
  employees varchar(10) DEFAULT NULL,
  ticker_symbol varchar(10) DEFAULT NULL,
  shipping_address_street varchar(150) DEFAULT NULL,
  shipping_address_city varchar(100) DEFAULT NULL,
  shipping_address_state varchar(100) DEFAULT NULL,
  shipping_address_postalcode varchar(20) DEFAULT NULL,
  shipping_address_country varchar(255) DEFAULT NULL,
  parent_id char(36) DEFAULT NULL,
  sic_code varchar(10) DEFAULT NULL,
  campaign_id char(36) DEFAULT NULL,
  status int(11) unsigned NOT NULL,
  PRIMARY KEY (id),
  KEY FK_STATUS (status),
  CONSTRAINT FK_STATUS FOREIGN KEY (status) REFERENCES tbl_crm_accounts_status (id)) ENGINE=MyISAM DEFAULT CHARSET=utf8;
UNLOCK TABLES;

DROP TABLE IF EXISTS tbl_calls;
CREATE TABLE tbl_calls (
  id char(36) NOT NULL,
  name varchar(50) DEFAULT NULL,
  date_entered datetime DEFAULT NULL,
  date_modified datetime DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description text,
  deleted tinyint(1) DEFAULT '0',
  assigned_user_id char(36) DEFAULT NULL,
  duration_hours int DEFAULT NULL,
  duration_minutes int DEFAULT NULL,
  date_start varchar(50) DEFAULT NULL,
  date_end varchar(50) DEFAULT NULL,
  parent_type varchar(255) DEFAULT NULL,
  status varchar(100) DEFAULT 'Planned',
  direction varchar(100) DEFAULT NULL,
  parent_id char(36) DEFAULT NULL,
  reminder_time int DEFAULT '-1',
  outlook_id varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)) ENGINE=MyISAM DEFAULT CHARSET=utf8;
UNLOCK TABLES;

DROP TABLE IF EXISTS tbl_email_lists;
CREATE TABLE tbl_email_lists (
  id varchar(36) NOT NULL UNIQUE,
  email_address varchar(150) NOT NULL UNIQUE,
  email_address_caps varchar(255) DEFAULT NULL,
  opt_out tinyint(1) DEFAULT '0',
   date_created datetime DEFAULT NULL,
  PRIMARY KEY (id,email_address)) ENGINE=MyISAM DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS tbl_marketing_template;
CREATE TABLE tbl_marketing_template (
  id varchar(36) NOT NULL,
  subject varchar(255) NOT NULL,
  body text,
  PRIMARY KEY (id)) ENGINE=MyISAM DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS tbl_marketing_campaign;
CREATE TABLE tbl_marketing_campaign (
  id int NOT NULL AUTO_INCREMENT,
  email_id char(36) NOT NULL,
  template_id char(36) NOT NULL,
  campaign_date datetime NOT NULL,
  PRIMARY KEY (id),
  KEY FK_TEMPLATE_ID (template_id),
  KEY FK_EMAIL_ID (email_id),
  CONSTRAINT FK_TEMPLATE_ID FOREIGN KEY (template_id) REFERENCES tbl_marketing_template (id),
  CONSTRAINT FK_EMAIL_ID FOREIGN KEY (email_id) REFERENCES tbl_email_lists (id)) ENGINE=MyISAM DEFAULT CHARSET=utf8;
ALTER TABLE tbl_marketing_campaign AUTO_INCREMENT=100;

DROP TABLE IF EXISTS tbl_bugs;
CREATE TABLE tbl_bugs (
  id char(36) NOT NULL,
  name varchar(255) DEFAULT NULL,
  date_entered varchar(255) DEFAULT NULL,
  date_modified varchar(255) DEFAULT NULL,
  modified_user_id char(36) DEFAULT NULL,
  created_by char(36) DEFAULT NULL,
  description text,
  deleted tinyint(1) DEFAULT '0',
  assigned_user_id char(36) DEFAULT NULL,
  bug_number int DEFAULT '0',
  type varchar(255) DEFAULT NULL,
  status varchar(100) DEFAULT NULL,
  priority varchar(100) DEFAULT NULL,
  resolution varchar(255) DEFAULT NULL,
  work_log text,
  found_in_release varchar(255) DEFAULT NULL,
  fixed_in_release varchar(255) DEFAULT NULL,
  source varchar(255) DEFAULT NULL,
  product_category varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
UNLOCK TABLES;

DROP TABLE IF EXISTS tbl_product;
CREATE TABLE tbl_product (
  id varchar(25) NOT NULL,
  name varchar(150) DEFAULT NULL,
  description text,
  price DECIMAL(10,2),
  quantity INT DEFAULT '0',
  PRIMARY KEY (id)) ENGINE=MyISAM DEFAULT CHARSET=utf8;


INSERT INTO tbl_crm_accounts_status (id, status) values (1,'lead'),
	(2,'opportunity'),
	(3,'customer/won'),
	(4,'archive');


INSERT INTO tbl_crm_accounts VALUES ('df61978a-f4cc-ff64-8de0-53e90f19a56a','B.H. Edwards Inc','2024-09-22 03:11:33','2024-09-24 03:11:33','seed_will_id','1',NULL,0,'seed_max_id','Customer','Technology',NULL,NULL,'1715 Scott Dr','Alabama','CA','14882','USA',NULL,'(847) 706-6877',NULL,'www.devim.edu',NULL,NULL,NULL,'1715 Scott Dr','Alabama','CA','14882','USA',NULL,NULL,NULL,1);

INSERT INTO tbl_calls VALUES ('e854b40d-414e-6c8d-d2b7-53e90f7b0f77','Left a message',DATE_SUB(NOW(), INTERVAL 2 DAY),NOW(),'1','1',NULL,0,'seed_max_id',0,30,'2014-12-28 09:30:00','2014-12-28 10:00:00','Accounts','Planned','Outbound','df61978a-f4cc-ff64-8de0-53e90f19a56a',-1,NULL);

INSERT INTO tbl_product VALUES ('d67f8d9d','Detergent','Keep the clothes cleaner with this detergent','4.80',10);

INSERT INTO tbl_email_lists VALUES ('d67f8d9d-7c28-00df-47f1-53e90f54066f','jim@example.com','JIM@EXAMPLE.COM',0,DATE_SUB(NOW(), INTERVAL 2 DAY));

INSERT INTO tbl_marketing_template VALUES ('53e90f54066f','Free Detergent with new technology','Keep the clothes cleaner with this detergent');

INSERT INTO tbl_marketing_campaign (email_id,template_id,campaign_date)VALUES ('d67f8d9d-7c28-00df-47f1-53e90f54066f','53e90f54066f',DATE_SUB(NOW(), INTERVAL -10 DAY));

INSERT INTO tbl_bugs VALUES ('e4f7505c-0a0e-f582-f406-53e90f8a5637','Error occurs while running count query',DATE_SUB(NOW(), INTERVAL 2 DAY),NOW(),'1','1',NULL,0,'seed_max_id',1,NULL,'Assigned','Medium',NULL,NULL,NULL,NULL,NULL,NULL);



-- New function to create rows for each table
DELIMITER $$
CREATE PROCEDURE PopulateTables()
BEGIN
    DECLARE i INT DEFAULT 0;
    
    -- Populate tbl_crm_accounts_status
    WHILE i < 10 DO
        INSERT INTO tbl_crm_accounts_status (status) VALUES 
        (CASE 
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
        END);
        SET i = i + 1;
    END WHILE;
    
    SET i = 0;
    -- Populate tbl_crm_accounts
    WHILE i < 1000 DO
        INSERT INTO tbl_crm_accounts (id, name, date_entered, date_modified, modified_user_id, created_by, description, deleted, assigned_user_id, account_type, industry, annual_revenue, phone_fax, billing_address_street, billing_address_city, billing_address_state, billing_address_postalcode, billing_address_country, rating, phone_office, phone_alternate, website, ownership, employees, ticker_symbol, shipping_address_street, shipping_address_city, shipping_address_state, shipping_address_postalcode, shipping_address_country, parent_id, sic_code, campaign_id, status) 
        VALUES (SUBSTRING(UUID(), 1, 25), CONCAT('MegaCorp_', i), NOW(), NOW(), UUID(), UUID(), CASE WHEN RAND() < 0.2 THEN 'Innovator in AI-driven analytics.' WHEN RAND() < 0.4 THEN 'Pioneering next-gen cloud computing.' WHEN RAND() < 0.6 THEN 'Transforming industries with automation.' WHEN RAND() < 0.8 THEN 'Redefining customer engagement with AI.' ELSE 'Trailblazer in quantum computing solutions.' END, 0, UUID(), 'Enterprise', 'Technology', '500M+', '555-1234', '42 Innovation Blvd', 'Tech City', 'Futurist State', '54321', 'Global', '5-Star', '555-5678', '555-8765', 'www.megacorp.com', 'Public', '5000+', 'MGC', '10 Silicon Way', 'Tech City', 'Futurist State', '67890', 'Global', NULL, 'SIC123', NULL, (SELECT id FROM tbl_crm_accounts_status ORDER BY RAND() LIMIT 1));
        SET i = i + 1;
    END WHILE;
    
    SET i = 0;
    -- Populate tbl_calls
    WHILE i < 1000 DO
        INSERT INTO tbl_calls (id, name, date_entered, date_modified, modified_user_id, created_by, description, deleted, assigned_user_id, duration_hours, duration_minutes, date_start, date_end, parent_type, status, direction, parent_id, reminder_time, outlook_id) 
        VALUES (SUBSTRING(UUID(), 1, 25), CONCAT('Strategic Meeting_', i), NOW(), NOW(), UUID(), UUID(), 'Discussing groundbreaking innovations.', 0, UUID(), FLOOR(RAND() * 5), FLOOR(RAND() * 60), NOW(), NOW(), 'Tech Conference', 'Confirmed', 'Inbound', UUID(), -1, NULL);
        SET i = i + 1;
    END WHILE;
    
    SET i = 0;
    -- Populate tbl_email_lists
    WHILE i < 1000 DO
        INSERT INTO tbl_email_lists (id, email_address, email_address_caps, opt_out, date_created) 
        VALUES (SUBSTRING(UUID(), 1, 25), 
            CONCAT(
                CASE 
                    WHEN RAND() < 0.2 THEN 'techguru' 
                    WHEN RAND() < 0.4 THEN 'innovator' 
                    WHEN RAND() < 0.6 THEN 'visionary' 
                    WHEN RAND() < 0.8 THEN 'pioneer' 
                    ELSE 'genius' 
                END, i, '@', 
                CASE 
                    WHEN RAND() < 0.5 THEN 'futuretech.com' 
                    ELSE 'nextgenai.com' 
                END), 
            UPPER(CONCAT(
                CASE 
                    WHEN RAND() < 0.2 THEN 'techguru' 
                    WHEN RAND() < 0.4 THEN 'innovator' 
                    WHEN RAND() < 0.6 THEN 'visionary' 
                    WHEN RAND() < 0.8 THEN 'pioneer' 
                    ELSE 'genius' 
                END, i, '@', 
                CASE 
                    WHEN RAND() < 0.5 THEN 'futuretech.com' 
                    ELSE 'nextgenai.com' 
                END)), 
            0, NOW());
        SET i = i + 1;
    END WHILE;
    
    SET i = 0;
    -- Populate tbl_marketing_template
    WHILE i < 1000 DO
        INSERT INTO tbl_marketing_template (id, subject, body) 
        VALUES (SUBSTRING(UUID(), 1, 25), CONCAT('Revolutionizing the Future_', i), 'Join us as we redefine the industry with cutting-edge technology.');
        SET i = i + 1;
    END WHILE;
    
    SET i = 0;
    -- Populate tbl_marketing_campaign
    WHILE i < 1000 DO
        INSERT INTO tbl_marketing_campaign (email_id, template_id, campaign_date) 
        VALUES ((SELECT id FROM tbl_email_lists ORDER BY RAND() LIMIT 1), (SELECT id FROM tbl_marketing_template ORDER BY RAND() LIMIT 1), NOW());
        SET i = i + 1;
    END WHILE;
    
    SET i = 0;
    -- Populate tbl_bugs
    WHILE i < 1000 DO
        INSERT INTO tbl_bugs (id, name, date_entered, date_modified, modified_user_id, created_by, description, deleted, assigned_user_id, bug_number, type, status, priority, resolution, work_log, found_in_release, fixed_in_release, source, product_category) 
        VALUES (SUBSTRING(UUID(), 1, 25), CONCAT('AI Glitch_', i), NOW(), NOW(), UUID(), UUID(), 'Neural network miscalculation causing unexpected insights.', 0, UUID(), FLOOR(RAND() * 1000), 'AI Module', 'Open', 'Critical', 'In Progress', 'Investigating deep learning anomalies.', 'v3.2', 'v3.3', 'AI Lab', 'Machine Learning');
        SET i = i + 1;
    END WHILE;
    
    SET i = 0;
    -- Populate tbl_product
    WHILE i < 1000 DO
        INSERT INTO tbl_product (id, name, description, price, quantity) 
        VALUES (SUBSTRING(UUID(), 1, 25), CONCAT('Quantum Processor_', i), 'Next-gen computing power for AI-driven solutions.', ROUND(RAND() * 10000, 2), FLOOR(RAND() * 500));
        SET i = i + 1;
    END WHILE;
    
END$$
DELIMITER ;

CALL PopulateTables();
-- Test


DROP USER IF EXISTS 'POLLY'@'%';
DROP USER IF EXISTS 'JOHN'@'%';
DROP USER IF EXISTS 'JASON'@'%';
DROP USER IF EXISTS 'LIHER'@'%';

CREATE USER IF NOT EXISTS 'POLLY'@'%' IDENTIFIED BY 'Password1!';
CREATE USER IF NOT EXISTS 'JOHN'@'%' IDENTIFIED BY 'Password1!';
CREATE USER IF NOT EXISTS 'JASON'@'%' IDENTIFIED BY 'Password1!';
CREATE USER IF NOT EXISTS 'LIHER'@'%' IDENTIFIED BY 'Password1!';

GRANT ALL PRIVILEGES ON *.* TO 'POLLY'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'LIHER'@'%' WITH GRANT OPTION;


GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON crm.* TO 'JOHN'@'%';

GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON crm.* TO 'JASON'@'%';

FLUSH PRIVILEGES;