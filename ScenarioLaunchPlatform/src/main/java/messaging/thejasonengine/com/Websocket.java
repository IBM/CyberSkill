package messaging.thejasonengine.com;

import java.util.ArrayList;
import java.util.Iterator;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.http.ServerWebSocket;
import memory.thejasonengine.com.Ram;

public class Websocket {
	
	public class StorySocket 
	{
        private String username;
        private ServerWebSocket websocket;

        // Constructor
        public StorySocket(ServerWebSocket websocket, String username) {
            this.websocket = websocket;
            this.username = username;
        }
        /*************************************************/
        public void setWebsocket(ServerWebSocket websocket)
        {
        	this.websocket = websocket;
        }
        public ServerWebSocket getWebsocket()
        {
        	return websocket;
        }
        /***************************************************/
        public void setUsername(String username)
        {
        	this.username = username;
        }
        public String getUsername()
        {
        	return username;
        }
        /***************************************************/
	}
	/*******************************************************************************/
	private static final Logger LOGGER = LogManager.getLogger(Websocket.class);
	public void addNewSocket(ServerWebSocket webSocket, String username)
	{
		LOGGER.debug("adding a new socket");
		Ram ram = new Ram();
		StorySocket ss = new StorySocket(webSocket, username);
		
		ArrayList<StorySocket> webSocketArrayList = ram.getStorySocketList();
		if(webSocketArrayList == null)
		{
			LOGGER.debug("webSocketArrayList is null --- initializing");
			webSocketArrayList = new ArrayList<StorySocket>();
		}
		
		webSocketArrayList.add(ss);
		ram.setStorySocketList(webSocketArrayList);
		LOGGER.debug("Successfully added websocket to array list");
		
	}
	/*******************************************************************************/
	public void removeSocket(ServerWebSocket webSocket)
	{
		LOGGER.debug("removing a socket");
		
		Ram ram = new Ram();
		
		ArrayList<StorySocket> webSocketArrayList = ram.getStorySocketList();
		if(webSocketArrayList == null)
		{
			LOGGER.debug("webSocketArrayList is null --- initializing");
			webSocketArrayList = new ArrayList<StorySocket>();
		}
		
		Iterator<StorySocket> iterator = webSocketArrayList.iterator();
        while (iterator.hasNext()) 
        {
        	StorySocket ss = iterator.next();
            if (ss.getWebsocket().equals(webSocket)) 
            {
                iterator.remove(); // Removes the element from the list
            }
        }
        ram.setStorySocketList(webSocketArrayList);
        LOGGER.debug("Successfully removed socket from array list");
	}
	/*******************************************************************************/
	public void recieveMessageFromClient(String message, String username)
	{
		LOGGER.debug("Recieved message from " + username + " : " + message);
	}
	/*******************************************************************************/
	public void sendMessageToClient(String username, String message)
	{
		Ram ram = new Ram();
		
		ArrayList<StorySocket> webSocketArrayList = ram.getStorySocketList();
		if(webSocketArrayList == null)
		{
			LOGGER.debug("webSocketArrayList is null --- initializing");
			webSocketArrayList = new ArrayList<StorySocket>();
		}
		
		Iterator<StorySocket> iterator = webSocketArrayList.iterator();
        while (iterator.hasNext()) 
        {
        	StorySocket ss = iterator.next();
            if (ss.getUsername().equals(username)) 
            {
            	ss.getWebsocket().writeTextMessage(message);
            }
        }
	}
	/*******************************************************************************/
	public void sendMessageToAllConnectedClients(String message)
	{
		Ram ram = new Ram();
		
		ArrayList<StorySocket> webSocketArrayList = ram.getStorySocketList();
		if(webSocketArrayList == null)
		{
			LOGGER.debug("webSocketArrayList is null --- initializing");
			webSocketArrayList = new ArrayList<StorySocket>();
		}
		
		Iterator<StorySocket> iterator = webSocketArrayList.iterator();
        while (iterator.hasNext()) 
        {
        	StorySocket ss = iterator.next();
            ss.getWebsocket().writeTextMessage(message);
        }
	}
	/*******************************************************************************/
	
}
