package levelUtils;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Servlet implementation class XSSCheck
 * this class has an identical post and get method where
 *  the attack parameter MUST be base64 encoded before it is sent to this servlet.
 * pass the GET or POST parameter 'attack' to this servlet and it
 * will respond with a 'true' or 'false' value. 
 *  'true' returned when the attack string contains a viable xss parameter.
 *  
 *  to call  this class use the url example http://localhost:8080/TradCTF/XSSCheck?attack=PGltZyBzcmM9IiMiIG9uZXJyb3I9ImFsZXJ0KDEpIiAvPg==
 *  replacing the base64 value with the user entered attack vector.
 * 
 */
@WebServlet("/XSSCheck")
public class XSSCheck extends HttpServlet {
	private static final long serialVersionUID = 1L;
	 private final static Logger logger = LoggerFactory.getLogger(XSSCheck.class);
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public XSSCheck() {
        super();
        // TODO Auto-generated constructor stub
    }
    /**
     * Pass a string to this method and it will return a true or false
     * depending on whether the string contains an xss or not
     * @param attackIN 
     * @return boolean 
     */
    public static boolean check(String attackIN)
    {
		// TODO Auto-generated method stub
		logger.debug("Checking XSS vector");
			
			String userAttackVector = attackIN;
			
			XSSChecker x = new XSSChecker();
		try {
				String tmpdir = System.getProperty("java.io.tmpdir");
				PrintWriter writer = new PrintWriter(tmpdir + "/temp.jsp", "UTF-8");
				//replace the string below with the users input for checking
				writer.println(userAttackVector);
				writer.flush();
				writer.close();
				File f = new File(tmpdir + "/temp.jsp");

				boolean result = x.verifyXss(f,"");
				
				f.delete();
				return result;
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		return false;
    	
    }


	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		logger.debug("Checking XSS vector");
			
			String userAttackVector = request.getParameter("attack");
		
			String decoded = new String(DatatypeConverter.parseBase64Binary(userAttackVector));
	        
			
			XSSChecker x = new XSSChecker();
			PrintWriter writer = new PrintWriter("temp.jsp", "UTF-8");
			
			//replace the string below with the users input for checking
			writer.println(decoded);
			writer.flush();
			writer.close();
			
			//create a temporary file to send for checking it's contents
			File f = new File("temp.jsp");
			logger.debug(f.getCanonicalPath());
			
			try {
				
				boolean result = x.verifyXss(f,"");
				f.delete();
				PrintWriter out = response.getWriter();
				out.write(""+result);
				out.flush();
				out.close();
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	logger.debug("Checking XSS vector");
		
		String userAttackVector = request.getParameter("attack");
		
		String decoded = new String(DatatypeConverter.parseBase64Binary(userAttackVector));
	    
		
		XSSChecker x = new XSSChecker();
		PrintWriter writer = new PrintWriter("temp.jsp", "UTF-8");
		
		//replace the string below with the users input for checking
		writer.println(decoded);;
		writer.flush();
		writer.close();
		
		//create a temporary file to send for checking it's contents
		File f = new File("temp.jsp");
		logger.debug(f.getCanonicalPath());
		
		try {
			
			boolean result = x.verifyXss(f,"");
			f.delete();
			PrintWriter out = response.getWriter();
			out.write(""+result);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	

	}

}
