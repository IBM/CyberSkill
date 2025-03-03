package levelUtils;

import java.sql.*;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class InMemoryDatabase 
{
	private final Logger logger = LoggerFactory.getLogger(InMemoryDatabase.class);
	public Connection myInMemoryConnection;  
	
	public Connection Create()
	{
		
		if(myInMemoryConnection == null)
    	{
		    try 
		    {
		      Class.forName("org.sqlite.JDBC");
		      myInMemoryConnection = DriverManager.getConnection("jdbc:sqlite::memory:");
		    } 
		    catch ( Exception e ) 
		    {
		      logger.error( e.getClass().getName() + ": " + e.getMessage() );
		    }
		    logger.info("Opened in memory database successfully");
		  }
		else
		{
			logger.debug("In memory database connection already set up - reusing, and saving resources");
		}
		return myInMemoryConnection;
	}
	public boolean CreateTable(String sql)
	{
		  myInMemoryConnection = Create();
		  Statement stmt = null;
		  boolean result = true;
		  try
		  {
			  stmt = myInMemoryConnection.createStatement();
		      stmt.executeUpdate(sql);
		      stmt.close();
		      logger.info("in memory table created successfully");
		  } 
		  catch ( Exception e ) 
		  {
			  logger.error("Error creating in memory table:" + e.toString());
			  result = false;
		  }
	    
	    return result;
	}
	public boolean InsertTableData(String sql)
	{
		
		boolean result = true;
		Connection myInMemoryConnection = Create();
	    Statement stmt = null;
	    try 
	    {
	      myInMemoryConnection.setAutoCommit(false);
	      logger.debug("Opened database successfully");

	      stmt = myInMemoryConnection.createStatement();
	      stmt.executeUpdate(sql);
	      stmt.close();
	      myInMemoryConnection.commit();
	     
	      logger.info("Records created successfully in the in memory database table");
	    } 
	    catch ( Exception e ) 
	    {
	      logger.error("Error inserting in memory data into table:" + e.toString());
	      result = false;
	    }
	   
	    return result;
	}
	
	public String inMemorySelectOperation(String sql, String param)
	{
		logger.info("***************** Start in Memory SELECT Work*******************");
		Connection myInMemoryConnection = Create();
	    Statement stmt = null;
	    HashMap<String, String> DataResults = new HashMap<String, String>();
	    try 
	    {
	      myInMemoryConnection.setAutoCommit(false);
	      logger.debug("Opened in memory database successfully");


	      stmt = myInMemoryConnection.createStatement();
	      ResultSet rs = stmt.executeQuery( sql + " " + param);
	      ResultSetMetaData rsmd=rs.getMetaData();
	      
	      int noOfColumns = rsmd.getColumnCount();
	      
	      for(int i = 1; i <= noOfColumns; i++ )
	      {
	    	  logger.debug("Columns/Type in resultSet are: " + rsmd.getColumnName(i) + " :" + rsmd.getColumnTypeName(i));
	      }
	      
	      logger.debug("Number of columns: "+noOfColumns); 
	      int masterLoop = 1;
	      while ( rs.next() ) 
	      {
	    	  logger.debug("*************************LOOP :");
	    	  for(int tempPosition=1;tempPosition<=noOfColumns;tempPosition++)
	    	  {

		    	  if(rsmd.getColumnTypeName(tempPosition).equalsIgnoreCase("int") )
		    	  {
		    		  logger.debug("INT FOUND in resultset");
		    		  DataResults.put(rsmd.getColumnName(tempPosition)+String.valueOf(masterLoop),String.valueOf(rs.getInt(rsmd.getColumnName(tempPosition))));
		    	  }

		    	  if(rsmd.getColumnTypeName(tempPosition).toString().equalsIgnoreCase("text"))
		    	  {
		    		  logger.debug("text FOUND in resultset");
		    		  DataResults.put(rsmd.getColumnName(tempPosition)+String.valueOf(masterLoop),String.valueOf(rs.getString(rsmd.getColumnName(tempPosition))));
			      }

		    	  if(rsmd.getColumnTypeName(tempPosition).toString().equalsIgnoreCase("varchar"))
		    	  {
		    		  logger.debug("varchar FOUND in resultset");
		    		  DataResults.put(rsmd.getColumnName(tempPosition)+String.valueOf(masterLoop),String.valueOf(rs.getString(rsmd.getColumnName(tempPosition))));
			      }

		    	  if(rsmd.getColumnTypeName(tempPosition).toString().equalsIgnoreCase("char"))
		    	  {
		    		  logger.debug("char FOUND in resultset");
		    		  DataResults.put(rsmd.getColumnName(tempPosition)+String.valueOf(masterLoop),String.valueOf(rs.getString(rsmd.getColumnName(tempPosition))));
			      }

		    	  
		    	  if(rsmd.getColumnTypeName(tempPosition).toString().equalsIgnoreCase("float"))
		    	  {
		    		  logger.debug("float FOUND in resultset");
		    		  DataResults.put(String.valueOf(rs.getFloat(rsmd.getColumnName(tempPosition)))+String.valueOf(masterLoop), rsmd.getColumnName(tempPosition));
			      }

		    	  if(rsmd.getColumnTypeName(tempPosition).toString().equalsIgnoreCase("REAL"))
		    	  {
		    		  logger.debug("real FOUND in resultset");
		    		  DataResults.put(rsmd.getColumnName(tempPosition)+String.valueOf(masterLoop),String.valueOf(rs.getFloat(rsmd.getColumnName(tempPosition))));
			      }
		    	}
	    	  	masterLoop = masterLoop+1;
	      }
	      rs.close();
	      stmt.close();
	      logger.info("***************** END in Memory SELECT Work*******************");
	    } 
	    catch ( Exception e ) 
	    {
	      logger.error("InMemory Select Operation failed " + e.toString() );
	      DataResults.put("",e.toString());
	      logger.debug("***************** END in Memory SELECT Work (WITH ERROR)*******************");
	    }
	    return printMap(DataResults);
	}
	
	public String inMemorySelectOperation(String sql)
	{
		logger.info("***************** Start in Memory SELECT Work*******************");
		Connection myInMemoryConnection = Create();
	    Statement stmt = null;
	    HashMap<String, String> DataResults = new HashMap<String, String>();
	    try 
	    {
	      myInMemoryConnection.setAutoCommit(false);
	      logger.debug("Opened in memory database successfully");


	      stmt = myInMemoryConnection.createStatement();
	      ResultSet rs = stmt.executeQuery( sql );
	      ResultSetMetaData rsmd=rs.getMetaData();
	      
	      int noOfColumns = rsmd.getColumnCount();
	      
	      for(int i = 1; i <= noOfColumns; i++ )
	      {
	    	  logger.debug("Columns/Type in resultSet are: " + rsmd.getColumnName(i) + " :" + rsmd.getColumnTypeName(i));
	      }
	      
	      logger.debug("Number of columns: "+noOfColumns); 
	      int masterLoop = 1;
	      while ( rs.next() ) 
	      {
	    	  logger.debug("*************************LOOP :");
	    	  for(int tempPosition=1;tempPosition<=noOfColumns;tempPosition++)
	    	  {

		    	  if(rsmd.getColumnTypeName(tempPosition).equalsIgnoreCase("int") )
		    	  {
		    		  logger.debug("INT FOUND in resultset");
		    		  DataResults.put(rsmd.getColumnName(tempPosition)+String.valueOf(masterLoop),String.valueOf(rs.getInt(rsmd.getColumnName(tempPosition))));
		    	  }

		    	  if(rsmd.getColumnTypeName(tempPosition).toString().equalsIgnoreCase("text"))
		    	  {
		    		  logger.debug("text FOUND in resultset");
		    		  DataResults.put(rsmd.getColumnName(tempPosition)+String.valueOf(masterLoop),String.valueOf(rs.getString(rsmd.getColumnName(tempPosition))));
			      }

		    	  if(rsmd.getColumnTypeName(tempPosition).toString().equalsIgnoreCase("varchar"))
		    	  {
		    		  logger.debug("varchar FOUND in resultset");
		    		  DataResults.put(rsmd.getColumnName(tempPosition)+String.valueOf(masterLoop),String.valueOf(rs.getString(rsmd.getColumnName(tempPosition))));
			      }

		    	  if(rsmd.getColumnTypeName(tempPosition).toString().equalsIgnoreCase("char"))
		    	  {
		    		  logger.debug("char FOUND in resultset");
		    		  DataResults.put(rsmd.getColumnName(tempPosition)+String.valueOf(masterLoop),String.valueOf(rs.getString(rsmd.getColumnName(tempPosition))));
			      }

		    	  
		    	  if(rsmd.getColumnTypeName(tempPosition).toString().equalsIgnoreCase("float"))
		    	  {
		    		  logger.debug("float FOUND in resultset");
		    		  DataResults.put(String.valueOf(rs.getFloat(rsmd.getColumnName(tempPosition)))+String.valueOf(masterLoop), rsmd.getColumnName(tempPosition));
			      }

		    	  if(rsmd.getColumnTypeName(tempPosition).toString().equalsIgnoreCase("REAL"))
		    	  {
		    		  logger.debug("real FOUND in resultset");
		    		  DataResults.put(rsmd.getColumnName(tempPosition)+String.valueOf(masterLoop),String.valueOf(rs.getFloat(rsmd.getColumnName(tempPosition))));
			      }
		    	}
	    	  	masterLoop = masterLoop+1;
	      }
	      rs.close();
	      stmt.close();
	      logger.info("***************** END in Memory SELECT Work*******************");
	    } 
	    catch ( Exception e ) 
	    {
	      logger.error("InMemory Select Operation failed " + e.toString() );
	      DataResults.put("",e.toString());
	      logger.debug("***************** END in Memory SELECT Work (WITH ERROR)*******************");
	    }
	    return printMap(DataResults);
	}

	public String printMap(Map mp) 
	{
		logger.info("Printing Map");
		String result = new String();
		
	    Iterator it = mp.entrySet().iterator();
	    while (it.hasNext()) 
	    {
	        Map.Entry pair = (Map.Entry)it.next();
	        result += "<tr><td>"+pair.getKey()+"</td><td>" +pair.getValue()+ "</td></tr>";
	        logger.debug(result);
	        logger.debug( pair.getKey()+ " = " + pair.getValue());
	        it.remove(); // avoids a ConcurrentModificationException
	    }
	    if(!result.isEmpty())
	    {
	    	  result = "<table>" + result + "</table>";
	    }
	    else
	    {
	    	result = "<table><tr><td>No Results Found</td></tr></table>";
	    }
	    return result;
	}

	
	

	public boolean inMemoryUpdateOperation()
	{
		boolean result = true;
		Connection myInMemoryConnection = Create();
	    Statement stmt = null;
	    try 
	    {
	      myInMemoryConnection.setAutoCommit(false);
	      logger.debug("Opened in memory database successfully");

	      stmt = myInMemoryConnection.createStatement();
	      String sql = "UPDATE COMPANY set SALARY = 25000.00 where ID=1;";
	      stmt.executeUpdate(sql);
	      myInMemoryConnection.commit();
	     
	      stmt.close();
	      
	      logger.info("InMemory Update Operation done successfully");
	    } 
	    catch ( Exception e ) 
	    {
	      logger.error("InMemory Update Operation failed" );
	      result=false;
	    }
	    
	    return result;
	}
	public String inMemoryInsertOperation(String id, String name, String age, String address, String salary)
	{
		String message = "";
		Connection myInMemoryConnection = Create();
	    Statement stmt = null;
	    
	    try 
	    {
	      myInMemoryConnection.setAutoCommit(false);
	      logger.debug("Opened in memory database successfully");
	      logger.debug("Parameters: "+id+" "+name+" "+age+" "+address+" "+salary);

	      stmt = myInMemoryConnection.createStatement();
	      
	      String sql = "INSERT into COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES ('"+id+"','"+name+"','"+age+"','"+address+"','"+salary+"') ";
	      
	      stmt.executeUpdate(sql);
	      myInMemoryConnection.commit();

	      stmt.close();
	     
	      logger.info("InMemory insert Operation done successfully");
	      message = "<table><tr><td>Insert Successful</td></tr></table>";

	    } 
	    catch ( Exception e ) 
	    {
	      logger.error("InMemory insert Operation failed" );
	      message = "<table><tr><td>Insert failed</td></tr></table>";
	    }
	    
	    return message;
	}
	
	public boolean inMemoryDeleteOperation()
	{
		boolean result = true;
		Connection myInMemoryConnection = Create();
	    Statement stmt = null;
	    
	    try 
	    {
	      myInMemoryConnection.setAutoCommit(false);
	      logger.debug("Opened in memory database successfully");
	      stmt = myInMemoryConnection.createStatement();
	      
	      String sql = "DELETE from COMPANY where ID=2;";
	      
	      stmt.executeUpdate(sql);
	      myInMemoryConnection.commit();

	      stmt.close();
	     
	      logger.info("InMemory Delete Operation done successfully");
	    } 
	    catch ( Exception e ) 
	    {
	      logger.error("InMemory Delete Operation failed" );
	      result=false;
	    }
	    
	    return result;
	}
	public boolean inMemoryCloseConnection()
	{
		boolean result = true;
		try
		{
			if(myInMemoryConnection != null)
	    	{
				myInMemoryConnection.close();
				myInMemoryConnection = null;
				logger.info("In Memory DB Connection Closed");
	    	}
			else
			{
				logger.info("No In Memory DB Connection to close");
			}
		}
		catch(Exception e)
		{
			logger.error("Error closing in memory DB connection: " + e.toString());
			result=false;
		}
		return result;
	}
}