package utils;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.Properties;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import utils.VerifyRecaptcha;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Servlet implementation class Login
 */
@WebServlet("/register")
public class Register extends HttpServlet 
{
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(Register.class);
    static String error = "0";   
    /**
	 * Method to has and salt pass before use
	 * @param inputPass
	 * @return
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
     * @see HttpServlet#HttpServlet()
     */
    public Register() {
        super();
        // TODO Auto-generated constructor stub
    }
	
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		boolean validData = false;
		boolean authenticated = false;
		String firstname = new String();
		String lastname = new String();
		String faction = new String();
		String institution = new String();
		String status = new String();
		String login = new String(); //Could be username or email
		String password = new String();
		String passwordConfirm = new String();
		//Auth Type Detection Params
		Properties siteProperties = PropertiesReader.readSiteProperties();
		String authType = siteProperties.getProperty("authentication");
		String localAuthenticationProperty = new String("local");
		String disabledAuthenticationProperty = new String("none");
		String ipAddress = request.getHeader("X-FORWARDED-FOR");  
		// get reCAPTCHA request param
		String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
		System.out.println(gRecaptchaResponse);
		//boolean verify = VerifyRecaptcha.verify(gRecaptchaResponse);
		//logger.debug("Captcha Verify:: "+ verify);
		if (ipAddress == null) 
		{  
			ipAddress = request.getRemoteAddr();  
		}
		logger.debug("Getting username/password from request");
		error = "";
		try 	
		{
			//if (!verify) {
			//	logger.debug("CAPTCHA not verified");
			//	error="5";
			//}
			//else
			//{
			//	logger.debug("Captcha Submitted");
			//}
			if (request.getParameter("firstName") == null)
			{
				logger.error("Error 1.2.UDIW There has been an error with the user registering their data. Firstname is blank");
			}
			else
			{
				firstname = (String) request.getParameter("firstName");
				if (firstname.isEmpty())
				{
					logger.error("Error 1.2.UDIF There has been an error with the user registering their data. Firstname is blank");
				}
				else
				
					logger.debug("Firstname Submitted");
				
				
				
			}
			if (request.getParameter("lastName") == null)
			{
				logger.error("Error 1.2.UDIL There has been an error with the user registering their data. Lastname is blank");
			}
			else
			{
				lastname = (String) request.getParameter("lastName");
				if (lastname.isEmpty())
				{
					logger.error("Error 1.2.UDIL There has been an error with the user registering their data. Lastname is blank");
				}
				else
				
					logger.debug("Last Name Submitted");
				
			}

			if (request.getParameter("faction") == null)
			{
				logger.error("Error 1.2.UDIFA There has been an error with the user registering their data. Faction is blank");
			}
			else
			{
				faction = (String) request.getParameter("faction");
				if (faction.isEmpty())
				{
					logger.error("Error 1.2.UDIFA There has been an error with the user registering their data. Faction is blank");
				}
				else
				
					logger.debug("Faction Submitted");
				
				
				
			}
			if (request.getParameter("institution") == null)
			{
				logger.error("Error 1.2.UDII There has been an error with the user registering their data. Institution is blank");
			}
			else
			{
				institution = (String) request.getParameter("institution");
				if (institution.isEmpty())
				{
					logger.error("Error 1.2.UDII There has been an error with the user registering their data. Institution is blank");
				}
				else
				
					logger.debug("Institution Submitted");
				
				
				
			}
			if (request.getParameter("status") == null)
			{
				logger.error("Error 1.2.UDIS There has been an error with the user registering their data. Status is blank");
			}
			else
			{
				status = (String) request.getParameter("status");
				if (status.isEmpty())
				{
					logger.error("Error 1.2.UDIS There has been an error with the user registering their data. Status is blank");
				}
				else
				
					logger.debug("Status Submitted");
				
				
				
			}
			if (request.getParameter("userAddress") == null)
			{
				logger.error("Offense ID: 12 - Register Submitting wrong username - Register Abuse. Could not find submitted userAddress. Submitter IP Address: " + ipAddress);
				error="4";
			}
			else
			{
				login = (String) request.getParameter("userAddress").toLowerCase();
				Pattern ptr = Pattern.compile("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");
				if(!ptr.matcher(login).matches())
				{
					logger.error("Offense ID: 22  - Register Invalid email submissions. Possible Brute Force  - Register Abuse. Invalid e-mail address Submitter IP Address: " + ipAddress);
					error="12";
				}
				else
					logger.debug("userAddress Submitted: " + login);
					
			}
			if(request.getParameter("passWord") == null)
			{
				logger.error("Offense ID: 14 - Register Submitting wrong password - Register Abuse. Could not find submitted password . Submitter IP Address: " + ipAddress);
			}
			else
			{
				password = (String) request.getParameter("passWord");
				if(password.isEmpty())
				{
					logger.error("Offense ID: 15 - Register Submitting blank password - Register Abuse. Blank Password Submitted. Submitter IP Address:" + ipAddress);
					error="5";
				}
				else
					logger.debug("Password Submitted");
			}
			if(request.getParameter("passWordConfirm") == null)
			{
				logger.error("Offense ID: 14 - Register Submitting wrong passWordConfirm - Register Abuse. Could not find submitted password . Submitter IP Address: " + ipAddress);
			}
			else
			{
				passwordConfirm = (String) request.getParameter("passWordConfirm");
				if(passwordConfirm.isEmpty())
				{
					logger.error("Offense ID: 15 - Register Submitting blank passWordConfirm - Register Abuse. Blank Password Submitted. Submitter IP Address:" + ipAddress);
					error="5";
				}
				else
					logger.debug("passWordConfirm Submitted");
			}
		
		}
		catch (Exception e)
		{
			logger.debug("Username or Password or CAPTCHA was blank " + e);
			error="6";
		}
		validData = (!firstname.isEmpty() && !lastname.isEmpty() && !faction.isEmpty() && !institution.isEmpty() && !status.isEmpty() && !login.isEmpty() && !password.isEmpty()  && error == "");
        
		if(validData)
		{
			//Decide What Type of Authentication To Perform
			try 
			{
				if(authType.equalsIgnoreCase(localAuthenticationProperty))
				{
					if(!UserFunctions.userEmailExists(login)) //Check if the user has an entry in our local DB
					{
						UserFunctions.createUser(firstname,lastname,faction,institution, status, login, hashAndSaltPass(password), login, login);
						authenticated = true; //Not Authenticated, just lazy to rename
					}
					else
					{
						logger.debug("Email address already registered");
						error="13";
						authenticated = true;
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
		if(!authenticated && error==null)
		{
			response.sendRedirect("registered.jsp");
		}
		else 
		{
			String nextJSP = "index.jsp?registererror="+error;
			response.sendRedirect(nextJSP);
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
