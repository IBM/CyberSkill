DO $$
BEGIN

RAISE NOTICE 'Running patch';

ALTER TABLE tb_databaseconnections
ADD COLUMN db_alias character varying(500);

ALTER TABLE tb_databaseconnections
ADD COLUMN db_access character varying(500);


UPDATE tb_databaseconnections SET db_alias = 'Standard User',db_access = 'Select,Update,Insert,Delete,Execute' where db_type = 'mysql' and db_username = 'JOHN';
UPDATE tb_databaseconnections SET db_alias = 'Standard User',db_access = 'Select,Update,Insert,Delete,Execute' where db_type = 'mysql' and db_username = 'JASON';
UPDATE tb_databaseconnections SET db_alias = 'DB Admin',db_access = 'All Privileges' where db_type = 'mysql' and db_username = 'POLLY';
UPDATE tb_databaseconnections SET db_alias = 'Badguy',db_access = 'All Privileges' where db_type = 'mysql' and db_username = 'LIHER';

UPDATE tb_databaseconnections SET db_alias = 'Standard User',db_access = 'Select,Update,Insert,Delete,Usage' where db_type = 'postgresql' and db_username = 'john';
UPDATE tb_databaseconnections SET db_alias = 'Standard User',db_access = 'Select,Update,Insert,Delete,Usage' where db_type = 'postgresql' and db_username = 'jason';
UPDATE tb_databaseconnections SET db_alias = 'DB Admin',db_access = 'Superuser' where db_type = 'postgresql' and db_username = 'polly';
UPDATE tb_databaseconnections SET db_alias = 'Badguy',db_access = 'Superuser' where db_type = 'postgresql' and db_username = 'liher';



/* Patch complete - update the database to the new version */
UPDATE public.tb_version SET version = 'v01.0004';

END
$$  LANGUAGE plpgsql;