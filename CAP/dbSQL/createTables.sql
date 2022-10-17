-- Table: claimed

-- Create a database named CAP before running this script
-- Create user  capuser
--
-- Commands:
--
-- dropdb CAP
-- createdb -T template0 -E UTF8 CAP
CREATE DATABASE "CAP" TEMPLATE template0 ENCODING UTF8;
CREATE USER capuser;

DROP TABLE if exists claimed CASCADE;

CREATE TABLE claimed
(
  userid integer,
  levelid integer,
  award character varying(150),
  submitted timestamp,
  id serial NOT NULL,
  CONSTRAINT claimed_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE claimed
  OWNER TO capuser;


-- Table: levels

 DROP  TABLE if exists levels CASCADE;

CREATE TABLE levels
(
  
  directory character varying(400),
  name character varying(400),
  id serial NOT NULL,
  score integer,
  originalScore integer,
  status character varying(400),
  owaspcategory character varying(150),
  sans25category character varying(150),
  CONSTRAINT levels_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE levels
  OWNER TO capuser;
-- Table: scoreboard

--------------
DROP  TABLE if exists scoreboard_breakdown CASCADE;
CREATE TABLE scoreboard_breakdown
(
  id serial NOT NULL,
  fk_level_id integer,
  score integer,
  submitted timestamp,
  username character varying(400),
  CONSTRAINT scoreboard_breakdown_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scoreboard_breakdown
  OWNER TO capuser;
--------------
drop table if exists modulefeedmonitor;

CREATE TABLE modulefeedmonitor
(
  id serial NOT NULL,
  username character varying(400),
  submitted timestamp,
  CONSTRAINT modulefeedmonitor_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE modulefeedmonitor
  OWNER TO capuser;
  
--------------  
  
  DROP TABLE if exists scoreboard CASCADE;

CREATE TABLE scoreboard
(
  id integer,
  score integer,
  username character varying(400),
  submitted timestamp,
  CONSTRAINT scoreboard_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE scoreboard
  OWNER TO capuser;
  
DROP TABLE if exists users CASCADE;

CREATE TABLE users
(
  userid integer,
  id serial NOT NULL,
  username character varying(400),
  password character varying(512),
  compOrganization character varying(128),
  employeeId character varying(128),
  email character varying(128),
  admin boolean default false,
  faction character varying(128),
  geo character varying(400),
  CONSTRAINT users_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE users
  OWNER TO capuser;
  

-- Username: admin@test.com
-- Password: passw0rd!  
INSERT INTO users (username, password, comporganization, employeeid, email, admin)  VALUES ('admin@test.com', 'ce36f6bf7f87caf5135e817761084f6d421e350020de966ed89bb651fd1b33ac', 'admin@test.com', 'admin@test.com', 'admin@test.com', true);
-- Username: test@test.com
-- Password: password
--INSERT INTO users (username, password, comporganization, employeeid, email, admin)  VALUES ('test@test.com', '440b8ca73a2dfeadd6849cfb848ad669656590d24d7eb7a50e3dda092e7d4e47', 'test@test.com', 'test@test.com', 'test@test.com', false);

