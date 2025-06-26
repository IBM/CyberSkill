-- 1.00010 changes --


CREATE TABLE IF NOT EXISTS public.tb_content_packs
(
    id SERIAL PRIMARY KEY,
    pack_name character varying(255),
    version character varying(255),
	db_type character varying(255),
	build_date character varying(255),
	build_version character varying(255),
	description character varying(255),
	author character varying(255),
	icon character varying(255),
	background_traffic character varying(255),
    pack_file_content bytea,
	pack_info jsonb,
	pack_deployed character varying(5) DEFAULT 'false',
	uploaded_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


UPDATE public.tb_version SET version = 'v01.0010';