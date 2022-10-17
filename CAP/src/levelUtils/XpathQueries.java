package levelUtils;

import java.io.FileInputStream;
import java.io.IOException;

//import com.sun.org.apache.xml.internal.security.utils.XPathFactory;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class XpathQueries {

	
	private static String XpathQuery = "";
	private static String xmlFilePath = "";
	
	public static void main(String[] args) throws XPathExpressionException {
		// TODO Auto-generated method stub
		System.out.println("Sup this is a test");
		
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db;
		boolean test = authenicate("Admin", "'or username='Admin' and 'a'='a");
		System.out.println("authenication testing : "+test);
		System.out.println("Ending Xpath test.");
	
	}

	private static void check(org.w3c.dom.Document document, String expression, String check) throws XPathExpressionException
	{
		boolean flag = false;
		// getting string value and compairing it. 
		XPath xpath = XPathFactory.newInstance().newXPath();
		String result = xpath.compile(expression).evaluate(document);
		System.out.println("The expression returned was: "+ result);
		
		if(result.matches(check))
		flag = true;
		
		System.out.println("The result of the check was: "+ result + " and flag is "+flag);
		
	}
	
	public static boolean authenicate(String username, String password)
	{
		boolean auth = false;
		
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db;
		
		XPath xpath = XPathFactory.newInstance().newXPath();
		String passwordcheck = "";
		
		
		try {
			db = dbf.newDocumentBuilder();
			org.w3c.dom.Document document = db.parse(new FileInputStream(xmlFilePath));
			XpathQuery = XpathQuery.replaceAll("INPUT1", username);
			XpathQuery = XpathQuery.replaceAll("INPUT2", password);
			System.out.println("Xquery is :"+XpathQuery);
			
			NodeList nodes = (NodeList) xpath.evaluate(XpathQuery, document, XPathConstants.NODESET);
			
			//passwordcheck = xpath.compile(XpathQuery).evaluate(document);
			
			if(nodes.getLength() == 1)
			{
				System.out.println("This matches");
				auth = true;
			}
			
			
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (XPathExpressionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return auth;
		
	}
	
	public void setXpathQuery(String xpathQ)
	{
		XpathQuery = xpathQ;
	}
	
	public void setXmlFile(String Xfilepath)
	{
		xmlFilePath = Xfilepath;
	}
	
}
