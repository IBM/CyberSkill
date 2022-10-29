package servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.owasp.encoder.Encode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import utils.Api;
import utils.SessionValidator;

/**
 * Servlet implementation class getallLevels
 */
@WebServlet("/get10MostRecentOpenLevels")
public class Get10MostRecentOpenLevels extends HttpServlet{
	
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(Get10MostRecentOpenLevels.class);
	
	/**
     * @see HttpServlet#HttpServlet()
     */
    public Get10MostRecentOpenLevels() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		logger.debug("Get10MostRecentOpenLevels Feed Servlet");
		PrintWriter out = response.getWriter();  
		out.print(getServletInfo());
		HttpSession ses = request.getSession(false);
		if(SessionValidator.validate(ses))
		{
			logger.debug("Session is valid");
			try
			{
				Api api = new Api();
				ArrayList<String[]> levelsArray = api.get10MostRecentEnabledLevels();
				JSONArray json = new JSONArray();
				JSONObject jsonInner = new JSONObject();
				for (int i = 0; i < levelsArray.size(); i++)
				{
					String[] openedLevel = levelsArray.get(i);
					jsonInner = new JSONObject(); //Clear JSON Object
					jsonInner.put("id", Encode.forHtml(openedLevel[0]));
					jsonInner.put("name", Encode.forHtml(openedLevel[1]));
					jsonInner.put("category", Encode.forHtml(openedLevel[2]));
					jsonInner.put("status", Encode.forHtml(openedLevel[3]));
					jsonInner.put("originalScore", Encode.forHtml(openedLevel[4]));
					jsonInner.put("timeopened", Encode.forHtml(openedLevel[5]));
					json.add(jsonInner); //Add JSON Object to JSON Array
					
				}
				out.write(json.toString()); //Output JSON array to HTTP Response
			}
			catch (Exception e)
			{
				logger.error("Error 1.1SESE Get10MostRecentOpenLevels Error: " + e.toString());
			}
		}
		else
		{
			logger.error("Error 1.2UISD Invalid Session Detected");
		}
		logger.debug("Exiting Get10MostRecentOpenLevels Feed");
	}
	public void doPost (HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException
			{
				logger.error("Error 7.2UDIP Detected on Post on Get10MostRecentOpenLevels - this should not have happened");
			}
}

