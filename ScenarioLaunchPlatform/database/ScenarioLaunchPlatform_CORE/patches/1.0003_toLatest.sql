ALTER TABLE tb_query
ADD COLUMN video_link character varying(500);
UPDATE public.tb_version SET version = 'v01.0003';
