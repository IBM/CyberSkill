-- This script was created by Jason Flood.
DO $$
BEGIN

--RAISE NOTICE 'Dropping existing tables with cascade!';
-- drop table if exists public.tb_stories CASCADE;
-- drop table if exists public.tb_version CASCADE;

--RAISE NOTICE 'All tables and functions dropped!';

/*Patch to add the Stories Table*/
CREATE TABLE IF NOT EXISTS public.tb_stories
(
	id serial NOT NULL,
	runTime timestamp default current_timestamp,
	story JSONB,
	PRIMARY KEY (id)
);

RAISE NOTICE 'Created tb_stories';

/*Patch to add the database schema version table*/
CREATE TABLE IF NOT EXISTS public.tb_version
(
    version character varying(100)
);

insert into public.tb_version(version) VALUES('v01.0000');


/* Patch complete - update the database to the new version */
UPDATE public.tb_version SET version = 'v01.0001';

END
$$  LANGUAGE plpgsql;