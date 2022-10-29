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

import io.jsonwebtoken.Claims;
import utils.Api;
import utils.JWT;
import utils.SessionValidator;

/**
 * Servlet implementation class getAllScoresByDate
 */
@WebServlet("/getAllMembersOfMyFaction")
public class GetAllMembersOfMyFaction extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(GetAllMembersOfMyFaction.class);
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetAllMembersOfMyFaction() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		logger.debug("getAllMembersOfMyFaction Feed Servlet");
		PrintWriter out = response.getWriter();  
		out.print(getServletInfo());
		HttpSession ses = request.getSession(true);
		if(SessionValidator.validate(ses))
		{
			try
			{
				Claims claim  = JWT.decodeJWT(ses.getAttribute("JWT").toString());
				String faction = (String) claim.get("faction");
				Api api = new Api();
				logger.debug("Getting all members of " + faction + " faction");
				ArrayList<String[]> moduleArray = api.getAllMembersOfMyFaction(faction);
				logger.debug("Total number of members: "  + moduleArray.size());
				JSONArray json = new JSONArray();
				JSONObject jsonInner = new JSONObject();
				
				for (int i = 0; i < moduleArray.size(); i++)
				{
					String[] currentModule = moduleArray.get(i); //Get level string[] from the array list to populate JSON Object
						jsonInner = new JSONObject(); //Clear JSON Object
						jsonInner.put("firstname", Encode.forHtml(currentModule[0]));
						jsonInner.put("lastname", Encode.forHtml(currentModule[1]));
						jsonInner.put("email", Encode.forHtml(currentModule[2]));
						jsonInner.put("username", Encode.forHtml(currentModule[3]));
					json.add(jsonInner); //Add JSON Object to JSON Array
				}
				out.write(json.toString()); //Output JSON array to HTTP Response
			}
			catch (Exception e)
			{
				logger.error("getAllMembersOfMyFaction Error: " + e.toString());
			}
		}
		else
		{
			logger.error("Invalid Session Detected");
		}
		logger.debug("Exiting getAllMembersOfMyFaction Feed");
	}

	public void doPost (HttpServletRequest request, HttpServletResponse response) 
	throws ServletException, IOException
	{
		logger.error("Detected on Post on getAllMembersOfMyFaction - this should not have happened");
	}

}
