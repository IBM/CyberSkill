-- This script was created by Jason Flood.
DO $$
BEGIN

RAISE NOTICE 'Running patch';

ALTER TABLE tb_query
ADD COLUMN video_link character varying(500);

/* Patch complete - update the database to the new version */
UPDATE public.tb_version SET version = 'v01.0003';

END
$$  LANGUAGE plpgsql;