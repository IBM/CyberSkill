/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package pojos.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.Context;
import io.vertx.core.Vertx;
import io.vertx.pgclient.PgConnectOptions;
import io.vertx.sqlclient.Pool;
import io.vertx.sqlclient.PoolOptions;


public class DatasourcePojo 
{
	private static final Logger LOGGER = LogManager.getLogger(DatasourcePojo.class);
	private Pool pool;
	private String databaseType;
	private String databaseId;
	private String username;
	private String password;
	private String port;
	private String host;
	private String databaseName;
	
	
	public Pool DatasourcePojo(String databaseType, Vertx vertx) 
	{
	    Pool pool = null;
		if(databaseType.compareToIgnoreCase("postgres")==0)
	    {
	        pool = createPostgresPool(vertx);
	    }
	    return pool;
	}
	// Method to create and configure the DataSource (HikariCP in this case)
    private Pool createPostgresPool(Vertx vertx) 
    {
    	 // PostgreSQL connection options
		PgConnectOptions connectOptions = new PgConnectOptions()
			      .setHost("localhost")
			      .setPort(5432)
			      .setDatabase("SLP")
			      .setUser("postgres")
			      .setPassword("postgres");

		// Create a connection pool (this uses the Pool interface from SqlClient)
        PoolOptions poolOptions = new PoolOptions().setMaxSize(10); // Max pool size
        LOGGER.debug("Set postgres pool options");
        Pool pool = Pool.pool(vertx, connectOptions, poolOptions);
        LOGGER.debug("Postgres pool created");
        return pool;
    }
	
	/****************************************************/
	public Pool getPool() 
	{
		return pool;
	}

	public void setPool(Pool pool) 
	{
		this.pool = pool;
	}
	/****************************************************/
	public String getDatabaseType() {
		return databaseType;
	}

	public void setDatabaseType(String databaseType) {
		this.databaseType = databaseType;
	}
	/****************************************************/
	public String getDatabaseId() {
		return databaseId;
	}

	public void setDatabaseId(String databaseId) {
		this.databaseId = databaseId;
	}
	/****************************************************/
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	/****************************************************/
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}
	/****************************************************/
	public String getPort() {
		return port;
	}

	public void setPort(String port) {
		this.port = port;
	}
	/****************************************************/
	public String getHost() {
		return host;
	}

	public void setHost(String host) {
		this.host = host;
	}
  
	/****************************************************/
	public String getDatabaseName() {
		return databaseName;
	}

	public void setDatabaseName(String databaseName) {
		this.databaseName = databaseName;
	}
}



