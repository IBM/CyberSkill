-- 1.0007 changes --
CREATE TABLE public.tb_myvars (id SERIAL PRIMARY KEY, username VARCHAR(255) UNIQUE, data JSONB);

INSERT INTO public.tb_myvars (username, data) VALUES ('admin','{"my_var1": 1, "my_var2": "simpleString1"}');
INSERT INTO public.tb_myvars (username, data) VALUES ('username','{"my_var1": 2, "my_var2": "simpleString2"}');

UPDATE public.tb_version SET version = 'v01.0007';

