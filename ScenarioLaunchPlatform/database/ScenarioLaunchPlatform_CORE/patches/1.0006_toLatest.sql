-- 1.0007 changes --
CREATE TABLE tb_myvars (id SERIAL PRIMARY KEY, username VARCHAR(255), data JSONB);

INSERT INTO tb_myvars (username, data) VALUES ('admin','{"my_var1": 1, "my_var2": "simpleString1"}');
INSERT INTO tb_myvars (username, data) VALUES ('username','{"my_var1": 2, "my_var2": "simpleString2"}');

UPDATE public.tb_version SET version = 'v01.0007';

