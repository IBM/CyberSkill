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



drop FUNCTION if exists function_login(TEXT, TEXT);
RAISE NOTICE 'All tables and functions dropped!';

CREATE TABLE IF NOT EXISTS public.tb_version
(
    version character varying(100)
);
insert into public.tb_version(version) VALUES('v01.0010');

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

ALTER SEQUENCE public.tb_content_packs_id_seq RESTART WITH 5;


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

ALTER SEQUENCE tb_databaseconnections_id_seq RESTART WITH 5000;

/************************************************************************************/


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

