package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Database  
{
	private final Logger logger = LoggerFactory.getLogger(Database.class);   
  
    public Database() {
		
	}
  
    public Connection getConnection() {
    	
		logger.debug("getConnection()");
    	logger.debug("Creating DB Connection Straight From Props File");
    	Connection myConnection = null;
		Properties siteProperties = PropertiesReader.readSiteProperties();
		String url = siteProperties.getProperty("url");
		String username = siteProperties.getProperty("databaseUsername");
		String password = siteProperties.getProperty("databasePassword");

		try	{
			Class.forName("org.postgresql.Driver");
			logger.debug("Danger: "+username+" "+password);
			myConnection = DriverManager.getConnection(url,username,password);
		} catch(Exception e) {
			System.out.println("Error getting database Connection:" + e.toString());
			myConnection = null;
		}
		return myConnection;
    }

    public Connection getConnection(String url) {
    	Connection myConnection = null;
		logger.debug("getConnection(String url)");
		    	
		logger.debug("Database connection - creating one to " + url);
        	
		Properties siteProperties = PropertiesReader.readSiteProperties();
		String username = siteProperties.getProperty("databaseUsername");
		String password = siteProperties.getProperty("databasePassword");

		try {
			Class.forName("org.postgresql.Driver");
			logger.debug("Connecting with "+username);
			myConnection = DriverManager.getConnection(url,username,password);
		} catch(Exception e) {
			System.out.println("Error getting database Connection:" + e.toString());
			myConnection = null;
		}

		return myConnection;
    }
}
