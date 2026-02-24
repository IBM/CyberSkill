package demodata.thejasonengine.com;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.json.JsonObject;

public class BruteForceDBConnections {
	
	private static final Logger LOGGER = LogManager.getLogger(BruteForceDBConnections.class);
	private static final String MSSQL_ENCRYPT = "encrypt=true";
	private static final String MSSQL_CERT = "trustServerCertificate=true";
	
	public JsonObject BruteForceConnectionErrors(String datasource)
	{
		LOGGER.debug("Inside BruteForceConnectionErrors with datasource: " + datasource);
		JsonObject response = new JsonObject();
		String[] parts = datasource.split("_");

        if (parts.length >= 3) { // Ensure there are enough parts to avoid ArrayIndexOutOfBoundsException
            String databaseType = parts[0];
            String host = parts[1];
            String database = parts[2];
            String user = parts[3];

            LOGGER.debug("databaseType: " + databaseType);
            LOGGER.debug("host: " + host);
            LOGGER.debug("database: " + database);
            LOGGER.debug("user: " + user);
            String db_jdbcclassname = "";
            
            BasicDataSource DataSource = new BasicDataSource();
	        if (databaseType.equalsIgnoreCase("mysql"))
	        {
	        	LOGGER.debug("Setting Datasource URL for mysql -  setting useSSL=False");
	        	DataSource.setUrl("jdbc:"+databaseType+"://"+host+":"+"3306"+"/"+database+"?allowPublicKeyRetrieval=true&useSSL=false");
	        	db_jdbcclassname = "com.mysql.cj.jdbc.Driver";
	        }
	        else if(databaseType.equalsIgnoreCase("postgresql") || databaseType.equalsIgnoreCase("postgres"))
	        {
	        	LOGGER.debug("Setting Datasource URL for postgres/postgresql - using postgresql in JDBC URL");
	        	DataSource.setUrl("jdbc:postgresql://"+host+":"+"5432"+"/"+database);
	        	db_jdbcclassname = "org.postgresql.Driver";
	        }
	        else if(databaseType.equalsIgnoreCase("db2"))
	        {
	        	DataSource.setUrl("jdbc:"+databaseType+"://"+host+":"+"50000"+"/"+database);
	        	db_jdbcclassname = "com.ibm.db2.jcc.DB2Driver";
	        }
	        else if(databaseType.equalsIgnoreCase("sqlserver"))
	        {
	        	DataSource.setUrl("jdbc:"+databaseType+"://"+host+":"+"50762"+";databaseName="+database+";"+MSSQL_ENCRYPT+";"+MSSQL_CERT);   
	        	db_jdbcclassname = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	        }
	        
	    	DataSource.setUsername(user);
	    	DataSource.setPassword("randomPassword");
	    	DataSource.setDriverClassName(db_jdbcclassname);
	    	DataSource.setInitialSize(5);
	    	DataSource.setMaxTotal(10);
	    	DataSource.setMinIdle(2);
	    	DataSource.setMaxIdle(5);
	    	DataSource.setMaxWaitMillis(10000);
	    	
	    	try
	    	{
	    		LOGGER.debug("Testing brute force datasource connection");
	    		DataSource.getConnection();
	    		response.put("result", "connection success");
	    	}
	    	catch(Exception e)
	    	{
	    		LOGGER.error("brute force datasource connection did not connect - this is expected behaviour: " + e.getLocalizedMessage());
	    		response.put("result", e.getLocalizedMessage());
	    	}
        } 
        else 
        {
        	LOGGER.debug("The string doesn't contain enough parts:" + datasource);
        }
        return response;
	}

}
