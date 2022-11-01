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
  timeOpened timestamp,
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
  firstname character varying(250) NOT NULL,
  lastname character varying(250) NOT NULL,
  username character varying(400) NOT NULL,
  password character varying(512) NOT NULL,
  compOrganization character varying(128) NOT NULL,
  employeeId character varying(128) NOT NULL,
  email character varying(128) NOT NULL,
  admin boolean default false,
  faction character varying(128)NOT NULL,
  geo character varying(400),
  status character varying(400),
  active boolean default false,
  registered timestamp NOT NULL,
  CONSTRAINT users_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE users
  OWNER TO capuser;
  
DROP TABLE IF EXISTS activity CASCADE;
CREATE TABLE activity 
(
  id serial NOT NULL,
  firstname character varying(250) NOT NULL,
  lastname character varying(250) NOT NULL,
  username character varying(400) NOT NULL,
  compOrganization character varying(128) NOT NULL,
  faction character varying(128)NOT NULL,
  lastlogin timestamp NOT NULL,
  CONSTRAINT activity_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE activity
  OWNER TO capuser;
  
DROP TABLE IF EXISTS admincomments CASCADE;
CREATE TABLE admincomments 
(
  id serial NOT NULL,
  firstname character varying(250) NOT NULL,
  lastname character varying(250) NOT NULL,
  username character varying(400) NOT NULL,
  comment character varying(400) NOT NULL,
  submitted timestamp NOT NULL,
  CONSTRAINT admincomments_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE admincomments
  OWNER TO capuser;
  
  
---------------------TEST DATA----------------------------------------------------------------------------------------------------------
-- Username: admin@test.com
-- Password: passw0rd!  
INSERT INTO users (firstname,lastname,faction,username, password, comporganization, employeeid, email, admin,active,registered)  VALUES ('ad','min','adminators','admin@test.com', 'ce36f6bf7f87caf5135e817761084f6d421e350020de966ed89bb651fd1b33ac', 'admin@test.com', 'admin@test.com', 'admin@test.com', true,true,now());
-- Username: testN@test.com
-- Password: password
INSERT INTO users (firstname,lastname,faction,username, password, comporganization, employeeid, email, admin,active,registered)  VALUES ('test1','user1','testers1','test1@test.com', '440b8ca73a2dfeadd6849cfb848ad669656590d24d7eb7a50e3dda092e7d4e47', 'test1@test.com', 'test1@test.com', 'test1@test.com', false,true,now());
INSERT INTO users (firstname,lastname,faction,username, password, comporganization, employeeid, email, admin,active,registered)  VALUES ('test2','user2','testers1','test2@test.com', '440b8ca73a2dfeadd6849cfb848ad669656590d24d7eb7a50e3dda092e7d4e47', 'test2@test.com', 'test2@test.com', 'test2@test.com', false,true,now());
INSERT INTO users (firstname,lastname,faction,username, password, comporganization, employeeid, email, admin,active,registered)  VALUES ('test3','user3','testers1','test3@test.com', '440b8ca73a2dfeadd6849cfb848ad669656590d24d7eb7a50e3dda092e7d4e47', 'test3@test.com', 'test3@test.com', 'test3@test.com', false,true,now());
INSERT INTO users (firstname,lastname,faction,username, password, comporganization, employeeid, email, admin,active,registered)  VALUES ('test4','user4','testers2','test4@test.com', '440b8ca73a2dfeadd6849cfb848ad669656590d24d7eb7a50e3dda092e7d4e47', 'test4@test.com', 'test4@test.com', 'test4@test.com', false,true,now());
INSERT INTO users (firstname,lastname,faction,username, password, comporganization, employeeid, email, admin,active,registered)  VALUES ('test5','user5','testers2','test5@test.com', '440b8ca73a2dfeadd6849cfb848ad669656590d24d7eb7a50e3dda092e7d4e47', 'test5@test.com', 'test5@test.com', 'test5@test.com', false,true,now());
INSERT INTO users (firstname,lastname,faction,username, password, comporganization, employeeid, email, admin,active,registered)  VALUES ('test6','user6','testers2','test6@test.com', '440b8ca73a2dfeadd6849cfb848ad669656590d24d7eb7a50e3dda092e7d4e47', 'test6@test.com', 'test6@test.com', 'test6@test.com', false,true,now());
INSERT INTO users (firstname,lastname,faction,username, password, comporganization, employeeid, email, admin,active,registered)  VALUES ('test7','user7','testers3','test7@test.com', '440b8ca73a2dfeadd6849cfb848ad669656590d24d7eb7a50e3dda092e7d4e47', 'test7@test.com', 'test7@test.com', 'test7@test.com', false,true,now());
INSERT INTO users (firstname,lastname,faction,username, password, comporganization, employeeid, email, admin,active,registered)  VALUES ('test8','user8','testers3','test8@test.com', '440b8ca73a2dfeadd6849cfb848ad669656590d24d7eb7a50e3dda092e7d4e47', 'test8@test.com', 'test8@test.com', 'test8@test.com', false,true,now());
INSERT INTO users (firstname,lastname,faction,username, password, comporganization, employeeid, email, admin,active,registered)  VALUES ('test9','user9','testers3','test9@test.com', '440b8ca73a2dfeadd6849cfb848ad669656590d24d7eb7a50e3dda092e7d4e47', 'test9@test.com', 'test9@test.com', 'test9@test.com', false,true,now());




