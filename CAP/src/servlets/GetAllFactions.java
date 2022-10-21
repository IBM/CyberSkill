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
 * Servlet implementation class getallFactions
 */
@WebServlet("/getAllFactions")
public class GetAllFactions extends HttpServlet{
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(GetAllFactions.class);
	
	 /**
     * @see HttpServlet#HttpServlet()
     */
    public GetAllFactions() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    /**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		logger.debug("getAllFactions Feed Servlet");
		PrintWriter out = response.getWriter();  
		out.print(getServletInfo());
		HttpSession ses = request.getSession(false);
		if(SessionValidator.validate(ses))
		{
		try
		{
			Api api = new Api();
			ArrayList<String[]> factionArray = api.getAllFactions();
			JSONArray json = new JSONArray();
			JSONObject jsonInner = new JSONObject();
			
			for (int i = 0; i < factionArray.size(); i++)
			{
				String[] currentFaction = factionArray.get(i); //Get level string[] from the array list to populate JSON Object
				jsonInner = new JSONObject(); //Clear JSON Object
				jsonInner.put("faction", Encode.forHtml(currentFaction[0]));
				json.add(jsonInner); //Add JSON Object to JSON Array
			}
			out.write(json.toString()); //Output JSON array to HTTP Response
		}
		catch (Exception e)
		{
			logger.error("getAllFactions Error: " + e.toString());
		}
		}
		logger.debug("Exiting getAllFactions Feed");
	}

}
