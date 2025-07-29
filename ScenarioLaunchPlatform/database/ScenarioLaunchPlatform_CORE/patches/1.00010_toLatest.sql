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
UPDATE public.tb_version SET version = 'v01.0011';