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
 * Servlet implementation class getAllScoresByDate
 */
@WebServlet("/getAllScoresByFaction")
public class GetAllScoresByFaction extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(GetAllScoresByFaction.class);
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetAllScoresByFaction() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		logger.debug("getAllScoresByDate Feed Servlet");
		PrintWriter out = response.getWriter();  
		out.print(getServletInfo());
		HttpSession ses = request.getSession(true);
		String faction = request.getParameter("faction");
		if(SessionValidator.validate(ses))
		{
			try
			{
				Api api = new Api();
				ArrayList<String[]> moduleArray = api.getAllScoresByFaction(faction);
				JSONArray json = new JSONArray();
				JSONObject jsonInner = new JSONObject();
				
				for (int i = 0; i < moduleArray.size(); i++)
				{
					String[] currentModule = moduleArray.get(i); //Get level string[] from the array list to populate JSON Object
					jsonInner = new JSONObject(); //Clear JSON Object
					jsonInner.put("username", Encode.forHtml(currentModule[0]));
					jsonInner.put("sum", Encode.forHtml(currentModule[1]));
					
					json.add(jsonInner); //Add JSON Object to JSON Array
				}
				out.write(json.toString()); //Output JSON array to HTTP Response
			}
			catch (Exception e)
			{
				logger.error("getAllScoresByDate Error: " + e.toString());
			}
		}
		else
		{
			logger.error("Invalid Session Detected");
		}
		logger.debug("Exiting getAllScoresByDate Feed");
	}

	public void doPost (HttpServletRequest request, HttpServletResponse response) 
	throws ServletException, IOException
	{
		logger.error("Detected on Post on getAllScoresByDate - this should not have happened");
	}

}
