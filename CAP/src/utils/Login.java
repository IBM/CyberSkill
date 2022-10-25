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


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

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
	private static String localAuthentication (String username, String password) throws SQLException
	{
		boolean result = false;
		password = hashAndSaltPass(password);
		logger.debug("Connecting to DB");
		Database db = new Database();
		Connection con = db.getConnection();
		logger.debug("Executing Login Query");
		PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email = ? AND password = ? AND active is true");
		ps.setString(1, username.toLowerCase());
		ps.setString(2, password);
		ResultSet rs = ps.executeQuery();
		String id = "";
		String firstname = "";
		String lastname = "";
		String comporganization ="";
		String employeeid = "";
		String email = "";
		String admin = "";
		String faction = "";
		String geo = "";
		String status = "";
		
		String issuer = "honeyn3t";
		String subject = "honey3t_jwt_subject";
		
		String JWTResponse= "void";
		
		if(rs.next())
		{
			logger.debug("Successful Local Authentication");
			
			id = rs.getString("id");
			firstname = rs.getString("firstname");
			lastname = rs.getString("lastname");
			comporganization = rs.getString("comporganization");
			employeeid = rs.getString("employeeid");
			email = rs.getString("email");
			admin = rs.getString("admin");
			faction = rs.getString("faction");
			geo = rs.getString("geo");
			status = rs.getString("status");
			long timeInMillis = getTimeMilisecond();
			
			
			JWT jwt = new JWT();
			JWTResponse = jwt.createJWT(id, issuer, subject, timeInMillis, username, faction);
			result = true;
		}
		else
		{
			logger.error("Offense ID: 1 - Login: Possible Brute Force Local Authentication Failed for Username '" + username + "'");
			error="3";
		}
		//Close Connections
		rs.close();ps.close();
		
		return JWTResponse;
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
		String JWT = "";
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
			if(request.getParameter("password") == null)
			{
				logger.error("Offense ID: 11 - Login Submitting Wrong password - Login Abuse Could not find submitted password. Submitter IP: " + ipAddress);
			}
			else
			{
				password = (String) request.getParameter("password");
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
				JWT = localAuthentication(login, password);
				if(authType.equalsIgnoreCase(localAuthenticationProperty))
				{
					if(JWT.compareToIgnoreCase("void") != 0)
					{
						authenticated = true;
					}
					else
					{
						logger.debug("Local Authentication Failed");
						error="14";
						//TODO - Failed Local Auth Error
					}
				}
			} 
			catch (Exception e)
			{
				logger.error("Unable to log in even with valid data:  " + e.toString());
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
			ses.setAttribute("JWT", JWT); //login
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
	
	public static long getTimeMilisecond()
	{

			SimpleDateFormat sdf = new SimpleDateFormat("dd-M-yyyy hh:mm:ss");
			String dateInString = "22-01-2015 10:20:56";
			Date date;
			try 
			{
				date = sdf.parse(dateInString);
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(date);
				return calendar.getTimeInMillis();
			} 
			catch (Exception e) 
			{
				// TODO Auto-generated catch block
				logger.error("Unable to generate time in mili's " + e.toString());
			}
			return 0;
	}
	
}
