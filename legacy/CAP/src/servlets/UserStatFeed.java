package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import utils.Api;
import utils.SessionValidator;

@WebServlet("/userStats")
public class UserStatFeed extends HttpServlet
{
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(UserStatFeed.class);
	
	public void doPost (HttpServletRequest request, HttpServletResponse response) 
	throws ServletException, IOException
	{
		logger.debug("User Stat Feed Called");
		PrintWriter out = response.getWriter(); 
		out.print(getServletInfo());
		HttpSession ses = request.getSession(true);
		if(SessionValidator.validate(ses))
		{
			String login = (String)ses.getAttribute("login");
			logger.debug("User Stat Feed called by " + login);
			Api api = new Api();
			String jsonOutput = new String(api.userStatCall(login));
			out.write(jsonOutput);
		}
	}
}
