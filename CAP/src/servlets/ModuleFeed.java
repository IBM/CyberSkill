package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.owasp.encoder.Encode;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

import utils.Api;
import utils.PropertiesReader;
import utils.SessionValidator;

@WebServlet("/moduleFeed")
public class ModuleFeed extends HttpServlet
{
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(ModuleFeed.class);
	
	@SuppressWarnings("unchecked")
	public void doGet(HttpServletRequest request, HttpServletResponse response) 
	throws ServletException, IOException
	{
		logger.debug("ModuleFeed.doGet()");
		PrintWriter out = response.getWriter();  
		HttpSession ses = request.getSession(true);
		
		
		if(SessionValidator.validate(ses)) {
			
			String operation = request.getParameter("operation");

			if( operation.equals("getTopPlayerScores")) {
				Api api = new Api();
				
				
				JSONArray scoresJsonArray = api.getTopScores(10,null);
				JSONObject scoresJsonObject = new JSONObject();
				scoresJsonObject.put("Scores", scoresJsonArray);
				
				response.setContentType("application/json");

				out.print(scoresJsonObject.toJSONString());
			} else 	if( operation.equals("getSimilarPlayerScores")) {
				Api api = new Api();
				
				JSONArray scoresJsonArray = api.getSimilarPlayerScores((String)ses.getAttribute("userName"),null);
				logger.debug("----- userName ------ " + ses.getAttribute("userName"));
				JSONObject scoresJsonObject = new JSONObject();
				scoresJsonObject.put("Scores", scoresJsonArray);
				
				response.setContentType("application/json");

				out.print(scoresJsonObject.toJSONString());
			} else if( operation.equals("getGlobalTopPlayerScores")) {
				Api api = new Api();
				
				
				JSONArray scoresJsonArray = api.getGlobalTopScores(10);
				JSONObject scoresJsonObject = new JSONObject();
				scoresJsonObject.put("Scores", scoresJsonArray);
				
				response.setContentType("application/json");

				out.print(scoresJsonObject.toJSONString());
			} else 	if( operation.equals("getGlobalSimilarPlayerScores")) {
				Api api = new Api();
				
				JSONArray scoresJsonArray = api.getGlobalSimilarPlayerScores((String)ses.getAttribute("userName"));
				JSONObject scoresJsonObject = new JSONObject();
				scoresJsonObject.put("Scores", scoresJsonArray);
				
				response.setContentType("application/json");

				out.print(scoresJsonObject.toJSONString());
			}
		}


		
	}
	
	@SuppressWarnings("unchecked")
	public void doPost (HttpServletRequest request, HttpServletResponse response) 
	throws ServletException, IOException
	{
		logger.debug("Module Feed Servlet do post");
		
		
		
		PrintWriter out = response.getWriter();  
		out.print(getServletInfo());
		HttpSession ses = request.getSession(true);
		if(SessionValidator.validate(ses))
		{
			
			Properties siteProperties = PropertiesReader.readSiteProperties();
			String monitor = siteProperties.getProperty("monitor");
			if(monitor.compareToIgnoreCase("true")==0)
			{
				logger.debug("The monitor utility is currently active");
				String username=(String)ses.getAttribute("userName");
				try
				{
					Api.incrementModuleFeedRequestByUsername(username);
					logger.debug("successfully called incrementModuleFeedRequestByUsername("+username +")");
				}
				catch(Error e)
				{
					logger.error("Unable to complete incrementModuleFeedRequestByUsername("+ username +") : " + e.toString());
				}
				
			}
			else
			{
				logger.debug("The monitor utility is currently de-activated");
			}
			
			
			try
			{
				Api api = new Api();
				ArrayList<String[]> moduleArray = api.getUserModuleFeed((String)ses.getAttribute("userName"));
				
				JSONArray json = new JSONArray();
				JSONObject jsonInner = new JSONObject();
				
				for (int i = 0; i < moduleArray.size(); i++)
				{
					String[] currentModule = moduleArray.get(i); //Get module string[] from the array list to populate JSON Object
					logger.debug(">>>>>>> Module Array consist of:");
					for (String s: currentModule) {           
					    //Do your stuff here
					    logger.debug(s); 
					}
					jsonInner = new JSONObject(); //Clear JSON Object
					jsonInner.put("moduleId", Encode.forHtml(currentModule[0]));
					jsonInner.put("moduleName", Encode.forHtml(currentModule[1]));
					jsonInner.put("moduleCategory", Encode.forHtml(currentModule[2]));
					jsonInner.put("completedStatus", Encode.forHtml(currentModule[3]));
					jsonInner.put("moduleScore", Encode.forHtml(currentModule[4]));
					jsonInner.put("moduleRank", Encode.forHtml(currentModule[4]));
					jsonInner.put("gold", Encode.forHtml(currentModule[5]));
					jsonInner.put("silver", Encode.forHtml(currentModule[6]));
					jsonInner.put("bronze", Encode.forHtml(currentModule[7]));
					jsonInner.put("moduleDirectory", Encode.forHtml(currentModule[8]));
					json.add(jsonInner); //Add JSON Object to JSON Array
				}
				logger.debug(json.toString());
				out.write(json.toString()); //Output JSON array to HTTP Response
			}
			catch (Exception e)
			{
				logger.error("Module Feed Error: " + e.toString());
			}
		}
		else
		{
			logger.error("Invalid Session Detected");
		}
		logger.debug("Exiting Get Module Feed");
	}
}
