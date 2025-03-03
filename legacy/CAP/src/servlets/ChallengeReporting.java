package servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import utils.Api;

@WebServlet("/reporting/challenges")
public class ChallengeReporting extends HttpServlet
{
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(UserReporting.class);
	
	public void doPost (HttpServletRequest request, HttpServletResponse response) 
	throws ServletException, IOException
	{
		logger.debug("User Report API Called");
		PrintWriter out = response.getWriter(); 
		out.print(getServletInfo());
		String jsonOutput = new String(Api.getChallengeStatistics().toString());
		out.write(jsonOutput);
	}
}
