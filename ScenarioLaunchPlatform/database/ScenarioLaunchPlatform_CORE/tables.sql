-- This script was created by Jason Flood and John Clarke.
DO $$
BEGIN

RAISE NOTICE 'Dropping existing tables with cascade!';
drop table if exists public.tb_user CASCADE;
drop table if exists public.tb_query CASCADE;
drop table if exists public.tb_databaseConnections CASCADE;
drop table if exists public.tb_schedule CASCADE;
drop table if exists public.tb_tasks CASCADE;
drop table if exists public.tb_query_types CASCADE;
drop table if exists public.tb_version CASCADE;
drop table if exists public.tb_stories CASCADE;
drop table if exists public.tb_myvars CASCADE;
drop table if exists public.tb_content_packs CASCADE;
drop table if exists public.tb_admin_functions CASCADE;



drop FUNCTION if exists function_login(TEXT, TEXT);
RAISE NOTICE 'All tables and functions dropped!';

CREATE TABLE IF NOT EXISTS public.tb_version
(
    version character varying(100)
);
insert into public.tb_version(version) VALUES('v01.0012');

-- 1.0007 changes --
CREATE TABLE public.tb_myvars 
(
	id SERIAL PRIMARY KEY, username VARCHAR(255) unique, data JSONB
);

INSERT INTO public.tb_myvars (username, data) VALUES ('admin','{"my_var1": 1, "my_var2": "simpleString1"}');
INSERT INTO public.tb_myvars (username, data) VALUES ('username','{"my_var1": 2, "my_var2": "simpleString2"}');


CREATE TABLE IF NOT EXISTS public.tb_stories
(
	id serial NOT NULL,
	runTime timestamp,
	story JSONB,
	PRIMARY KEY (id)
);

RAISE NOTICE 'Created tb_stories';


ALTER SEQUENCE tb_stories_id_seq RESTART WITH 5000;


CREATE TABLE IF NOT EXISTS public.tb_user
(
    id serial NOT NULL,
    firstname character varying(100),
    surname character varying(100),
    email character varying(100),
    username character varying(100) UNIQUE,
    password character varying(100) NOT NULL,
   	active character varying(100),
    authlevel integer DEFAULT 0 NOT NULL,
    PRIMARY KEY (id)
);

RAISE NOTICE 'Created tb_user';

-- insert into public.tb_user(firstname, surname, email, username, password, active, authlevel) VALUES('user_firstname', 'user_surname', 'user_email', 'username', '440b8ca73a2dfeadd6849cfb848ad669656590d24d7eb7a50e3dda092e7d4e47', 'active', 1);
insert into public.tb_user(firstname, surname, email, username, password, active, authlevel) VALUES('admin_firstname', 'admin_surname', 'admin_email', 'admin', 'aca1a1c6a87b983c3346f44ba66936000a462f99ac5201c4c5f958046e61a79b', 'active', 1);





CREATE TABLE IF NOT EXISTS public.tb_schedule
(
    id serial NOT NULL,
    name character varying(100),
    chronSequence character varying(100),
    fk_tb_databaseConnections_db_connection_id character varying(100),
    fk_tb_query_id INT,
    lastRunTime timestamp,
    lastRunMessage character varying(500),
    active character varying(100),
    PRIMARY KEY (id)
);

RAISE NOTICE 'Created tb_schedule';


CREATE TABLE IF NOT EXISTS public.tb_tasks
(
    id SERIAL PRIMARY KEY,
    task_name character varying(255)  NOT NULL,
    task_schedule character varying(50) NOT NULL,
    task_file_path text NOT NULL,
    task_os_type character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    task_file_content bytea,
	task_active character varying (20) DEFAULT 'Active'
);

RAISE NOTICE 'Created tb_tasks';



CREATE TABLE IF NOT EXISTS public.tb_content_packs
(
    id SERIAL PRIMARY KEY,
    pack_name character varying(255) NOT NULL,
    version character varying(255) NOT NULL,
	db_type character varying(255) NOT NULL,
	build_date character varying(255),
	build_version character varying(255) NOT NULL,
	description character varying(255) NOT NULL,
	author character varying(255),
	icon character varying(255),
	background_traffic character varying(255),
	pack_info jsonb,
	pack_deployed character varying(5) DEFAULT 'false',
	uploaded_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
	 -- Unique constraint on pack_name + version
    CONSTRAINT unique_pack_version UNIQUE (pack_name, version)
);

RAISE NOTICE 'Created tb_content_packs';

INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed) VALUES (1, 'mysql8.0', 'v1.0', 'mysql', '08-Jul-2025', '139', 'A brief description of the pack contents', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "mysql8.0", "build_date": "08-Jul-2025", "description": "A brief description of the pack contents", "build_version": "139", "background_traffic": "yes"}', 'false');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed) VALUES (2, 'db2', 'v1.0', 'db2', '08-Jul-2025', '139', 'A brief description of the pack contents', 'Official', 'my2sql.png', 'yes', '{"icon": "my2sql.png", "author": "Official", "db_type": "db2", "version": "v1.0", "pack_name": "db2", "build_date": "08-Jul-2025", "description": "A brief description of the pack contents", "build_version": "139", "background_traffic": "yes"}', 'false');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed) VALUES (3, 'oracle', 'v1.0', 'oracle', '08-Jul-2025', '139', 'A brief description of the pack contents', 'Official', 'oracle.png', 'yes', '{"icon": "oracle.png", "author": "Official", "db_type": "oracle", "version": "v1.0", "pack_name": "oracle", "build_date": "08-Jul-2025", "description": "A brief description of the pack contents", "build_version": "139", "background_traffic": "yes"}', 'false');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed) VALUES (4, 'postgres', 'v1.0', 'postgres', '08-Jul-2025', '139', 'A brief description of the pack contents', 'Official', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Official", "db_type": "postgres", "version": "v1.0", "pack_name": "postgres", "build_date": "08-Jul-2025", "description": "A brief description of the pack contents", "build_version": "139", "background_traffic": "yes"}', 'false');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed) VALUES (5, 'sqlserver', 'v1.0', 'sqlserver', '01-Sept-2025', '139', 'A brief description of the pack contents', 'Official', 'sqlserver.png', 'yes', '{"icon": "sqlserver.png", "author": "Official", "db_type": "sqlserver", "version": "v1.0", "pack_name": "sqlserver", "build_date": "01-Sept-2025", "description": "A brief description of the pack contents", "build_version": "139", "background_traffic": "yes"}', 'false');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (11, 'outlier_massive_grant_case', 'v1.0', 'mysql', '11-Feb-2026', '144', 'Detects massive GRANT anomalies indicating privilege escalation attacks. Simulates 4 hours baseline (1 GRANT/hour) followed by spike (21 simultaneous GRANTs) to identify privilege abuse patterns.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_massive_grant_case", "build_date": "11-Feb-2026", "description": "Detects massive GRANT anomalies for privilege escalation", "build_version": "144", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (8, 'outlier_update_anomaly', 'v1.0', 'mysql', '11-Feb-2026', '141', 'Detects UPDATE anomalies indicating data manipulation attacks. Simulates 4 hours baseline (50 UPDATEs/hour) followed by massive spike (1000 UPDATEs) to identify bulk data modification attempts.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_update_anomaly", "build_date": "11-Feb-2026", "description": "Detects UPDATE anomalies indicating data manipulation", "build_version": "141", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (9, 'outlier_insert_anomaly', 'v1.0', 'mysql', '11-Feb-2026', '142', 'Detects INSERT anomalies indicating data injection attacks. Simulates 4 hours baseline (50 INSERTs/hour) followed by massive spike (1000 INSERTs) to identify bulk data insertion attempts.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_insert_anomaly", "build_date": "11-Feb-2026", "description": "Detects INSERT anomalies indicating data injection", "build_version": "142", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (10, 'outlier_revoke_anomaly', 'v1.0', 'mysql', '11-Feb-2026', '143', 'Detects REVOKE anomalies indicating privilege removal attacks. Simulates 4 hours baseline (50 REVOKEs/hour) followed by massive spike (1000 REVOKEs) to identify bulk privilege stripping attempts.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_revoke_anomaly", "build_date": "11-Feb-2026", "description": "Detects REVOKE anomalies indicating privilege removal", "build_version": "143", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (12, 'outlier_data_leak_command', 'v1.0', 'mysql', '11-Feb-2026', '145', 'Detects data exfiltration through SELECT anomalies. Simulates 4 hours baseline (50 SELECTs/hour) followed by massive spike (1000 SELECTs) to identify data leak attempts and unauthorized data access.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_data_leak_command", "build_date": "11-Feb-2026", "description": "Detects data exfiltration through SELECT anomalies", "build_version": "145", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (13, 'outlier_account_take_over', 'v1.0', 'mysql', '11-Feb-2026', '146', 'Detects account takeover through object access pattern changes. Simulates 4 hours accessing 1 object (50 SELECTs/hour) followed by sudden access to all 5 objects (250 SELECTs) indicating compromised credentials.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_account_take_over", "build_date": "11-Feb-2026", "description": "Detects account takeover through access pattern changes", "build_version": "146", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (14, 'outlier_denial_of_service', 'v1.0', 'mysql', '11-Feb-2026', '147', 'Detects Denial of Service attacks through query volume anomalies. Simulates 4 hours baseline (1001 queries/hour) followed by massive spike (205000 queries) to identify resource exhaustion attacks.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_denial_of_service", "build_date": "11-Feb-2026", "description": "Detects DoS attacks through query volume anomalies", "build_version": "147", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (6, 'outlier_schema_tampering', 'v1.0', 'mysql', '11-Feb-2026', '139', 'A brief description of the pack contents', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_schema_tampering", "build_date": "10-Feb-2026", "description": "A brief description of the pack contents", "build_version": "139", "background_traffic": "yes"}', 'false', '2026-02-11 12:53:50.323099');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (7, 'outlier_data_tampering', 'v1.0', 'mysql', '11-Feb-2026', '140', 'Detects data tampering through DELETE anomalies. Simulates 4 hours baseline (50 DELETEs/hour) followed by massive spike (1000 DELETEs) to identify unauthorized data destruction.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_data_tampering", "build_date": "11-Feb-2026", "description": "Detects data tampering through DELETE anomalies", "build_version": "140", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');

-- PostgreSQL Outlier Content Packs
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (15, 'outlier_account_take_over_postgres', 'v1.0', 'postgres', '23-Feb-2026', '150', 'PostgreSQL Account Takeover Detection - Simulates normal access pattern (50 SELECTs on object1 for 4 hours) followed by sudden access to all 5 objects (250 SELECTs) to detect account takeover attacks', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_account_take_over_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Account Takeover Detection", "build_version": "150", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (16, 'outlier_data_leak_command_postgres', 'v1.0', 'postgres', '23-Feb-2026', '151', 'PostgreSQL Data Leak Detection - Detects data exfiltration through SELECT anomalies. Simulates 4 hours baseline (50 SELECTs/hour) followed by massive spike (1000 SELECTs) to identify data leak attempts', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_data_leak_command_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Data Leak Detection", "build_version": "151", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (17, 'outlier_data_tampering_postgres', 'v1.0', 'postgres', '23-Feb-2026', '152', 'PostgreSQL Data Tampering Detection - Detects data tampering through DELETE anomalies. Simulates 4 hours baseline (50 DELETEs/hour) followed by massive spike (1000 DELETEs) to identify unauthorized data destruction', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_data_tampering_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Data Tampering Detection", "build_version": "152", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (18, 'outlier_denial_of_service_postgres', 'v1.0', 'postgres', '23-Feb-2026', '153', 'PostgreSQL Denial of Service Detection - Detects DoS attacks through query volume anomalies. Simulates 4 hours baseline (1001 queries/hour) followed by massive spike (205000 queries) to identify resource exhaustion attacks', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_denial_of_service_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL DoS Detection", "build_version": "153", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (19, 'outlier_insert_anomaly_postgres', 'v1.0', 'postgres', '23-Feb-2026', '154', 'PostgreSQL Insert Anomaly Detection - Detects INSERT anomalies indicating data injection attacks. Simulates 4 hours baseline (50 INSERTs/hour) followed by massive spike (1000 INSERTs) to identify bulk data insertion attempts', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_insert_anomaly_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Insert Anomaly Detection", "build_version": "154", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (20, 'outlier_massive_grant_case_postgres', 'v1.0', 'postgres', '23-Feb-2026', '155', 'PostgreSQL Massive Grant Detection - Detects massive GRANT anomalies indicating privilege escalation attacks. Simulates 4 hours baseline (1 GRANT/hour) followed by spike (21 simultaneous GRANTs) to identify privilege abuse patterns', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_massive_grant_case_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Massive Grant Detection", "build_version": "155", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (21, 'outlier_revoke_anomaly_postgres', 'v1.0', 'postgres', '23-Feb-2026', '156', 'PostgreSQL Revoke Anomaly Detection - Detects REVOKE anomalies indicating privilege removal attacks. Simulates 4 hours baseline (50 REVOKEs/hour) followed by massive spike (1000 REVOKEs) to identify bulk privilege stripping attempts', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_revoke_anomaly_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Revoke Anomaly Detection", "build_version": "156", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (22, 'outlier_schema_tampering_postgres', 'v1.0', 'postgres', '23-Feb-2026', '157', 'PostgreSQL Schema Tampering Detection - Detects unauthorized schema modifications through DDL anomalies. Monitors CREATE, ALTER, DROP operations to identify schema manipulation attempts', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_schema_tampering_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Schema Tampering Detection", "build_version": "157", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (23, 'outlier_update_anomaly_postgres', 'v1.0', 'postgres', '23-Feb-2026', '158', 'PostgreSQL Update Anomaly Detection - Detects UPDATE anomalies indicating data manipulation attacks. Simulates 4 hours baseline (50 UPDATEs/hour) followed by massive spike (1000 UPDATEs) to identify bulk data modification attempts', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_update_anomaly_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Update Anomaly Detection", "build_version": "158", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP);


ALTER SEQUENCE public.tb_content_packs_id_seq RESTART WITH 24;


/************************************************************************************/
CREATE TABLE IF NOT EXISTS public.tb_databaseconnections
(
    id serial NOT NULL,
	db_connection_id character varying(100) NOT NULL UNIQUE,
    status character varying(100),
    db_type character varying(100) NOT NULL,
    db_version character varying(100),
    db_username character varying(100) NOT NULL,
    db_password character varying(100) NOT NULL,
   	db_port character varying(100),
    db_database character varying(100) NOT NULL,
    db_url character varying(100) NOT NULL,
   	db_jdbcClassName character varying(100),
    db_userIcon character varying(100),
   	db_databaseIcon character varying(100),
   	db_alias character varying(500),
   	db_access character varying(500),
    PRIMARY KEY (id)
);


TRUNCATE TABLE public.tb_databaseconnections;

ALTER SEQUENCE tb_databaseconnections_id_seq RESTART WITH 1;
INSERT INTO public.tb_databaseconnections (id, db_connection_id, status, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcclassname, db_usericon, db_databaseicon, db_alias, db_access) VALUES (1, 'postgresql_127.0.0.1_crm_john', 'active', 'postgresql', '14', 'john', 'Password1!', '5432', 'crm', '127.0.0.1', 'org.postgresql.Driver', '', '', 'Standard User', 'Select,Update,Insert,Delete,Usage');
INSERT INTO public.tb_databaseconnections (id, db_connection_id, status, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcclassname, db_usericon, db_databaseicon, db_alias, db_access) VALUES (2, 'postgresql_127.0.0.1_crm_jason', 'active', 'postgresql', '14', 'jason', 'Password1!', '5432', 'crm', '127.0.0.1', 'org.postgresql.Driver', '', '', 'Standard User', 'Select,Update,Insert,Delete,Usage');
INSERT INTO public.tb_databaseconnections (id, db_connection_id, status, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcclassname, db_usericon, db_databaseicon, db_alias, db_access) VALUES (3, 'postgresql_127.0.0.1_crm_liher', 'active', 'postgresql', '14', 'liher', 'Password1!', '5432', 'crm', '127.0.0.1', 'org.postgresql.Driver', '', '', 'Badguy', 'Superuser');
INSERT INTO public.tb_databaseconnections (id, db_connection_id, status, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcclassname, db_usericon, db_databaseicon, db_alias, db_access) VALUES (4, 'postgresql_127.0.0.1_crm_polly', 'active', 'postgresql', '14', 'polly', 'Password1!', '5432', 'crm', '127.0.0.1', 'org.postgresql.Driver', '', '', 'DB Admin', 'Superuser');
INSERT INTO public.tb_databaseconnections (id, db_connection_id, status, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcclassname, db_usericon, db_databaseicon, db_alias, db_access) VALUES (5, 'mysql_127.0.0.1_crm_john', 'active', 'mysql', '10', 'john', 'Password1!', '3306', 'crm', '127.0.0.1', 'com.mysql.cj.jdbc.Driver', '', '', 'Standard User', 'Select,Update,Insert,Delete,Execute');
INSERT INTO public.tb_databaseconnections (id, db_connection_id, status, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcclassname, db_usericon, db_databaseicon, db_alias, db_access) VALUES (6, 'mysql_127.0.0.1_crm_jason', 'active', 'mysql', '10', 'jason', 'Password1!', '3306', 'crm', '127.0.0.1', 'com.mysql.cj.jdbc.Driver', '', '', 'Standard User', 'Select,Update,Insert,Delete,Execute');
INSERT INTO public.tb_databaseconnections (id, db_connection_id, status, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcclassname, db_usericon, db_databaseicon, db_alias, db_access) VALUES (7, 'mysql_127.0.0.1_crm_polly', 'active', 'mysql', '10', 'polly', 'Password1!', '3306', 'crm', '127.0.0.1', 'com.mysql.cj.jdbc.Driver', '', '', 'DB Admin', 'All Privileges');
INSERT INTO public.tb_databaseconnections (id, db_connection_id, status, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcclassname, db_usericon, db_databaseicon, db_alias, db_access) VALUES (8, 'mysql_127.0.0.1_crm_liher', 'active', 'mysql', '10', 'liher', 'Password1!', '3306', 'crm', '127.0.0.1', 'com.mysql.cj.jdbc.Driver', '', '', 'Badguy', 'All Privileges');


ALTER SEQUENCE tb_databaseconnections_id_seq RESTART WITH 5000;
ALTER SEQUENCE tb_stories_id_seq RESTART WITH 5000;


/************************************************************************************/
CREATE TABLE IF NOT EXISTS public.tb_admin_functions
(
    id SERIAL PRIMARY KEY,
    function_name character varying(255)  NOT NULL,
    function_description character varying(255)  NOT NULL,
    function_script character varying(50) NOT NULL,
    function_api_call character varying(50) NOT NULL,
    function_file_path text NOT NULL,
    function_os_type character varying(255) NOT NULL,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
	task_active character varying (20) DEFAULT 'Active'
);

RAISE NOTICE 'Created tb_admin_functions';


INSERT INTO public.tb_admin_functions (id,function_name,function_description,function_script,function_api_call,function_file_path,function_os_type) VALUES (1,'Restart SLP system','This function call will restart the SLP application. This should only be utilised in cases of emergency where the application hangs.','restartSLP.sh','getRestartSLP()','/opt/slp/scripts','Linux');
ALTER SEQUENCE tb_admin_functions_id_seq RESTART WITH 2;

/************************************************************************************/

CREATE TABLE IF NOT EXISTS public.tb_query
(
    id serial NOT NULL,
	fk_tb_databaseConnections_id INT,
	query_db_type character varying(100),
	query_string  TEXT NOT NULL, 
	query_usecase character varying(100),
    query_type character varying(100),
    query_description character varying(500),
    video_link character varying(500),
	query_loop INT,
    /*FOREIGN KEY (fk_tb_databaseConnections_id) REFERENCES tb_databaseConnections (id),*/
	PRIMARY KEY (id)
);

ALTER SEQUENCE tb_query_id_seq RESTART WITH 5000;

RAISE NOTICE 'Created tb_query';
/*****************************************************************/

CREATE TABLE IF NOT EXISTS public.tb_query_types
(
    id serial NOT NULL,
	query_type character varying(100),
    PRIMARY KEY (id)
);
ALTER SEQUENCE tb_query_types_id_seq RESTART WITH 5000;

	INSERT INTO public.tb_query_types(id,query_type) VALUES (1,'Select');
	INSERT INTO public.tb_query_types(id,query_type) VALUES (2,'Update');
	INSERT INTO public.tb_query_types(id,query_type) VALUES (3,'Delete'); 
	INSERT INTO public.tb_query_types(id,query_type) VALUES (4,'Insert');
	INSERT INTO public.tb_query_types(id,query_type) VALUES (5,'Drop'); 
	INSERT INTO public.tb_query_types(id,query_type) VALUES (6,'Outlier');
	INSERT INTO public.tb_query_types(id,query_type) VALUES (7,'Malicious Procedure');
	INSERT INTO public.tb_query_types(id,query_type) VALUES (8,'Policy Violation');
	INSERT INTO public.tb_query_types(id,query_type) VALUES (9,'Eagle Eye');
	INSERT INTO public.tb_query_types (id,query_type) VALUES (10,'Setup');
	INSERT INTO public.tb_query_types (id, query_type) VALUES (11, 'New Grants');
	INSERT INTO public.tb_query_types (id, query_type) VALUES (12, 'Brute-force Attack');
	INSERT INTO public.tb_query_types (id, query_type) VALUES (13, 'SQL Injection');
	INSERT INTO public.tb_query_types (id, query_type) VALUES (14, 'DDL');
	INSERT INTO public.tb_query_types (id, query_type) VALUES (15, 'DML');
	INSERT INTO public.tb_query_types (id, query_type) VALUES (16, 'DQL');
	INSERT INTO public.tb_query_types (id, query_type) VALUES (17, 'DCL');
	INSERT INTO public.tb_query_types (id, query_type) VALUES (18, 'Massive Grants');
	

ALTER DATABASE slp SET idle_in_transaction_session_timeout = '1min';	
	
END;$$;	


CREATE FUNCTION function_login(var_username TEXT, var_password TEXT)
returns table (
		id integer,
        firstname varchar,
        surname varchar,
        email varchar,
        username varchar,
        active varchar,
		authlevel integer
        
	)
    AS $$ 

    BEGIN
    RAISE NOTICE 'Username:  % Password: %' , var_username, var_password;
    
   	return query 
        select
		    tb_user.id,
            tb_user.firstname,
            tb_user.surname,
            tb_user.email,
            tb_user.username,
            tb_user.active,
		    tb_user.authlevel
		from
			tb_user
        where tb_user.username = var_username AND tb_user.password = var_password;
END
$$  LANGUAGE plpgsql;




-- Outliers and Attack Library Database Tables
-- Author: Jason Flood/John Clarke
-- This script adds database persistence for Outliers scripts and Attack Library patterns

-- ============================================
-- OUTLIERS TABLES
-- ============================================

-- Main table for outlier scripts
CREATE TABLE IF NOT EXISTS public.tb_outlier_scripts
(
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    script_type VARCHAR(50) NOT NULL, -- 'bash' or 'windows'
    file_path TEXT NOT NULL,
    original_file_name VARCHAR(255),
    file_size BIGINT,
    uploaded_by VARCHAR(100),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN DEFAULT false,
    last_executed TIMESTAMP,
    last_execution_status VARCHAR(255),
    folder_path TEXT,
    readme_content TEXT,
    related_files JSONB, -- Array of related file names
    tags JSONB, -- Array of tags
    package_id VARCHAR(100), -- Package identifier for grouping scripts from same ZIP
    package_name VARCHAR(255), -- Human-readable package name
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for script schedules (multiple schedules per script)
CREATE TABLE IF NOT EXISTS public.tb_outlier_schedules
(
    schedule_id VARCHAR(100) PRIMARY KEY,
    script_id VARCHAR(100) NOT NULL REFERENCES public.tb_outlier_scripts(id) ON DELETE CASCADE,
    cron_expression VARCHAR(100) NOT NULL,
    parameters TEXT,
    enabled BOOLEAN DEFAULT true,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_outlier_schedules_script_id ON public.tb_outlier_schedules(script_id);
CREATE INDEX IF NOT EXISTS idx_outlier_scripts_enabled ON public.tb_outlier_scripts(enabled);
CREATE INDEX IF NOT EXISTS idx_outlier_scripts_type ON public.tb_outlier_scripts(script_type);

-- ============================================
-- ATTACK LIBRARY TABLES
-- ============================================

-- Main table for attack patterns
CREATE TABLE IF NOT EXISTS public.tb_attack_patterns
(
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT,
    severity VARCHAR(50), -- 'CRITICAL', 'HIGH', 'MEDIUM', 'LOW'
    attack_type VARCHAR(100),
    mitigation TEXT,
    target_databases JSONB, -- Array of database types: ['mysql', 'postgresql', etc.]
    example_queries JSONB, -- Array of example SQL queries
    tags JSONB, -- Array of tags for categorization
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster searches
CREATE INDEX IF NOT EXISTS idx_attack_patterns_category ON public.tb_attack_patterns(category);
CREATE INDEX IF NOT EXISTS idx_attack_patterns_severity ON public.tb_attack_patterns(severity);
CREATE INDEX IF NOT EXISTS idx_attack_patterns_type ON public.tb_attack_patterns(attack_type);

-- ============================================
-- TRIGGER FUNCTIONS FOR UPDATED_AT
-- ============================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for outlier scripts
DROP TRIGGER IF EXISTS update_outlier_scripts_updated_at ON public.tb_outlier_scripts;
CREATE TRIGGER update_outlier_scripts_updated_at
    BEFORE UPDATE ON public.tb_outlier_scripts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Triggers for outlier schedules
DROP TRIGGER IF EXISTS update_outlier_schedules_updated_at ON public.tb_outlier_schedules;
CREATE TRIGGER update_outlier_schedules_updated_at
    BEFORE UPDATE ON public.tb_outlier_schedules
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Triggers for attack patterns
DROP TRIGGER IF EXISTS update_attack_patterns_updated_at ON public.tb_attack_patterns;
CREATE TRIGGER update_attack_patterns_updated_at
    BEFORE UPDATE ON public.tb_attack_patterns
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================

-- Insert a sample attack pattern
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'sqli-union-001',
    'Union-Based SQL Injection',
    'SQL Injection',
    'Attempts to extract data using UNION SELECT statements to combine results from multiple queries',
    'CRITICAL',
    'SQL_INJECTION_UNION',
    'Use parameterized queries, input validation, and least privilege database accounts',
    '["mysql", "postgresql", "db2", "sqlserver"]'::jsonb,
    '["SELECT * FROM crm.tbl_crm_accounts WHERE account_id = 1 UNION SELECT username, password, email, phone, NULL, NULL, NULL, NULL FROM crm.tbl_users"]'::jsonb,
    '["sqli", "union", "data-extraction", "owasp-top10"]'::jsonb
)
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- VIEWS FOR EASIER QUERYING
-- ============================================

-- View to get scripts with their schedules
CREATE OR REPLACE VIEW v_outlier_scripts_with_schedules AS
SELECT 
    s.id,
    s.name,
    s.description,
    s.script_type,
    s.enabled,
    s.uploaded_by,
    s.uploaded_at,
    s.last_executed,
    s.last_execution_status,
    COUNT(sch.schedule_id) as schedule_count,
    COUNT(CASE WHEN sch.enabled = true THEN 1 END) as enabled_schedule_count,
    json_agg(
        json_build_object(
            'schedule_id', sch.schedule_id,
            'cron_expression', sch.cron_expression,
            'parameters', sch.parameters,
            'enabled', sch.enabled,
            'description', sch.description
        ) ORDER BY sch.created_at
    ) FILTER (WHERE sch.schedule_id IS NOT NULL) as schedules
FROM public.tb_outlier_scripts s
LEFT JOIN public.tb_outlier_schedules sch ON s.id = sch.script_id
GROUP BY s.id, s.name, s.description, s.script_type, s.enabled, s.uploaded_by, 
         s.uploaded_at, s.last_executed, s.last_execution_status;

-- View for attack patterns by category
CREATE OR REPLACE VIEW v_attack_patterns_by_category AS
SELECT 
    category,
    COUNT(*) as pattern_count,
    json_agg(
        json_build_object(
            'id', id,
            'name', name,
            'severity', severity,
            'attack_type', attack_type
        ) ORDER BY severity DESC, name
    ) as patterns
FROM public.tb_attack_patterns
GROUP BY category;

-- ============================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================

COMMENT ON TABLE public.tb_outlier_scripts IS 'Stores metadata for uploaded outlier scripts that can be scheduled';
COMMENT ON TABLE public.tb_outlier_schedules IS 'Stores multiple schedules for each outlier script';
COMMENT ON TABLE public.tb_attack_patterns IS 'Stores pre-built attack pattern templates for the attack library';

COMMENT ON COLUMN public.tb_outlier_scripts.script_type IS 'Type of script: bash (.sh) or windows (.bat, .cmd, .ps1)';
COMMENT ON COLUMN public.tb_outlier_scripts.related_files IS 'JSONB array of related file names (SQL, README, etc.)';
COMMENT ON COLUMN public.tb_outlier_schedules.cron_expression IS 'Cron expression for scheduling (e.g., "0 0 * * *")';
COMMENT ON COLUMN public.tb_attack_patterns.target_databases IS 'JSONB array of compatible database types';
COMMENT ON COLUMN public.tb_attack_patterns.example_queries IS 'JSONB array of example attack queries';

-- Success message
DO $$
BEGIN
    RAISE NOTICE 'Outliers and Attack Library tables created successfully!';
    RAISE NOTICE 'Tables: tb_outlier_scripts, tb_outlier_schedules, tb_attack_patterns';
    RAISE NOTICE 'Views: v_outlier_scripts_with_schedules, v_attack_patterns_by_category';
END $$;

