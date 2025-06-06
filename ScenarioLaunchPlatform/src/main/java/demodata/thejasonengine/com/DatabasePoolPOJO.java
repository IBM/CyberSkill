package demodata.thejasonengine.com;

import java.io.Serializable;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class DatabasePoolPOJO implements Serializable 
{
	private static final Logger LOGGER = LogManager.getLogger(DatabasePoolPOJO.class);
	
	private String Status;
	private BasicDataSource BDS;
	
	public String getStatus() 
	{
		LOGGER.debug("Status of Basic Datasource:" + Status);
		return Status;
	}
	public void setStatus(String status) {
		LOGGER.debug("Setting BasicDataSourceStatus:" + status);
		this.Status = status;
	}
	public BasicDataSource getBDS() 
	{
		LOGGER.debug("Retrieving BasicDataSource");
		return BDS;
	}
	public void setBDS(BasicDataSource bDS) 
	{
		LOGGER.debug("Setting BasicDataSource");
		this.BDS = bDS;
	}
		
	
}
