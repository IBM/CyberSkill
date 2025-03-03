package utils;


import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import levelUtils.Level;
import levelUtils.SaxParser;
//import levelUtils.SaxParser;



/**
 * Servlet implementation class Submit
 */
@WebServlet("/Submit")

public class Submit extends HttpServlet 
{
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(Submit.class);
       
    /**
     * @see HttpServlet#HttpServlet()
     */
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		HttpSession ses = request.getSession(true);
		String username= (String)ses.getAttribute("userName");
		String ipAddress = request.getHeader("X-FORWARDED-FOR");  
		if (ipAddress == null) 
		{  
			ipAddress = request.getRemoteAddr();  
		}
		logger.error("Offense ID: 19  - User submitting GET  - Submit Abuse "+username+" "+ipAddress +" hitting the submit page with a get");
			
	}
	
	
    public Submit() 
    {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession ses = request.getSession(true);
		String result = new String();
		PrintWriter out = response.getWriter();  
		out.print(getServletInfo());
		if(!SessionValidator.validate(ses))
		{
			//TODO - Redirect to Index to Login
		}
		else
		{
			String username= (String)ses.getAttribute("userName");
			
			logger.debug("Submitting username:" + username);
			
			String levelidIN = request.getParameter("level");
			logger.debug("Submitting level:" + levelidIN);
			
			String key = request.getParameter("key");
			logger.debug("Submitting key:" + key);
			
			String ipAddress = request.getHeader("X-FORWARDED-FOR");  
			if (ipAddress == null) 
			{  
				ipAddress = request.getRemoteAddr();  
			}
			
			HttpSession session = request.getSession(true);

			Random  rand = new Random();
			Boolean repeatOffender = false;
			
			//get the request details: "^[a-zA-Z0-9]*$";
			String EMAIL_PATTERN = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
			+ "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[0-9A-Za-z]{2,})$";	
			    
			Pattern pattern = Pattern.compile(EMAIL_PATTERN);
			boolean hackAttempt = false;
			Matcher matcher = pattern.matcher(username);
			
			if(matcher.matches()!= true)
			{
				hackAttempt = true;
				logger.error("Offense ID: 20  - Invalid username and key- Submit Abuse. Error: Invalid username: "+username+ " , key:" + key + ", from IP:" + ipAddress);
			}			
			response.setContentType("text/plain");
	    	
			if(hackAttempt)
			{
				if(repeatOffender == true)
		    	{
					result = new String("Trying again so soon Dave? - for you the server sleeps for a time. Come back after my snooze");
					logger.error("Offense ID: 21  - Rapid submissions detected: "+username+ " , key:" + key + ", from IP:" + ipAddress);
					
		    	}
		    	else
		    	{
		    		ErrrorCodes EC = new ErrrorCodes();
		    		result = new String(EC.getNewSQLErrorCode());
		    	}
			}
			else
			{
				if(repeatOffender == true)
		    	{
					result = new String("Trying again so soon Dave? - for now the server sleeps. Come back after my snooze");
					logger.error("Offense ID: 21  - Rapid submissions detected: "+username+ " , key:" + key + ", from IP:" + ipAddress);
		    	}
				else
				{
				
					//Beginning Of Valid Request	
					//first check key
					
					/*
					 * 
					 * If we wrote the key to the database from the XML file, it would mean that we wouldnt need to keep the 
					 * swap space in play at all.
					 * 
					 */
					
					logger.debug("Performing a DB lookup for the LevelID to convert it to a file name");
					Api solutionCheck = new Api();
					logger.debug("Initial: " +  levelidIN);
					levelidIN = solutionCheck.getLevelNameSubmittedHash(levelidIN);
					logger.debug("Post Conversion: " +  levelidIN);
					
					
					Properties siteProperties = PropertiesReader.readSiteProperties();
					String activefolder = siteProperties.getProperty("swapSpace");
					File file = new File(activefolder+"/"+levelidIN+"/level.xml");
					Level leveltmp = new Level();
					SaxParser.start(FileUtils.readFileToString(file), leveltmp);
					
					String realKey = leveltmp.getSolution();
					
					System.out.println("Comparing keys key: "+realKey+" key from file: "+key);
					if(realKey.equals(key))
					{
						logger.debug("Keys match for username:" + username + ", from IP:" + ipAddress);
						
						logger.debug("Check if username:" + username + ", from IP:" + ipAddress + " already answered level");
						boolean checkResult = solutionCheck.setAnswer(username, levelidIN);
					    
						if(checkResult)
					    {
							logger.debug("Level successfully answered for username:" + username + ", from IP:" + ipAddress);
							
					    	response.setContentType("text/html");
					    	result = new String("Correct Solution - Score Updated");
					    }
					    else
					    {
					    	logger.error("Offense ID: 21  - Repeated Level submission. Possible Brute Force  - Submit Abuse. Level already answered for username:" + username + ", from IP:" + ipAddress);
						    response.setContentType("text/plain");
						    result = new String("You have already completed this level");
					    }
					}
					else
					{
						logger.error("Offense ID: 22  - Incorrect Level Submission. Possible Brute Force  - Submit Abuse. Incorrect submission for username:" + username + ", from IP:" + ipAddress);
						response.setContentType("text/html");
					    result = new String("That is not the correct answer to this level");
					}
				}
			}
			//End Of Valid Request
			out.write(result);
		}
	}
	
}
