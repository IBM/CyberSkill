package messaging.thejasonengine.com;

import java.util.ArrayList;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.http.ServerWebSocket;

public class Websocket {
	
	private static final Logger LOGGER = LogManager.getLogger(Websocket.class);
	public void addNewSocket(ServerWebSocket webSocket)
	{
		LOGGER.debug("adding a new socket");
		
		ArrayList<ServerWebSocket> webSocketArrayList = new ArrayList<>();
		webSocketArrayList.add(webSocket);
		
	}
	
	public void removeSocket(ServerWebSocket webSocket)
	{
		LOGGER.debug("removing a socket");
		
		ArrayList<ServerWebSocket> webSocketArrayList = new ArrayList<>();
		if (webSocketArrayList.contains(webSocket)) 
        {
        	webSocketArrayList.remove(webSocket);
            LOGGER.debug("Socket was removed from the websocket manager.");
        } 
        else 
        {
            LOGGER.debug("Socket is not in the websocket manager.");
        }
	}
	
	public void recieveMessageFromClient(String message)
	{
		LOGGER.debug("Recieved message from client: " + message);
	}
	
	public void sendMessageToClient(ServerWebSocket webSocket)
	{
		String message = "test";
		LOGGER.debug("Sending message to client: " + message);
		webSocket.writeTextMessage("Echo: " + message);
	}
	public void sendMessageToAllConnectedClients(ArrayList<ServerWebSocket> webSocket)
	{
		String message = "test";
		int i = 1;
		for (ServerWebSocket ws : webSocket) 
		{
			LOGGER.debug("Sending message to client[" +i+ "]: " + message);
			ws.writeTextMessage("Echo: " + message);
			i = i+1;
		}
		
	}
	

}
