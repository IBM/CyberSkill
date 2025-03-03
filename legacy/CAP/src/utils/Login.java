package utils;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
import java.util.Properties;

import javax.naming.AuthenticationException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet 
{
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(Login.class);
    static String error = "0";   
    
    public static String GenerateTestUserCredentials (String inputPass)
    {
    	return hashAndSaltPass(inputPass);
    }
    
    
    /**
	 * Method to has and salt pass before use
	 * @param inputPass
	 * @return
	 * 
	 */
	private static String hashAndSaltPass (String inputPass)
	{
		String salt = "Rasputin";
		//hash the input password for later comparison with password in db
		MessageDigest md = null;
		try 
		{
			md = MessageDigest.getInstance("SHA-256");
		} 
		catch (NoSuchAlgorithmException e1) 
		{
			logger.error("SHA-256 Not Found: " + e1.toString());
		}
		String text = inputPass+salt;
		try 
		{
			md.update(text.getBytes("UTF-8"));
		} 
		catch (UnsupportedEncodingException e) 
		{
			logger.error("Could not convert Hash to Encoding: " + e.toString());
		} 
		// Change this to "UTF-16" if needed
		byte[] digest = md.digest();
	
		//convert the byte to hex format method 1
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < digest.length; i++) 
        {
          sb.append(Integer.toString((digest[i] & 0xff) + 0x100, 16).substring(1));
        }
        
        return sb.toString();
	}
 
	
	
    
	/**
	 *  @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 *
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("hallo");
	}*/

	/**
	 * Local PostGresql AUthentication
	 * @param username User name of the user trying to auth
	 * @param password User's Password
	 * @return Boolean representing successful auth or not
	 * @throws SQLException DB Layer Failure
	 */
	private static boolean localAuthentication (String username, String password) throws SQLException
	{
		boolean result = false;
		password = hashAndSaltPass(password);
		logger.debug("Connecting to DB");
		Database db = new Database();
		Connection con = db.getConnection();
		logger.debug("Executing Login Query");
		PreparedStatement ps = con.prepareStatement("SELECT email FROM users WHERE email = ? AND password = ?");
		ps.setString(1, username.toLowerCase());
		ps.setString(2, password);
		ResultSet rs = ps.executeQuery();
		if(rs.next())
		{
			logger.debug("Successful Local Authentication");
			result = true;
		}
		else
		{
			logger.error("Offense ID: 1 - Login: Possible Brute Force Local Authentication Failed for Username '" + username + "'");
			error="3";
		}
		//Close Connections
		rs.close();ps.close();
		
		return result;
	}
	
	/**
     * @see HttpServlet#HttpServlet()
     */
    public Login() {
        super();
        // TODO Auto-generated constructor stub
    }
	
    /**
     * Get Request for Test Based Session (no acutal auth)
     */
	protected void doGet (HttpServletRequest request, HttpServletResponse response) 
    {
	    try 
	    {
			response.sendRedirect("index.jsp");
		} 
	    catch (IOException e) 
	    {
			logger.debug("Could not Redirect from Login Servlet GET request");
		}
    }
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		boolean validData = false;
		boolean authenticated = false;
		String login = new String(); //Could be username or email
		String password = new String();
		//Auth Type Detection Params
		Properties siteProperties = PropertiesReader.readSiteProperties();
		String authType = siteProperties.getProperty("authentication");
		String localAuthenticationProperty = new String("local");
		String ldapAuthenticationProperty = new String("ldap");
		String disabledAuthenticationProperty = new String("none");
		String ipAddress = request.getHeader("X-FORWARDED-FOR");  
		if (ipAddress == null) 
		{  
			ipAddress = request.getRemoteAddr();  
		}
		logger.debug("Getting username/password from request");
		try 	
		{
			if (request.getParameter("login") == null)
			{
				logger.error("Offense ID: 10 - Login Submitting Wrong email - Login Abuse Could not find submitted login. Submitter IP: " + ipAddress);
				error="4";
			}
			else
			{
				login = (String) request.getParameter("login").toLowerCase();
				logger.debug("login Submitted: " + login + " IP: " + ipAddress);
			}
			if(request.getParameter("pwd") == null)
			{
				logger.error("Offense ID: 11 - Login Submitting Wrong password - Login Abuse Could not find submitted password. Submitter IP: " + ipAddress);
			}
			else
			{
				password = (String) request.getParameter("pwd");
				if(password.isEmpty())
				{
					logger.error("Offense ID: 16 - Login Submitting blank email - Login Abuse Blank Password Submitted.  Submitter IP: " + ipAddress);
					error="5";
				}
				else
					logger.debug("Password Submitted");
			}
		}
		catch (Exception e)
		{
			logger.debug("Offense ID: 18  - Username or Password was blank  - Login Abuse. Submitter IP: " + ipAddress);
			error="6";
		}
		validData = (!login.isEmpty() && !password.isEmpty());
        
		if(validData)
		{
			//Decide What Type of Authentication To Perform
			try 
			{
				if(authType.equalsIgnoreCase(localAuthenticationProperty))
				{
					if(localAuthentication(login, password))
					{
						authenticated = true;
					}
					else
					{
						logger.debug("Local Authentication Failed");
						error="7";
						//TODO - Failed Local Auth Error
					}
				}
				
				else if (authType.equalsIgnoreCase(disabledAuthenticationProperty))
				{
					logger.debug("Authentication Is Disabled via Properties File");
				}
				else 
				{
					logger.error("No Authentication Mechanism Correctly Specificed! Unknown Property Value Detected: " + authType);
				}
			} 
			catch (SQLException e)
			{
				logger.error("SQL Failure: " + e.toString());
				error="9";
			}
		}
		if(!authenticated)
		{
			String nextJSP = "index.jsp?error="+error;
			response.sendRedirect(nextJSP);
		}
		else 
		{
			//Create Session
			HttpSession ses = request.getSession(true);
		    ses.invalidate();
			ses = request.getSession(true);
			//TODO - Remove userName / userPk references and uniform to login
			ses.setAttribute("userName", login.toLowerCase()); //login
			ses.setAttribute("userPk", login.toLowerCase()); //also Login
			ses.setAttribute("login", login.toLowerCase()); //also Login
			if(	checkIfGlobalScoreboardIsNeeded(siteProperties) ) {
				ses.setAttribute("globalLeaderboards","true");
			} else {
				ses.setAttribute("globalLeaderboards","false");
			}
			try 
			{
				if (authType.equalsIgnoreCase(ldapAuthenticationProperty))
				{
					String employeeId = new String();
					//LDAP Users Have EmployeeId's too
					employeeId = UserFunctions.getEmpoyeeId(login.toLowerCase());
					ses.setAttribute("employeeId", employeeId);
				} 
			}
			catch (SQLException e) 
			{
				logger.error("Could not find ID: " + e.toString());
			}
			response.sendRedirect("dashboard.jsp");
		}
	}
	
	private boolean checkIfGlobalScoreboardIsNeeded(Properties siteProperties) {
		String remoteDatabases = siteProperties.getProperty("remoteDatabases");
		if( remoteDatabases == null || remoteDatabases.equals("") ) {
			return false;
		} else {
			return true;
		}
		
	}
	
}
