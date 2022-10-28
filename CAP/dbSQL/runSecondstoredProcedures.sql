 CREATE OR REPLACE FUNCTION submitUserSolution(usernameIN character varying,levelName character varying)
  RETURNS boolean AS
$BODY$
    DECLARE
    claimedResult RECORD;
    useridIN integer;
    userScore integer;
    currentLevelScore integer;
    totalScore integer;
    decrementLevelScore integer;
    newLevelScore integer;
    levelidIN integer;
    originalLevelScoreIN integer;
    
    BEGIN
    userScore=0;
    currentLevelScore=0;
    totalScore=0;
    decrementLevelScore=1;
    newLevelScore=0;
    levelidIN=0;
    originalLevelScoreIN = 0;
    
    SELECT id INTO levelidIN FROM levels where name = levelName;
    SELECT originalScore INTO originalLevelScoreIN FROM levels where name = levelName;
    SELECT id into useridIN FROM scoreboard where username = usernameIN;
    if useridIN IS NULL THEN
	SELECT id into useridIN FROM users where lower(email) = usernameIN;
	INSERT INTO scoreboard(id,score,username,submitted) VALUES (useridIN,0,usernameIN, now());
	raise notice 'This person does not exist on the scoreboard. Adding them';
	raise notice 'Querry: INSERT INTO scoreboard(id,score,username, submitted) VALUES (%,%,%,%);',useridIN,0,usernameIN,now();
	--SELECT id into useridIN FROM scoreboard where username = usernameIN;
    END IF;
	
    
    SELECT * into claimedResult FROM claimed WHERE userid = useridIN AND levelid = levelidIN;
    if claimedResult IS NULL THEN
	SELECT score into currentLevelScore from levels where id = levelidIN;
	raise notice 'This person has not claimed this level already (%)', useridIN;
	--if the currentLevelScore is 60, do not decrement
	if currentLevelScore =60 THEN
		decrementLevelScore=0;
	END IF;
	-- Update the scoreboard history table
	INSERT into scoreboard_breakdown( fk_level_id,score,username, submitted) values (levelidIN,currentLevelScore,usernameIN, now());
	
	
	-- get the users current score
	raise notice 'Querry: SELECT score into userScore FROM scoreboard where id = (%);', useridIN;
	SELECT score into userScore FROM scoreboard where id = useridIN;
	raise notice 'Current user score: (%)', userScore;
	-- add level score to users current score
	totalScore=userScore+currentLevelScore;
	raise notice 'User score with new challenge: (%)', totalScore;
	-- calculate the levels new score
	newLevelScore=currentLevelScore-decrementLevelScore;
	raise notice 'Addition of the decrementor means:(%) ', newLevelScore;

	raise notice 'Querry: update scoreboard SET score = (%)  WHERE id = (%);', totalScore, useridIN;
	update scoreboard SET score = totalScore WHERE id = useridIN; 

	raise notice 'Querry: update levels SET score = (%)  WHERE id = (%);', newLevelScore, levelidIN;

	update levels SET score = newLevelScore WHERE id = levelidIN;
	
	-- update claimed to reflect this change
	INSERT INTO claimed VALUES (useridIN,levelidIN);
		IF currentLevelScore = originalLevelScoreIN then
			--add a gold badge to claimed
			update claimed SET award = 'gold' where userid = useridIN and levelid = LevelidIN;
		end IF;	
		IF currentLevelScore = originalLevelScoreIN -1 then
			--add a silver badge to claimed
			update claimed SET award = 'silver' where userid = useridIN and levelid = LevelidIN;
		end IF;	
		IF currentLevelScore = originalLevelScoreIN -2 then
			--add a bronze badge to claimed
			update claimed SET award = 'bronze' where userid = useridIN and levelid = LevelidIN;
		end IF;	
	
    ELSE
	RETURN false;
    END IF;
    RETURN true;
    END;
$BODY$
  LANGUAGE plpgsql;

------------------ 

 CREATE OR REPLACE FUNCTION allLevels()
RETURNS TABLE(id integer, level_name character varying,sans_cateogory character varying, status character varying, originalscore integer,timeopened timestamp) 
AS $$
BEGIN
 RETURN QUERY SELECT 
 	  levels.id as id,
	  levels.name as name,
	  levels.sans25category as category,
	  levels.status as status,
	  levels.originalscore as originalscore,
	  levels.timeopened as timeopened
	FROM 
	  public.levels
	ORDER BY
	  originalscore ASC, name ASC;
END; $$

LANGUAGE plpgsql;
 
------------------

 CREATE OR REPLACE FUNCTION allOpenLevels()
RETURNS TABLE(id integer, level_name character varying,sans_cateogory character varying, status character varying, originalscore integer,timeopened timestamp) 
AS $$
BEGIN
 RETURN QUERY SELECT 
 	  levels.id as id,
	  levels.name as name,
	  levels.sans25category as category,
	  levels.status as status,
	  levels.originalscore as originalscore,
	  levels.timeopened as timeopened
	FROM 
	  public.levels
	WHERE
	  levels.status = 'enabled'
	 AND
	 levels.timeopened is NOT NULL
	ORDER BY
	  originalscore ASC, name ASC;
END; $$

LANGUAGE plpgsql;
 
------------------


 CREATE OR REPLACE FUNCTION toggleLevel(levelName character varying)
RETURNS SETOF boolean AS
$$
DECLARE
	dbstatus character varying(25);
	timeopened date;
BEGIN
	SELECT status into dbstatus FROM levels where name = levelName;
	if dbstatus = 'enabled' THEN
		update levels SET status = 'disabled' where lower(name) = lower(levelName);
	else
		update levels SET timeopened = now(),status = 'enabled' where lower(name) = lower(levelName);
	end if;
END; $$

LANGUAGE plpgsql;


  -------------------------------- addOrModifyLevel() 
CREATE OR REPLACE FUNCTION addOrModifyLevel(directory character varying, levelName character varying,ScoreIN Integer, owaspCategoryIn character varying, sans25CategoryIn character varying, StatusIn character varying)
  RETURNS SETOF boolean AS
$BODY$
DECLARE
   
    levelidIN integer;

 BEGIN
	SELECT id into levelidIN FROM levels where Name = levelName;
	if levelidIN IS NULL THEN	
	insert into levels(directory, name, score, originalScore, owaspcategory, sans25category, status) VALUES (directory, levelName,ScoreIN,ScoreIN, owaspCategoryIn,sans25CategoryIn,StatusIn); 
	else
		if statusIn='disabled' THEN
			update levels SET status = StatusIn where lower(Name) = lower(levelName);
		else
			update levels SET score = ScoreIN, status = StatusIn where lower(Name) = lower(levelName);
		end if;
	end if;
 END;
$BODY$
 LANGUAGE plpgsql;
 -------------------------------- retrievescoreboard() 
CREATE OR REPLACE FUNCTION retrievescoreboard()
  RETURNS SETOF scoreboard AS
$BODY$
 BEGIN
	RETURN QUERY EXECUTE 'SELECT * FROM scoreboard';
 END;
$BODY$
 LANGUAGE plpgsql;
-------------------------------- myCurrentProgress() 

CREATE OR REPLACE FUNCTION myCurrentProgress(usernameIN character varying)
  RETURNS TABLE(rank_var int, numberOfGolds int,numberOfSilvers int, numberOfBronze int, totalpoints int) AS
$$
    DECLARE

	userId_var int;
	numberOfGolds_var int;
	numberOfSilvers_var int;
	numberOfBronze_var int;
	totalpoints_var int;
	rank_var int;
	
    BEGIN
	userId_var =0;
	numberOfGolds_var =0;
	numberOfSilvers_var =0;
	numberOfBronze_var =0;
	totalpoints_var =0;
	rank_var = 23;
	
	SELECT id into userId_var FROM users where lower(users.email) = usernameIN;
	SELECT COUNT(award) into numberOfGolds_var from claimed where award = 'gold' and claimed.userid = userId_var;
	SELECT COUNT(award) into numberOfSilvers_var from claimed where award = 'silver' and claimed.userid = userId_var;
	SELECT COUNT(award) into numberOfBronze_var from claimed where award = 'bronze' and claimed.userid = userId_var;
	SELECT scoreboard.score INTO totalpoints_var FROM public.scoreboard where scoreboard.username=usernameIN;

	-- Calcualate the RANK of the person in the DATABASE
	SELECT rank INTO rank_var FROM(SELECT scoreboard.score, scoreboard.username, RANK()OVER(ORDER BY score DESC) FROM public.scoreboard) AS FOO WHERE username=usernameIN;


	RETURN QUERY SELECT rank_var,numberOfGolds_var,numberOfSilvers_var,numberOfBronze_var,totalpoints_var;
    
    END;
$$
 LANGUAGE plpgsql;
 
--drop function myEnabledModuleProgress(character varying);
-------------------------------- myEnabledModuleProgress() 
CREATE OR REPLACE FUNCTION myEnabledModuleProgress(usernameIN character varying)
RETURNS TABLE(module_name character varying, module_directory character varying, module_cateogory character varying, module_status character varying, module_score_value int, module_difficulty int,module_award_gold int,module_award_silver int,module_award_bronze int) AS
$$
    DECLARE
	arow record;
	userId_var integer;
	module_name_var character varying (150);
	module_directory_var character varying (150);
	module_cateogory_var character varying (150);
	module_status_var character varying (150);
	module_complete_var integer;
	module_score_value_var integer;
	module_difficulty_var integer;
	module_award_gold_var integer;
	module_award_silver_var integer;
	module_award_bronze_var integer;
	var_award_temp character varying (150);
	var_levelid integer;
	
   BEGIN
	var_award_temp ='';
	module_name_var = '';
	module_cateogory_var = '';
	module_status_var = '';
	module_score_value_var = 00;
	module_difficulty_var = 0;
	module_award_gold_var = 0;
	module_award_silver_var = 0;
	module_award_bronze_var = 0;
	var_levelid = 0;	
	
	for arow in
    SELECT * FROM (
	SELECT 
	  '' as award,	
	  levels.score as score,
	  levels.originalscore as originalScore, 
	  levels.sans25category as category,
	  levels.status as status,
	  levels.name as name,
	  levels.directory as directory,
	  levels.id as levelid
	 
	FROM 
	  public.levels, 
	  public.users 
	WHERE 
	  levels.status = 'enabled'
	  AND username = usernameIN
	  AND name NOT IN


	(	
	SELECT 
	  levels.name as name
	 
	FROM 
	  public.levels, 
	  public.users, 
	  public.claimed
	WHERE 
	  users.id = claimed.userid AND
	  claimed.levelid = levels.id AND
	  levels.status = 'enabled'
	  AND username = usernameIN
	  ) 
	  UNION

	  SELECT 
	  claimed.award,
	  levels.score as score,
	  levels.originalscore as originalScore, 
	  levels.sans25category as category,
	  levels.status as status,
	  levels.name as name,
	  levels.directory as directory,
	  levels.id as levelid
	 
	FROM 
	  public.levels, 
	  public.users, 
	  public.claimed
	WHERE 
	  users.id = claimed.userid AND
	  claimed.levelid = levels.id AND
	  levels.status = 'enabled'
	  AND username = usernameIN
	) t ORDER BY levelid	  
	loop
	module_name_var := arow.name;
	module_directory_var := arow.directory;
	module_cateogory_var :=arow.category;
	module_status_var = 0;
	module_score_value_var :=arow.score;

	--BOF THIS NEEDS TO BE FIXED. Always returns a ZERO - this is because the level ID cannot be found.
	RAISE NOTICE 'SELECT count(*) into module_complete_var from scoreboard_breakdown where username = % and fk_level_id = %',usernameIN,(SELECT id from levels where name = module_name_var);
	SELECT count(*) into module_complete_var from scoreboard_breakdown where username = usernameIN and fk_level_id = (SELECT id from levels where name = module_name_var);
	if module_complete_var > 0 then
		module_status_var = 1;
	end if;	
	--EOF
	
	module_difficulty_var := arow.originalScore;

	var_award_temp = arow.award;
	
	
	if var_award_temp = 'gold' then
		module_award_gold_var = 1;
		module_award_silver_var = 0;
		module_award_bronze_var = 0;
		raise notice 'GOLD var_award_temp: %;',var_award_temp;
	end if;	
	if var_award_temp = 'silver' then
		module_award_gold_var = 0;
		module_award_silver_var = 1;
		module_award_bronze_var = 0;
		raise notice 'silver var_award_temp: %;',var_award_temp;
	end if;	
	if var_award_temp = 'bronze' then
		module_award_gold_var = 0;
		module_award_silver_var = 0;
		module_award_bronze_var = 1;
		raise notice 'bronze var_award_temp: %;',var_award_temp;
	end if;	
	var_award_temp = '';
	
		RETURN QUERY SELECT module_name_var, module_directory_var, module_cateogory_var,module_status_var,module_score_value_var,module_difficulty_var,module_award_gold_var,module_award_silver_var,module_award_bronze_var;
		module_award_gold_var = 0;
		module_award_silver_var = 0;
		module_award_bronze_var = 0;
	end loop;
    END;
$$
 LANGUAGE plpgsql;
 