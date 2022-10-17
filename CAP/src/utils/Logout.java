package utils;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Logout")
public class Logout extends HttpServlet 
{
	private static final long serialVersionUID = 1L;
	private static final Logger logger = LoggerFactory.getLogger(Logout.class);
    static String error = "0";   
    	
	/**
     * @see HttpServlet#HttpServlet()
     */
    public Logout() {
        super();
        // TODO Auto-generated constructor stub
    }
	
   	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		HttpSession ses = request.getSession(true);
		ses.setAttribute("userName", ""); //login
		ses.setAttribute("userPk", ""); //also Login
		ses.setAttribute("login", ""); //also Login
		ses.invalidate();
		ses = request.getSession(true);	
		response.sendRedirect("index.jsp");
	}
	
}
