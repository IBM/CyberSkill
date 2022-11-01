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
 * 
 * @author John Clarke
 *  Servlet implementation class getAdminComments
 * 
 *
 */
@WebServlet("/getAdminComments")
public class GetAdminComments extends HttpServlet{
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(GetAdminComments.class);
	
	 /**
     * @see HttpServlet#HttpServlet()
     */
    public GetAdminComments() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    /**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		logger.debug("getAdminComments Feed Servlet");
		PrintWriter out = response.getWriter();  
		out.print(getServletInfo());
		HttpSession ses = request.getSession(false);
		if(SessionValidator.validate(ses))
		{
		try
		{
			Api api = new Api();
			ArrayList<String[]> commentArray = api.getAdminComments();
			JSONArray json = new JSONArray();
			JSONObject jsonInner = new JSONObject();
			
			for (int i = 0; i < commentArray.size(); i++)
			{
				String[] currentComment = commentArray.get(i); //Get faction string[] from the array list to populate JSON Object
				jsonInner = new JSONObject(); //Clear JSON Object
				jsonInner.put("firstname", Encode.forHtml(currentComment[0]));
				jsonInner.put("lastname", Encode.forHtml(currentComment[1]));
				jsonInner.put("username", Encode.forHtml(currentComment[2]));
				jsonInner.put("thecomments", Encode.forHtml(currentComment[3]));
				jsonInner.put("submitted", Encode.forHtml(currentComment[4]));
				json.add(jsonInner); //Add JSON Object to JSON Array
			}
			out.write(json.toString()); //Output JSON array to HTTP Response
		}
		catch (Exception e)
		{
			logger.error("getAdminComments Error: " + e.toString());
		}
		}
		logger.debug("Exiting getAdminComments Feed");
	}
}
