package utils;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.owasp.encoder.Encode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;



public class Api 
{
	private static final Logger logger = LoggerFactory.getLogger(Api.class);
	
	/**
	 * SANS number to text conversion
	 * 
	 * @param sansNumber 1- 25
	 * @return text equivalent of the above number
	 */
	public static String getSansText(int sansNumber){
		
		String output = "";
		if (sansNumber < 1 || sansNumber > 25){
			logger.error("Error with Sans number, Out of bounds");
			return null;
		}
		switch (sansNumber){
		case 1:
			output = "Improper Neutralization of Special Elements used in an SQL Command ('SQL Injection')";
			break;
		case 2:
			output = "Improper Neutralization of Special Elements used in an OS Command ('OS Command Injection')";
			break;
		case 3:
			output = "Buffer Copy without Checking Size of Input ('Classic Buffer Overflow')";
			break;
		case 4:
			output = "Improper Neutralization of Input During Web Page Generation ('Cross-site Scripting')";
			break;
		case 5:
			output = "Missing Authentication for Critical Function";
			break;
		case 6:
			output = "Missing Authorization";
			break;
		case 7:
			output = "Use of Hard-coded Credentials";
			break;
		case 8:
			output = "Missing Encryption of Sensitive Data";
			break;
		case 9:
			output = "Unrestricted Upload of File with Dangerous Type";
			break;
		case 10:
			output = "Reliance on Untrusted Inputs in a Security Decision";
			break;
		case 11:
			output = "Execution with Unnecessary Privileges";
			break;
		case 12:
			output = "Cross-Site Request Forgery (CSRF)";
			break;
		case 13:
			output = "Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')";
			break;
		case 14:
			output = "Download of Code Without Integrity Check";
			break;
		case 15:
			output = "Incorrect Authorization";
			break;
		case 16:
			output = "Inclusion of Functionality from Untrusted Control Sphere";
			break;
		case 17:
			output = "Incorrect Permission Assignment for Critical Resource";
			break;
		case 18:
			output = "Use of Potentially Dangerous Function";
			break;
		case 19:
			output = "Use of a Broken or Risky Cryptographic Algorithm";
			break;
		case 20:
			output = "Incorrect Calculation of Buffer Size";
			break;
		case 21:
			output = "Improper Restriction of Excessive Authentication Attempts";
			break;
		case 22:
			output = "URL Redirection to Untrusted Site ('Open Redirect')";
			break;
		case 23:
			output = "Uncontrolled Format String";
			break;
		case 24:
			output = "Integer Overflow or Wraparound";
			break;
		case 25:
			output = "Use of a One-Way Hash without a Salt";
			break;
		default:
			output = null;
			break;
		}
		
		return output;
	}
	/**********************************************/
	public String getLevelNameSubmittedHash(String hash)
	{
		String result = "";
		
		
		Database db = new Database();
		Connection con = db.getConnection();
		try
		{
			CallableStatement cs = con.prepareCall("select name from levels where directory = ?"); //User Stats Proc
			cs.setString(1, hash);
			logger.debug("Executing getLevelNameSubmittedHash");
			ResultSet rs = cs.executeQuery();
			
			if(rs.next()) //Should only be one user stat in response
			{
				logger.debug("Level found");
				if(rs.getString(1) != null)
				{
					result = rs.getString(1);
				}
			}
			logger.debug("Returning Result : " + result);
		}
		catch(SQLException e)
		{
			logger.error("Unable to calculate the level - possible attack: " + e.toString());
			result = null;
		}
		catch(Exception e)
		{
			logger.error("Unable to calculate the level - possible attack: " + e.toString());
			result = null;
		}
		return result;
	}
	/**********************************************/
	
	public static synchronized String incrementModuleFeedRequestByUsername(String username)
	{
		Connection connection = null;
		String result= "{\"dbsuccess\":\"Failure 101\"}";
		try 
		{
			Database db = new Database();
			connection = db.getConnection();
			
			try 
			{
				String querry = SetterStatements.updateModuleFeedMonitor;
				logger.debug("QUERRY: " + querry);
				PreparedStatement preparedStatement = connection.prepareStatement(querry);
				preparedStatement.setString(1,username);
				preparedStatement.execute();
			} 
			catch (Exception e) 
			{
				result= "{error}";
				result= "{\"dbsuccess\":\""+e.toString().replaceAll("\"", "").replaceAll("\\r\\n|\\r|\\n", " ")+"\"}";
				logger.error("Error sending statement:" + e.toString().replaceAll("\"", "").replaceAll("\\r\\n|\\r|\\n", " "));
			} 
			finally 
			{
				try 
				{
					if (connection != null) 
					{
						connection.close();
					}
				} 
				catch (SQLException sqle) 
				{
					result= "{\"dbsuccess\":\""+sqle.toString().replaceAll("\"", "").replaceAll("\\r\\n|\\r|\\n", " ")+"\"}";
					logger.error(sqle.getMessage());
				}
			}
		}
		catch (Exception e) 
		{
			result= "{error}";
			result= "{\"dbsuccess\":\""+e.toString().replaceAll("\"", "").replaceAll("\\r\\n|\\r|\\n", " ")+"\"}";
			logger.error("Error sending statement:" + e.toString());
		} 
		return result;
	
	}
	
	
	/**********************************************/
	public boolean setAnswer(String username, String level)
	{
		Connection connection = null;
		boolean result = false;
		try 
		{

			Database db = new Database();
			connection = db.getConnection();

			PreparedStatement preparedStatement = connection.prepareStatement("SELECT submitUserSolution(?,?)");
			preparedStatement.setString(1, username.toLowerCase());
			preparedStatement.setString(2, level);

			ResultSet results = preparedStatement.executeQuery();

			while(results.next())
			{	
				String check = results.getString(1);
				logger.debug("result of db query:"+check);
				if(check.equals("f"))
				{
					return false;
				}
				else
				{
					return true;
				}
			}

			connection.close();

		}
		catch(Exception e)
		{
			logger.error("Unable to connect to database: " + e.toString());
			result = false;
		}

		return result;

		//check if the user has claimed this level
		//if they haven't update it as claimed for this user, award them points
		//decrement level scorable points by 10
		//else do nothing


	}
	/**********************************************/
	public ArrayList getScoreBoard()
	{
		ArrayList<String> scores = new ArrayList();

		Connection connection = null;
		boolean result = false;
		try 
		{
			Database db = new Database();
			connection = db.getConnection();
			PreparedStatement preparedStatement = connection.prepareStatement("SELECT * from retrievescoreboard()");
			ResultSet results = preparedStatement.executeQuery();

			while(results.next())
			{	
				String jsonStr = "score:"+results.getString(2)+",name:"+results.getString(3)+"";
				scores.add(jsonStr);
			}

		}
		catch(Exception e)
		{
			logger.error("Unable to connect to database: " + e.toString());
			result = false;
		}

		return scores;
	}
	/**********************************************/
	public ArrayList<String[]> getAllScoresByDate()
	{
		ArrayList<String[]> scoresByDate = new ArrayList<String[]>();
		Connection connection = null;
		try 
		{
			Database db = new Database();
			connection = db.getConnection();
			PreparedStatement preparedStatement = connection.prepareStatement(GetterStatements.get_all_scores_by_date);
			ResultSet results = preparedStatement.executeQuery();
			
			while(results.next())
			{	
				String[] result = new String[5];
				result[0] = results.getString("faction");
				result[1] = results.getString("name");
				result[2] = results.getString("score"); 
				result[3] = results.getString("submitted");
				result[4] = results.getString("username");
				scoresByDate.add(result);
			}

		}
		catch(Exception e)
		{
			logger.error("getAllScoresByDate: " + e.toString());
		}

		return scoresByDate;
	}
	/**********************************************/
	public ArrayList<String[]> getAllScoresAggregatedByFaction()
	{
		ArrayList<String[]> scoresByDate = new ArrayList<String[]>();
		Connection connection = null;
		try 
		{
			Database db = new Database();
			connection = db.getConnection();
			PreparedStatement preparedStatement = connection.prepareStatement(GetterStatements.get_all_scores_aggregated_by_faction);
			ResultSet results = preparedStatement.executeQuery();
			
			while(results.next())
			{	
				String[] result = new String[5];
				result[0] = results.getString("faction");
				result[1] = results.getString("sum");
				
				scoresByDate.add(result);
			}

		}
		catch(Exception e)
		{
			logger.error("getAllScoresAggregatedByFaction: " + e.toString());
		}

		return scoresByDate;
	}
	/**********************************************/
	public ArrayList<String[]> getAllScoresByUsername(String username)
	{
		ArrayList<String[]> scoresByDate = new ArrayList<String[]>();
		Connection connection = null;
		try 
		{
			Database db = new Database();
			connection = db.getConnection();
			PreparedStatement preparedStatement = connection.prepareStatement(GetterStatements.get_all_scores_by_username);
			preparedStatement.setString(1, username.toLowerCase());
			ResultSet results = preparedStatement.executeQuery();
			
			while(results.next())
			{	
				String[] result = new String[5];
				result[0] = results.getString("faction");
				result[1] = results.getString("name");
				result[2] = results.getString("score"); 
				result[3] = results.getString("submitted");
				result[4] = results.getString("username");
				scoresByDate.add(result);
			}

		}
		catch(Exception e)
		{
			logger.error("getAllScoresByUsername: " + e.toString());
		}

		return scoresByDate;
	}
	/**********************************************/
	public ArrayList<String[]> getFactionDataByUsername(String username)
	{
		ArrayList<String[]> scoresByDate = new ArrayList<String[]>();
		Connection connection = null;
		try 
		{
			Database db = new Database();
			connection = db.getConnection();
			PreparedStatement preparedStatement = connection.prepareStatement(GetterStatements.get_all_scores_by_username);
			preparedStatement.setString(1, username.toLowerCase());
			ResultSet results = preparedStatement.executeQuery();
			
			while(results.next())
			{	
				String[] result = new String[5];
				result[0] = results.getString("faction");
				result[1] = results.getString("name");
				result[2] = results.getString("score"); 
				result[3] = results.getString("submitted");
				result[4] = results.getString("username");
				scoresByDate.add(result);
			}

		}
		catch(Exception e)
		{
			logger.error("getAllScoresByUsername: " + e.toString());
		}

		return scoresByDate;
	}
	/**********************************************/
	public ArrayList<String[]> getAllMembersOfMyFaction(String faction)
	{
		ArrayList<String[]> factionMembers = new ArrayList<String[]>();
		Connection connection = null;
		try 
		{
			Database db = new Database();
			connection = db.getConnection();
			PreparedStatement preparedStatement = connection.prepareStatement(GetterStatements.get_all_members_of_my_faction);
			preparedStatement.setString(1, faction);
			ResultSet results = preparedStatement.executeQuery();
			
			while(results.next())
			{	
				String[] result = new String[4];
				
				result[0] = results.getString("firstname");
				result[1] = results.getString("lastname");
				result[2] = results.getString("email");
				result[3] = results.getString("username");
				factionMembers.add(result);
			}

		}
		catch(Exception e)
		{
			logger.error("get_all_members_of_my_faction: " + e.toString());
		}

		return factionMembers;
	}
	
	
	
	/**********************************************/
	public ArrayList<String[]> getAllScoresInAFactionByUsername(String faction)
	{
		ArrayList<String[]> scoresByDate = new ArrayList<String[]>();
		Connection connection = null;
		try 
		{
			Database db = new Database();
			connection = db.getConnection();
			PreparedStatement preparedStatement = connection.prepareStatement(GetterStatements.get_all_scores_in_a_faction_by_username);
			preparedStatement.setString(1, faction);
			ResultSet results = preparedStatement.executeQuery();
			
			while(results.next())
			{	
				String[] result = new String[3];
				result[0] = results.getString("username");
				result[1] = results.getString("sum");
				result[2] = results.getString("faction");
				
				scoresByDate.add(result);
			}

		}
		catch(Exception e)
		{
			logger.error("get_all_scores_in_a_faction_by_username: " + e.toString());
		}

		return scoresByDate;
	}
	
	/**********************************************/
	public ArrayList<String[]> getAllScoresByFaction(String faction)
	{
		ArrayList<String[]> scoresByDate = new ArrayList<String[]>();
		Connection connection = null;
		try 
		{
			Database db = new Database();
			connection = db.getConnection();
			PreparedStatement preparedStatement = connection.prepareStatement(GetterStatements.get_all_scores_by_faction);
			preparedStatement.setString(1, faction);
			ResultSet results = preparedStatement.executeQuery();
			
			while(results.next())
			{	
				String[] result = new String[2];
				result[0] = results.getString("username");
				result[1] = results.getString("sum");
				
				scoresByDate.add(result);
			}

		}
		catch(Exception e)
		{
			logger.error("getAllScoresByFaction: " + e.toString());
		}

		return scoresByDate;
	}
	
	/**********************************************/
	public boolean setPersistantDatabase(String directory, String level, String difficulty, String owaspCategory, String sans25Category, String status)
	{
		logger.debug("select addOrModifyLevel("+directory+","+level+","+difficulty+","+owaspCategory+","+sans25Category+","+status+")");

		boolean result = true;
		int score = 0;
		Connection connection = null;

		if(difficulty.compareTo("easy")==0)
		{
			score = 65;
		}
		if(difficulty.compareTo("novice")==0)
		{
			score = 80;
		}
		if(difficulty.compareTo("medium")==0)
		{
			score = 130;
		}
		if(difficulty.compareTo("hard")==0)
		{
			score = 180;
		}
		if(difficulty.compareTo("expert")==0)
		{
			score = 205;
		}
		try 
		{

			Database db = new Database();
			connection = db.getConnection();

			PreparedStatement preparedStatement = connection.prepareStatement("select addOrModifyLevel(?,?,?,?,?,?)");
			preparedStatement.setString(1, directory);
			preparedStatement.setString(2, level);
			preparedStatement.setInt(3, score);
			preparedStatement.setString(4, owaspCategory);
			preparedStatement.setString(5, sans25Category);
			preparedStatement.setString(6, status);

			result = preparedStatement.execute();


		}
		catch(Exception e)
		{
			logger.error("Unable to connect to database: " + e.toString());
			result = false;
		}

		return result;

	}

	/**
	 * Get all Levels in DB
	 * @return
	 */
	public ArrayList<String[]> getAllLevels(){
		logger.debug("Getting all Modules");
		logger.debug("Module Feed API Called");
		ArrayList<String[]> modules = new ArrayList<String[]>();
		Database db = new Database();
		Connection con = db.getConnection();
		try
		{
			CallableStatement callstmt = con.prepareCall("SELECT * FROM allLevels() order by id");
			logger.debug("Executing allLevels Function");
			ResultSet resultSet = callstmt.executeQuery();
			logger.debug("Opening Result Set from allLevels");
			int i = 0;
			while(resultSet.next())
			{
				//Index in Response From DB Procedure where each element resides
				int id = 1;
				int levelName = 2;																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				;
				int sans25category = 3;
				int status = 4;
				int originalscore = 5;
				int timeopened = 6;
				String[] result = new String[6];
				i++;
				result[0] = resultSet.getString(id);
				result[1] = resultSet.getString(levelName);
				result[2] = resultSet.getString(sans25category); 
				result[3] = resultSet.getString(status);
				result[4] = resultSet.getString(originalscore);
				result[5] = resultSet.getString(timeopened);
				modules.add(result);
			}
			logger.debug("Returning list with " + i + " entries.");
		}
		catch (SQLException e)
		{
			logger.error("Could not execute query: " + e.toString());
		}
		return modules;
	}
	
	public void toggleLevel(String levelName){
		logger.debug("Toggling level status: " + levelName);
		Database db = new Database();
		Connection con = db.getConnection();
		try{
			CallableStatement callstmt = con.prepareCall("SELECT * from toggleLevel(?)");
			callstmt.setString(1,  levelName);
			logger.debug("Executing toggleLevel Function");
			callstmt.executeQuery();
		}
		catch (SQLException e){
			logger.error("Could not toggle level " + levelName );
			logger.error(e.toString());
		}
	}
	
	/**
	 * 
	 * @param userPk User's Primary Key in Local DB
	 * @return
	 */
	public ArrayList<String[]> getUserModuleFeed (String userPk)
	{
		logger.debug("Getting Modue Feed with userPk: " + userPk);
		logger.debug("Module Feed API Called");
		ArrayList<String[]> modules = new ArrayList<String[]>();
		Database db = new Database();
		Connection con = db.getConnection();
		try
		{
			CallableStatement callstmt = con.prepareCall("SELECT * FROM myEnabledModuleProgress(?)");
			callstmt.setString(1, userPk);
			logger.debug("Executing myEnabledModuleProgress Function");
			ResultSet resultSet = callstmt.executeQuery();
			logger.debug("Opening Result Set from moduleAllInfo");
			int i = 0;
			while(resultSet.next())
			{
				//Index in Response From DB Procedure where each element resides
				
				/*RETURNS TABLE(module_name, module_directory, module_cateogory, module_status, module_score_value, module_difficulty,
				 * module_award_gold,module_award_silver,module_award_bronze) AS
				 */
				
				int moduleId = 1																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				;
				int moduleName = 1;
				int moduleDirectory = 2;
				int moduleCategory = 3;
				int moduleCompleted = 4;
				int score = 5;
				int moduleDifficulty = 6;
				int goldMedal = 7;
				int silverMedal = 8;
				int bronzeMedal = 9;
				String[] result = new String[9];
				i++;
				result[0] = resultSet.getString(moduleId);
				logger.debug("******************************");
				logger.debug("moduleId:" + resultSet.getString(moduleId));
				result[1] = resultSet.getString(moduleName); 
				logger.debug("moduleDirectory:" + resultSet.getString(moduleDirectory));
				result[2] = resultSet.getString(moduleCategory);
				logger.debug("moduleCategory:" + resultSet.getString(moduleCategory));
				if(resultSet.getInt(moduleCompleted) == 0)
				{
					result[3] = "false";
					logger.debug("moduleCompleted: false");
				}
				else
				{
					result[3] = "true";
					logger.debug("moduleCompleted: true");
				}
				result[4] = resultSet.getString(score);
				logger.debug("score:" + resultSet.getString(score));
				result[5] = resultSet.getString(goldMedal);
				logger.debug("goldMedal:" + resultSet.getString(goldMedal));
				result[6] = resultSet.getString(silverMedal); 
				logger.debug("silverMedal:" + resultSet.getString(silverMedal));
				result[7] = resultSet.getString(bronzeMedal);
				logger.debug("bronzeMedal:" + resultSet.getString(bronzeMedal));
				logger.debug("moduleName:" + resultSet.getString(moduleName));
				result[8] = resultSet.getString(moduleDirectory); 
				logger.debug("******************************");
				modules.add(result);
			}
			logger.debug("Returning list with " + i + " entries.");
		}
		catch (SQLException e)
		{
			logger.error("Could not execute query: " + e.toString());
		}
		return modules;
	}

	@SuppressWarnings("unchecked")
	public String userStatCall (String login)
	{
		logger.debug("userStatCall Starting");
		String result = new String();
		Database db = new Database();
		Connection con = db.getConnection();
		try
		{
			CallableStatement cs = con.prepareCall("SELECT * FROM myCurrentProgress(?)"); //User Stats Proc
			cs.setString(1, login);
			logger.debug("Executing myCurrent progress function");
			ResultSet rs = cs.executeQuery();
			JSONArray json = new JSONArray();
			JSONObject jsonInner = new JSONObject();
			if(rs.next()) //Should only be one user stat in response
			{
				logger.debug("User data Found... JSONing It");
				jsonInner = new JSONObject();
				if(rs.getString(1) != null)
				{
					//Location in ResultSet of Information
					int dbCurrentRank = 1;
					int dbScore = 5;
					int dbGoldMedals = 2;
					int dbSilverMedals = 3;
					int dbBronzeMedals = 4;
					//Actual Info Retrieved
					int place = rs.getInt(dbCurrentRank);
					int score = rs.getInt(dbScore);
					int goldMedals = rs.getInt(dbGoldMedals);
					int silverMedals = rs.getInt(dbSilverMedals);
					int bronzeMedals = rs.getInt(dbBronzeMedals);
					//The Output
					jsonInner.put("username", new String(Encode.forHtml(login))); //User Name
					jsonInner.put("score", new Integer(score)); //Score
					jsonInner.put("rank", new Integer(place));
					jsonInner.put("goldMedalCount", new Integer(goldMedals));
					jsonInner.put("silverMedalCount", new Integer(silverMedals));
					jsonInner.put("bronzeMedalCount", new Integer(bronzeMedals));
					//log.debug("Adding: " + jsonInner.toString());
					json.add(jsonInner);
				}
			}
			result = json.toString();
			logger.debug("Returning Result : " + result);
		}
		catch(SQLException e)
		{
			logger.error("getJsonScore Failure: " + e.toString());
			result = null;
		}
		catch(Exception e)
		{
			logger.error("getJsonScore Unexpected Failure: " + e.toString());
			result = null;
		}
		//log.debug("*** END getJsonScore ***");
		return result;
	}




    /**********************************************/
    /*************leaderboards methods*************/
    /**********************************************/
    public JSONArray getTopScores(int limit, String databaseUrl) {
		logger.debug("Api.getTopScores()");

        JSONArray scoresJsonArray = new JSONArray();

		List<Player> playerList = getUsersByScore(limit,databaseUrl);

		for(Player player : playerList) {
            JSONObject scoreJsonObject = new JSONObject();
            scoreJsonObject.put("score", player.getScore());
            int pos =  player.getEmail().indexOf('@');
            String removeEmail = player.getEmail().substring(0,pos);
            scoreJsonObject.put("username", removeEmail+" - "+player.getScoreboardPosition());
            scoresJsonArray.add(scoreJsonObject);
        }

        return scoresJsonArray;
    }

    private List<Player> getUsersByScore(int limit, String databaseUrl) {
		logger.debug("Api.getUsersByScore()");

    	List<Player> playerList = new ArrayList<Player>();

        Connection connection = null;
        ResultSet results = null;
        try     {
                Database db = new Database();
                if(databaseUrl ==  null) {
                    connection = db.getConnection();
                } else {
                    connection = db.getConnection(databaseUrl);
                }
                PreparedStatement preparedStatement = connection.prepareStatement("SELECT * FROM public.scoreboard ORDER BY score desc LIMIT ?");

                if( limit > 0) {
                        preparedStatement = connection.prepareStatement("SELECT * FROM public.scoreboard ORDER BY score desc LIMIT ?");
                        preparedStatement.setInt(1, limit);
                } else {
                        preparedStatement = connection.prepareStatement("SELECT * FROM public.scoreboard ORDER BY score desc");
                }

                results = preparedStatement.executeQuery();
               
                int index = 0;
                

                while(results.next()) {
                	Player player = new Player(results.getString(3));
                	player.setScoreboardPosition(index+1);
                	player.setScore(results.getInt(2));
                	playerList.add(player);
                    index++;
                }
                                
        } catch(Exception e) {
                logger.error("Unable to connect to database: " + e.toString());
        }
        return playerList;
    }
    
    public JSONArray getGlobalTopScores(int limit) {
		logger.debug("Api.getGlobalTopScores()");

		Properties siteProperties = PropertiesReader.readSiteProperties();
		String remoteDatabsesStr = siteProperties.getProperty("remoteDatabases");
		String[] remoteDatabaseArray = remoteDatabsesStr.split(",");
	
		List<Player> playerList = new ArrayList<Player>();

		for(String remoteDatabase : remoteDatabaseArray) {
			System.out.println("remoteDatabaseArray: "+remoteDatabase);
			playerList.addAll( getUsersByScore(limit,remoteDatabase) );
		}
		
		Collections.sort(playerList, new PlayerScoreComparator());
		
        JSONArray scoresJsonArray = new JSONArray();
		
        int index = 1;
		for(Player player : playerList) {
            JSONObject scoreJsonObject = new JSONObject();
            scoreJsonObject.put("score", player.getScore());
            scoreJsonObject.put("username", player.getEmail()+" - "+(index++));
            scoresJsonArray.add(scoreJsonObject);
            if(index > 10) {
            	break;
            }
		}
		
        return scoresJsonArray;

    }


    /**********************************************/
    public JSONArray getSimilarPlayerScores(String username, String databaseUrl)    {
		logger.debug("Api.getSimilarPlayerScores()");

      
        JSONArray scoresJsonArray = new JSONArray();

        try {

    		List<Player> playerList = getUsersByScore(-1,databaseUrl);

            List<JSONObject> fullScoreList = new ArrayList<JSONObject>();
            List<JSONObject> similarPlayerList = new ArrayList<JSONObject>();

            int indexOfOurUser = -1;
            int index = 0;
    		for(Player player : playerList) {

                    JSONObject scoreJsonObject = new JSONObject();
                    scoreJsonObject.put("score", player.getScore());
                    int pos =  player.getEmail().indexOf('@');
                    String removeEmail = player.getEmail().substring(0,pos);
                    scoreJsonObject.put("username", removeEmail+" - "+(index+1));
                    fullScoreList.add(scoreJsonObject);

                    if( username.equals(player.getEmail())) {
                            indexOfOurUser = index;
                    }
                    index++;
            }

            int numberOfUsersBeforeAdded = 0;
            index = 0;
            List<JSONObject> tempBeforePlayerList = new ArrayList<JSONObject>();
            while( indexOfOurUser - index - 1 >= 0  && index < 9 ) { //add at most 9 users who are before the current user
                    //System.out.println("indexOfOurUser: "+indexOfOurUser);
                    //System.out.println("index: "+index);

                    //System.out.println("Adding user who is before current user: "+fullScoreList.get(indexOfOurUser - index - 1).get("username"));
                    tempBeforePlayerList.add(fullScoreList.get(indexOfOurUser - index - 1));
                    numberOfUsersBeforeAdded++;
                    index++;
            }

            Collections.reverse(tempBeforePlayerList);
            similarPlayerList.addAll(tempBeforePlayerList);

            //System.out.println("Adding user current user");
            JSONObject currentUserJsonObj = fullScoreList.get(indexOfOurUser);
            currentUserJsonObj.put("currentUser", "true");


            similarPlayerList.add(fullScoreList.get(indexOfOurUser)); //add current user

            int numberOfUsersAfterAdded = 0;
            index = indexOfOurUser + 1; //set index to the user after our current user
            while( index < (fullScoreList.size()-1) && index < (9 + indexOfOurUser + 1) ) { //add at most 9 users who are after the current user
                    // System.out.println("Adding user who is after current user");
                    similarPlayerList.add(fullScoreList.get(index));
                    numberOfUsersAfterAdded++;
                    index++;
            }

            //now we have a list users, at most 19, with our guy in the middle, top or bottom, we now need to cut the list down to 10
            int count = 0;
            while( similarPlayerList.size() > 10 && numberOfUsersBeforeAdded > 4) {
                    //System.out.println("Removing user who is too far infront of current user: "+similarPlayerList.get(0).get("username"));
                    similarPlayerList.remove(0);
                    numberOfUsersBeforeAdded--;
            }

            while( similarPlayerList.size() > 10 && numberOfUsersAfterAdded > 5) {
                    // System.out.println("Removing user who is too far behind of current user");
                    similarPlayerList.remove(similarPlayerList.size()-1);
                    numberOfUsersAfterAdded--;
            }

            //System.out.println("fullScoreList.size():" + fullScoreList.size());
            //System.out.println("similarPlayerList.size():" + similarPlayerList.size());

            for( JSONObject scoreJsonObject : similarPlayerList ) {
                    scoresJsonArray.add(scoreJsonObject);
            }

        } catch(Exception e) {
                logger.error("Unable to connect to database: " + e.toString());
        }

        return scoresJsonArray;
    }

    public JSONArray getGlobalSimilarPlayerScores(String username)   {
		logger.debug("Api.getGlobalSimilarPlayerScores()");

		Properties siteProperties = PropertiesReader.readSiteProperties();
		String remoteDatabsesStr = siteProperties.getProperty("remoteDatabases");
		String[] remoteDatabaseArray = remoteDatabsesStr.split(",");
	
		List<Player> playerList = new ArrayList<Player>();
        List<JSONObject> fullScoreList = new ArrayList<JSONObject>();
        List<JSONObject> similarPlayerList = new ArrayList<JSONObject>();

		for(String remoteDatabase : remoteDatabaseArray) {
			System.out.println("remoteDatabaseArray: "+remoteDatabase);
    		playerList.addAll( getUsersByScore(-1,remoteDatabase) );
		}
        
		Collections.sort(playerList, new PlayerScoreComparator());

        JSONArray scoresJsonArray = new JSONArray();
      
        int indexOfOurUser = -1;

        int index = 0;
		for(Player player : playerList) {
            JSONObject scoreJsonObject = new JSONObject();
            scoreJsonObject.put("score", player.getScore());
            scoreJsonObject.put("username", player.getEmail()+" - "+(index+1));
            fullScoreList.add(scoreJsonObject);

            if( username.equals(player.getEmail()) ) {
                indexOfOurUser = index;
            }
            index++;

		}
		

        int numberOfUsersBeforeAdded = 0;
        index = 0;
        List<JSONObject> tempBeforePlayerList = new ArrayList<JSONObject>();
        while( indexOfOurUser - index - 1 >= 0  && index < 9 ) { //add at most 9 users who are before the current user
                //System.out.println("indexOfOurUser: "+indexOfOurUser);
                //System.out.println("index: "+index);

                //System.out.println("Adding user who is before current user: "+fullScoreList.get(indexOfOurUser - index - 1).get("username"));
                tempBeforePlayerList.add(fullScoreList.get(indexOfOurUser - index - 1));
                numberOfUsersBeforeAdded++;
                index++;
        }

        Collections.reverse(tempBeforePlayerList);
        similarPlayerList.addAll(tempBeforePlayerList);

        //System.out.println("Adding user current user");
        JSONObject currentUserJsonObj = fullScoreList.get(indexOfOurUser);
        currentUserJsonObj.put("currentUser", "true");


        similarPlayerList.add(fullScoreList.get(indexOfOurUser)); //add current user

        int numberOfUsersAfterAdded = 0;
        index = indexOfOurUser + 1; //set index to the user after our current user
        while( index < (fullScoreList.size()-1) && index < (9 + indexOfOurUser + 1) ) { //add at most 9 users who are after the current user
                // System.out.println("Adding user who is after current user");
                similarPlayerList.add(fullScoreList.get(index));
                numberOfUsersAfterAdded++;
                index++;
        }

        //now we have a list users, at most 19, with our guy in the middle, top or bottom, we now need to cut the list down to 10
        int count = 0;
        while( similarPlayerList.size() > 10 && numberOfUsersBeforeAdded > 4) {
                //System.out.println("Removing user who is too far infront of current user: "+similarPlayerList.get(0).get("username"));
                similarPlayerList.remove(0);
                numberOfUsersBeforeAdded--;
        }

        while( similarPlayerList.size() > 10 && numberOfUsersAfterAdded > 5) {
                // System.out.println("Removing user who is too far behind of current user");
                similarPlayerList.remove(similarPlayerList.size()-1);
                numberOfUsersAfterAdded--;
        }

        //System.out.println("fullScoreList.size():" + fullScoreList.size());
        //System.out.println("similarPlayerList.size():" + similarPlayerList.size());

        for( JSONObject scoreJsonObject : similarPlayerList ) {
                scoresJsonArray.add(scoreJsonObject);
        }


        return scoresJsonArray;
    }

    
    //used to compare players by score
	public class PlayerScoreComparator implements Comparator<Player> {
	    @Override
	    public int compare(Player p1, Player p2) {
	        return p2.getScore() - p1.getScore();
	    }

	}

	public static JSONArray getPlayersStatistics()
	{
	     Database db = new Database();
		Connection con = db.getConnection();
		JSONArray json = new JSONArray();
		try
		{
			JSONObject userObject = new JSONObject();
			JSONArray userChallenges = new JSONArray();
			JSONObject challengeObject = new JSONObject();
			PreparedStatement ps = con.prepareStatement("SELECT userid, id, username, compOrganization, employeeId, email FROM users;"); 
			logger.debug("Executing get users progress query");
			ResultSet rs = ps.executeQuery();
	         while(rs.next()) 
	         {
	         	logger.debug("Gathering Stats for " + rs.getString(3));
	         	userObject = new JSONObject();
	         	//Create userObject
	         	userObject.put("userid", rs.getInt(1));
	         	userObject.put("id", rs.getInt(2));
	         	userObject.put("username", rs.getString(3));
	         	userObject.put("compOrganization", rs.getString(4));
	         	userObject.put("employeeId", rs.getString(5));
	         	userObject.put("email", rs.getString(6));
	         	logger.debug("Gathering Challenge Stats for " + rs.getString(3));
	         	//Get Claimed Rows for user with Challenge Info from levels table
	         	PreparedStatement ps1 = con.prepareStatement("SELECT claimed.id, levels.id, name, owaspcategory, sans25category, award FROM claimed JOIN levels on claimed.levelid = levels.id WHERE claimed.userid = ?"); 
	         	ps1.setInt(1, rs.getInt(2));//Setting userid for query
	         	logger.debug("Running Challenge Stats Query for user");
	         	ResultSet rs1 = ps1.executeQuery();
	         	userChallenges = new JSONArray();
	         	int i = 0;
	         	while(rs1.next())
	         	{
	         		i++;
	         		//Create challengeObject
	         		challengeObject = new JSONObject();
	         		challengeObject.put("claimedid", rs1.getInt(1));
	         		challengeObject.put("levelid", rs1.getInt(2));
	         		challengeObject.put("name", rs1.getString(3));
	         		challengeObject.put("owaspcategory", rs1.getString(4));
	         		challengeObject.put("sans25category", rs1.getString(5));
	         		challengeObject.put("award", rs1.getString(6));
	         		userChallenges.add(challengeObject);
	         	}
	         	logger.debug(rs.getString(3) + " has completed " + i + " challenges");
	         	userObject.put("challenges", userChallenges);
	         	json.add(userObject);
	         }
	                             
	     } 
		catch(Exception e) 
		{
	             logger.error("Unable to connect to database: " + e.toString());
	     }
		return json;
	}

	public static JSONArray getChallengeStatistics()
	{
	     Database db = new Database();
		Connection con = db.getConnection();
		JSONArray json = new JSONArray();
		try
		{
			JSONObject challengeObject = new JSONObject();
			JSONArray challengeUsers = new JSONArray();
			JSONObject userObject = new JSONObject();
			PreparedStatement ps = con.prepareStatement("SELECT id, name, score, originalscore, status, owaspcategory, sans25category FROM levels;"); 
			logger.debug("Executing get challenges progress query");
			ResultSet rs = ps.executeQuery();
	         while(rs.next()) 
	         {
	         	logger.debug("Gathering Stats for " + rs.getString(2));
	         	challengeObject = new JSONObject();
	         	//Create userObject
	         	challengeObject.put("id", rs.getInt(1));
	         	challengeObject.put("name", rs.getString(2));
	         	challengeObject.put("score", rs.getString(3));
	         	challengeObject.put("originalscore", rs.getString(4));
	         	challengeObject.put("status", rs.getString(5));
	         	challengeObject.put("owaspcategory", rs.getString(6));
	         	challengeObject.put("sans25category", rs.getString(7));
	         	logger.debug("Gathering User Stats for " + rs.getString(2));
	         	//Get Claimed Rows for Challenge with user Info from users table
	         	PreparedStatement ps1 = con.prepareStatement("SELECT claimed.id, users.userid, users.id, username, compOrganization, employeeId, email, award FROM claimed JOIN users on claimed.userid = users.id where claimed.levelid = ?"); 
	         	ps1.setInt(1, rs.getInt(1));//Setting levelid for query
	         	logger.debug("Running User Stats Query for this challenge");
	         	ResultSet rs1 = ps1.executeQuery();
	         	challengeUsers = new JSONArray();
	         	int i = 0;
	         	while(rs1.next())
	         	{
	         		i++;
	         		//Create userObject
	         		userObject = new JSONObject();
	         		userObject.put("claimedid", rs1.getInt(1));
	         		userObject.put("usersuserid", rs1.getString(2));
	         		userObject.put("userid", rs1.getString(3));
	         		userObject.put("username", rs1.getString(4));
	         		userObject.put("compOrganization", rs1.getString(5));
	         		userObject.put("employeeId", rs1.getString(6));
	         		userObject.put("email", rs1.getString(7));
	         		userObject.put("award", rs1.getString(8));
	         		challengeUsers.add(userObject);
	         	}
	         	logger.debug(rs.getString(2) + " has been completed by " + i + " users");
	         	challengeObject.put("challenges", challengeUsers);
	         	json.add(challengeObject);
	         }
	                             
	     } 
		catch(Exception e) 
		{
	             logger.error("Unable to connect to database: " + e.toString());
	     }
		return json;
	}
	
	//New API work
	/**********************************************/
	public ArrayList<String[]> getAllFactions()
	{
		ArrayList<String[]> factions = new ArrayList<String[]>();
		Connection connection = null;
		try 
		{
			Database db = new Database();
			connection = db.getConnection();
			PreparedStatement preparedStatement = connection.prepareStatement(GetterStatements.get_all_factions);
			ResultSet results = preparedStatement.executeQuery();
			
			while(results.next())
			{	
				String[] result = new String[25];
				result[0] = results.getString("faction");
				factions.add(result);
			}

		}
		catch(Exception e)
		{
			logger.error("getAllFactions: " + e.toString());
		}

		return factions;
	}
	
	/**
	 * Get all Levels in DB
	 * @return
	 */
	public ArrayList<String[]> getAllEnabledLevels(){
		logger.debug("Getting all Open Modules");
		logger.debug("Module Feed API Called");
		ArrayList<String[]> modules = new ArrayList<String[]>();
		Database db = new Database();
		Connection con = db.getConnection();
		try
		{
			
			PreparedStatement preparedStatement = con.prepareStatement(GetterStatements.get_all_open_challenges_by_time);
			logger.debug("Executing getAllEnabledLevels Function");
			ResultSet results = preparedStatement.executeQuery();
			logger.debug("Opening Result Set from allOpenLevels");
			int i = 0;
			while(results.next())
			{
				//Index in Response From DB Procedure where each element resides
				int directory = 1;
				int id = 2;
				int levelName = 3;																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				;
				int sans25category = 4;
				int status = 5;
				int originalscore = 6;
				int timeopened = 7;
				String[] result = new String[7];
				i++;
				result[0] = results.getString(directory);
				result[1] = results.getString(id);
				result[2] = results.getString(levelName);
				result[3] = results.getString(sans25category); 
				result[4] = results.getString(status);
				result[5] = results.getString(originalscore);
				result[6] = results.getString(timeopened);
				modules.add(result);
			}
			logger.debug("Returning list with " + i + " entries.");
		}
		catch (SQLException e)
		{
			logger.error("Could not execute query: " + e.toString());
		}
		return modules;
	}
	/**
	 * Get 10 most recent open Levels in DB
	 * @return
	 */
	public ArrayList<String[]> get10MostRecentEnabledLevels(){
		logger.debug("Getting all get10MostRecentEnabledLevels");
		logger.debug("Module Feed API Called");
		ArrayList<String[]> modules = new ArrayList<String[]>();
		Database db = new Database();
		Connection con = db.getConnection();
		try
		{
			
			PreparedStatement preparedStatement = con.prepareStatement(GetterStatements.get_10_open_challenges_by_time);
			logger.debug("Executing get10MostRecentEnabledLevels Function");
			ResultSet results = preparedStatement.executeQuery();
			logger.debug("Opening Result Set from get10MostRecentEnabledLevels");
			int i = 0;
			while(results.next())
			{
				//Index in Response From DB Procedure where each element resides
				int directory = 1;
				int id = 2;
				int levelName = 3;																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				;
				int sans25category = 4;
				int status = 5;
				int originalscore = 6;
				int timeopened = 7;
				String[] result = new String[7];
				i++;
				result[0] = results.getString(directory);
				result[1] = results.getString(id);
				result[2] = results.getString(levelName);
				result[3] = results.getString(sans25category); 
				result[4] = results.getString(status);
				result[5] = results.getString(originalscore);
				result[6] = results.getString(timeopened);
				modules.add(result);
			}
			logger.debug("Returning list with " + i + " entries.");
		}
		catch (SQLException e)
		{
			logger.error("Could not execute query: " + e.toString());
		}
		return modules;
	}

}

