package utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Class to interact with User Settings in the DB
 *
 */
public class UserFunctions 
{
	private static final Logger logger = LoggerFactory.getLogger(UserFunctions.class);
	
	/**
	 * Creates a User in the local DB for local user
	 * @param username String that Cannot be Null
	 * @param hashedPass String
	 * @param email String
	 * @param compOrganization String
	 * @return True if ran without error
	 * @throws SQLException
	 */
	public static boolean createUser (String firstname, String lastname, String faction,String compOrganization,String status,String username, String hashedPass, String email, String employeeId) throws SQLException
	{
		boolean result = false;
		logger.debug("Connecting to DB");
		Database db = new Database();
		Connection con = db.getConnection();
		logger.debug("Executing Create User Statement");
		PreparedStatement ps = con.prepareStatement("INSERT INTO users (firstname, lastname, faction,compOrganization,status,username, password, email, employeeId, active,registered) VALUES (?,?,?,?, ?, ?, ?, ?,?,?,now())");
		ps.setString(1, firstname.toLowerCase());
		ps.setString(2, lastname.toLowerCase());
		ps.setString(3, faction.toLowerCase());
		ps.setString(4, compOrganization.toLowerCase());
		ps.setString(5, status.toLowerCase());
		ps.setString(6, username.toLowerCase());
		ps.setString(7, hashedPass);
		ps.setString(8, email.toLowerCase());
		ps.setString(9, employeeId);
		ps.setBoolean(10, false);
		ps.execute();
		result = true;
		logger.debug("Successfully Created User in Local DB");
		
		//Close Connections
		ps.close();
		return result;
	}
	
	public static boolean updateActivity (String firstname, String lastname, String username, String compOrganization,String faction) throws SQLException
	{
		boolean result = false;
		logger.debug("Connecting to DB");
		Database db = new Database();
		Connection con = db.getConnection();
		logger.debug("Executing Update Activity");
		PreparedStatement ps = con.prepareStatement(" INSERT INTO activity (firstname,lastname,username,comporganization,faction,lastlogin) VALUES (?,?,?,?,?,now())\r\n"
				+ "  ON CONFLICT (username)\r\n"
				+ "  DO\r\n"
				+ "  UPDATE SET lastlogin = now();");
		ps.setString(1, firstname.toLowerCase());
		ps.setString(2, lastname);
		ps.setString(3, username.toLowerCase());
		ps.setString(4, compOrganization);
		ps.setString(5, faction);
		ps.execute();
		result = true;
		logger.debug("Successfully Update Activity Local DB");
		
		//Close Connections
		ps.close();
		return result;
	}
	
	/**
	 * Retrieves a user's employeeId based on their email address
	 * Works in LDAP Deployment Only
	 * @param email
	 * @return
	 * @throws SQLException
	 */
	public static String getEmpoyeeId (String email) throws SQLException
	{
		String result = new String();
		logger.debug("Connecting to DB");
		Database db = new Database();
		Connection con = db.getConnection();
		logger.debug("Executing Find Employee Id Query");
		PreparedStatement ps = con.prepareStatement("SELECT employeeId FROM users WHERE LOWER(email) = ?");
		ps.setString(1, email.toLowerCase());
		ResultSet rs = ps.executeQuery();
		if(rs.next())
			result = rs.getString(1);
		if(!result.isEmpty())
			logger.debug("Found id " + result);
		else
			logger.debug("No Id Detected");
		
		//Close Connections
		ps.close();rs.close();
		return result;
	}
	
	/**
	 * Get the User's Local Pk By email look up
	 * @param email
	 * @return
	 * @throws SQLException
	 */
	public static String getUserPkByEmail (String email) throws SQLException
	{
		String result = new String();
		logger.debug("Connecting to DB");
		Database db = new Database();
		Connection con = db.getConnection();
		logger.debug("Executing Find Employee Id Query");
		PreparedStatement ps = con.prepareStatement("SELECT id FROM users WHERE LOWER(email) = ?");
		ps.setString(1, email.toLowerCase());
		ResultSet rs = ps.executeQuery();
		if(rs.next())
			result = rs.getString(1);
		if(!result.isEmpty())
			logger.debug("Found id " + result);
		else
			logger.debug("No Id Detected");
		
		//Close Connections
		ps.close();rs.close();
		return result;
	}
	
	/**
	 * Get the User's Local Pk By username look up
	 * @param email
	 * @return
	 * @throws SQLException
	 */
	public static String getUserPkByUserName (String username) throws SQLException
	{
		String result = new String();
		logger.debug("Connecting to DB");
		Database db = new Database();
		Connection con = db.getConnection();
		logger.debug("Executing Find Employee Id Query");
		PreparedStatement ps = con.prepareStatement("SELECT id FROM users WHERE LOWER(username) = ?");
		ps.setString(1, username.toLowerCase());
		ResultSet rs = ps.executeQuery();
		if(rs.next())
			result = rs.getString(1);
		if(!result.isEmpty())
			logger.debug("Found id " + result);
		else
			logger.debug("No Id Detected");
		
		//Close Connections
		ps.close();rs.close();
		return result;
	}
	
	/**
	 * Searches for a specific email
	 * @param email
	 * @return
	 * @throws SQLException
	 */
	public static boolean userEmailExists (String email) throws SQLException
	{
		boolean result = false;
		logger.debug("Connecting to DB");
		Database db = new Database();
		Connection con = db.getConnection();
		logger.debug("Executing UserExists Query");
		PreparedStatement ps = con.prepareStatement("SELECT username FROM users WHERE LOWER(email) = ?");
		ps.setString(1, email.toLowerCase());
		ResultSet rs = ps.executeQuery();
		if(rs.next())
		{
			result = true;
			logger.debug("User Email Found in DB");
		}
		else
			logger.debug("Could not Find mail  '" + email + "' in local db");
		
		//Close Connections
		rs.close();ps.close();
		return result;
	}
	
	/**
	 * Searches for a specific user name
	 * @param username
	 * @return
	 * @throws SQLException
	 */
	public static boolean usernameExists (String username) throws SQLException
	{
		boolean result = false;
		logger.debug("Connecting to DB");
		Database db = new Database();
		Connection con = db.getConnection();
		logger.debug("Executing UserExists Query");
		PreparedStatement ps = con.prepareStatement("SELECT username FROM users WHERE LOWER(username) = ?");
		ps.setString(1, username.toLowerCase());
		ResultSet rs = ps.executeQuery();
		if(rs.next())
		{
			result = true;
			logger.debug("User Name Found in DB");
		}
		else
			logger.debug("Could not Find User '" + username + "' in local db");
		
		//Close Connections
		rs.close();ps.close();
		return result;
	}
}
