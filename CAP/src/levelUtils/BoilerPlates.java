package levelUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.owasp.encoder.Encode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import utils.JSONUtil;

public class BoilerPlates {
	private static final Logger logger = LoggerFactory.getLogger(BoilerPlates.class);
	private static final String commonHeader = new String("<% /* Common Header */ %>\n"
			+ "<%@ page import=\"utils.SessionValidator\"%>\n" + "<% HttpSession ses = request.getSession(true);\n"
			+ "if(SessionValidator.validate(ses)){\n\n" + "%>\n\n"
			+ "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>CAP Project - Chicken</title>\n"
			+ "<meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0;\">"
			+ "<link href=\"css/global.css\" rel=\"stylesheet\" type=\"text/css\" media=\"screen\" /></head>\n"
			+ "<body>\n" + "<script type=\"text/javascript\" src=\"../js/jquery-2.1.1.min.js\"></script>\n"
			+ "<jsp:include page=\"../header.jsp\" /> <% //Header Entry %>"
			+ "<jsp:include page=\"../levelFront.jsp\" /> <% //Level Front Entry %>\n");
	private static final String commonFooter = new String("<% /* Common Footer */ %>\n"
			+ "<jsp:include page=\"../levelBottom.jsp\" /> <% //Level Bottom Entry %>\n" + "\n</body></html>\n\n"
			+ "<% } else { %>\n" + "You are not currently signed in. Please Sign in<% } %>\n\n");
	private static final String commonSolution = new String("<% /* Common Solution */ "
			+ "String uri = request.getRequestURI();" + "String level = uri.substring(uri.lastIndexOf(\"/\")+1);"
			+ "%>\n" + "" + "<form id=\"solutionInput\" ACTION=\"javascript:;\" method=\"POST\">"
			+ "<em class=\"formLabel\">Solution Key: </em>\n"
			+ "<input id=\"key\" name=\"key\" type='text' autocomplete=\"off\">"
			+ "<input type=\"submit\" value=\"Submit\">"
			+ "<input type=\"hidden\" id =\"level\" name=\"level\" value=\"<%=  java.net.URLDecoder.decode(level, \"UTF-8\").substring(0, java.net.URLDecoder.decode(level, \"UTF-8\").length()-4) %>\">"
			+ "</form>\n" + "<div id=\"solutionSubmitResults\"></div>" + "\n");
	private static final String commonXssInstructions = new String("<h1>Please note that:</h1>"
			+ "<ul><li>An 'XSS' (in terms of the game) means getting a JavaScript alert box, prompt box, or confirm box to display</li>"
			+ "<li>The alert box must be displayed within the context of this page, i.e. not in the url or loaded from an external src</li>"
			+ "<li>Any code that requires some form of manual user interaction (e.g. click, press a key, etc.) to get an alert dialog to display might not complete the level. The alert dialog should display itself automatically.</li>"
			+ "</ul>");

	private static final String commonHeaderRobots = new String("<% /* Common Header */ %>\n"
			+ "<%@ page import=\"utils.SessionValidator\"%>\n" + "<% HttpSession ses = request.getSession(true);\n"
			+ "if(SessionValidator.validate(ses)){\n\n" + "%>\n\n"
			+ "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><title>CAP Project - Chicekn</title>\n"
			+ "<link href=\"../../css/global.css\" rel=\"stylesheet\" type=\"text/css\" media=\"screen\" /></head>\n"
			+ "<body>\n" + "<script type=\"text/javascript\" src=\"../../js/jquery-2.1.1.min.js\"></script>\n"
			+ "<jsp:include page=\"../../header.jsp\" /> <% //Header Entry %>"
			+ "<jsp:include page=\"../../levelFront.jsp\" /> <% //Level Front Entry %>\n");
	private static final String commonFooterRobots = new String("<% /* Common Footer */ %>\n"
			+ "<jsp:include page=\"../../levelBottom.jsp\" /> <% //Level Bottom Entry %>\n" + "\n</body></html>\n\n"
			+ "<% } else { %>\n" + "You are not currently signed in. Please Sign in<% } %>\n\n");


	public static boolean applyBoilerPlate(Level theLevel, String applicationRoot) {
		logger.debug("Runninng applyBoilerPlate method");
		logger.debug("ApplicationRoot: " + applicationRoot);
		boolean result = true;
		try {
			String boilerPlateType = theLevel.boilerPlate;
			if (boilerPlateType.equalsIgnoreCase("sql_injection_1")) {
				BoilerPlates.sqlInjection1(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("sql_injection_2")) {
				BoilerPlates.sqlInjection2(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("sql_injection_3")) {
				BoilerPlates.sqlInjection3(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("sql_injection_4")) {
				BoilerPlates.sqlInjection4(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("sql_injection_5")) {
				BoilerPlates.sqlInjection5(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("xss_1")) {
				BoilerPlates.xssBoilerPlateTypeOne(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("xss_2")) {
				BoilerPlates.xssBoilerPlateTypeTwo(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("xss_3")) {
				BoilerPlates.xssBoilerPlateTypeThree(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("xss_4")) {
				BoilerPlates.xssBoilerPlateTypeFour(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("xss_5")) {
				BoilerPlates.xssBoilerPlateTypeFive(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("offline_1")) {
				BoilerPlates.offline1(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("uncontrolled_format_string")) {
				BoilerPlates.uncontrolledFormatString(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("unauthorisedAccess_1")) {
				BoilerPlates.unauthorisedAccess1(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("csrf_1")) {
				BoilerPlates.csrf1(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("openRedirect_1")) {
				BoilerPlates.openRedirect1(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("hash_1")) {
				BoilerPlates.hashBoilerPlateTypeOne(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("hash2")) {
				BoilerPlates.hashBoilerPlateTypeTwo(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("file_upload_1")) {
				BoilerPlates.fileUploadTypeOne(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("os_command_injection_1")) {
				BoilerPlates.osCommandInjectionOne(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("csrf_2")) {
				BoilerPlates.csrfBoilerPlateTypeTwo(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("csrf_3")) {
				BoilerPlates.csrfBoilerPlateTypeThree(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("missing_authorization")) {
				BoilerPlates.missingAuthorization(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("broken_cryptography")) {
				BoilerPlates.brokenCryptography(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("reliance_on_untrusted_inputs")) {
				BoilerPlates.relianceOnUntrustedInputs(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("offlineQuestionsAndAnswers")) {
				BoilerPlates.offlineQuestionsAndAnswers(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("use_of_hard_coded_creds")) {
				BoilerPlates.useOfHardCodedCreds(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("data_validation_1")) {
				BoilerPlates.dataValidationOne(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("integer_overflow_1")) {
				BoilerPlates.integerOverflowOne(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("missingAuthForFunction_1")) {
				BoilerPlates.missingAuthForFunctBoilerPlateTypeOne(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("broken_crypto_2")) {
				BoilerPlates.brokenCrypto2(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("broken_crypto_4")) {
				BoilerPlates.brokenCrypto3(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("missing_encryption_of_sensitive_data")) {
				BoilerPlates.missingEncryptionOfSensitiveData(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("improper_restriction_of_login_attempts")) {
				BoilerPlates.improperRestrictionOfLoginAttempts(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("unauthorisedAccess2")) {
				BoilerPlates.unauthorisedAccess2(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("broken_session_management_1")) {
				BoilerPlates.brokenSessionManagementOne(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("broken_session_management_2")) {
				BoilerPlates.brokenSessionManagementTwo(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("classic_buffer_overflow_1")) {
				BoilerPlates.classicBufferOverflow(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("file_upload_2")) {
				BoilerPlates.fileUploadTypeTwo(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("sourceCode")) {
				BoilerPlates.sourceCode(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("offlineImageEmbed")) {
				BoilerPlates.offlineImageEmbed(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("externallyHostedContent")) {
				BoilerPlates.externallyHostedContent(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("verbose_error_message_1")) {
				BoilerPlates.verboseErrorMessageOne(theLevel, applicationRoot);
			} else if (boilerPlateType.equalsIgnoreCase("broken_access_control")) {
				BoilerPlates.brokenAccessControlRobots(theLevel, applicationRoot);
			} else {
				logger.error("No Boiler Plate Type Matched");
				// Boiler Plate Type Not Found
				result = false;
			}
		} catch (Exception e) {
			logger.error("BoilerPlate Failure: " + e.toString());
			result = false;
		}
		return result;
	}


	private static void brokenAccessControlRobots(Level theLevel, String applicationRoot) throws Exception {
		// TODO Auto-generated method stub
		String brokenAccessControl = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String param = new String();\n" + "String answerKey = new String();\n"
				+ "if(request.getParameter(\"levelInput\") != null) {param = request.getParameter(\"levelInput\");}\n"
				+ "%>\n\n");
		logger.debug("brokenAccessControl Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + brokenAccessControl + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name)
						+ "</h1>\n" + "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
						+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
						+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
						+ commonSolution + commonFooter);
		String brokenAccessControlSolution = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n" + "%>\n\n");
		String jspRobotsSolution = new String(commonHeaderRobots + brokenAccessControlSolution
				+ "<h1  class=\"title\">Jedi Console : May the Force be with you</h1>\n"
				+ "<div id=\"formResults\">\nYou are in the solution console. Please copy this key :  <h1>"
				+ Encode.forHtml(theLevel.solution) + "</h1>\n"
				+ "and paste into the solution box on the initial Level page!!\n</div>" + commonFooterRobots);

		File RoboTxt = null;
		boolean rt = false;

		try {

			// returns pathnames for files and directory
			RoboTxt = new File(applicationRoot + "/levels/Robots/");
			// create
			rt = RoboTxt.mkdir();

			// print
			System.out.print("Directory created? " + rt);

		} catch (Exception e) {

			// if any error occurs
			e.printStackTrace();
		}

		// Copy CSS stuff
		File srcFolder = new File(applicationRoot + "/levels/css/");
		File destFolder = new File(applicationRoot + "/levels/Robots/css/");

		// make sure source exists
		if (!srcFolder.exists()) {

			System.out.println("Directory does not exist.");
			// just exit

		} else {

			try {
				copyFolder(srcFolder, destFolder);
			} catch (IOException e) {
				e.printStackTrace();
				// error, just exit
				System.exit(0);
			}
		}

		System.out.println("Done");

		// End of Folder copy

		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		PrintWriter writerRobot = new PrintWriter(RoboTxt + "/Robots.txt", "UTF-8");
		PrintWriter writerSolution = new PrintWriter(RoboTxt + "/RobotSolution.jsp", "UTF-8");
		writer.println(jspPage);
		writerRobot.println("#                      .-.");
		writerRobot.println("#                     (   )");
		writerRobot.println("#                      '-'");
		writerRobot.println("#                      J L");
		writerRobot.println("#                      | |");
		writerRobot.println("#                     J   L");
		writerRobot.println("#                     |   |");
		writerRobot.println("#                    J     L");
		writerRobot.println("#                  .-'.___.'-.");
		writerRobot.println("#                 /___________\"");
		writerRobot.println("#            _.-'''           `''._");
		writerRobot.println("#          .'                       `.");
		writerRobot.println("#        J                            `.");
		writerRobot.println("#       F                               L");
		writerRobot.println("#      J                                 J");
		writerRobot.println("#     J                                  `");
		writerRobot.println("#     |                                   L");
		writerRobot.println("#     |                                   |");
		writerRobot.println("#     |                                   |");
		writerRobot.println("#     |                                   J");
		writerRobot.println("#     |                                    L");
		writerRobot.println("#     |                                    |");
		writerRobot.println("#     |             ,.___          ___....--._");
		writerRobot.println("#     |           ,'     `''''''''           `-._");
		writerRobot.println("#     |          J           ____________________`-.");
		writerRobot.println("#     |         F         .-'   `-88888-'    `8888b.`.");
		writerRobot.println("#     |         |       .'         `P'         `8888b ");
		writerRobot.println("#     |         |      J       #     L      #    q888b L");
		writerRobot.println("#     |         |      |             |           )888D )");
		writerRobot.println("#     |         J      |             J           d888P P");
		writerRobot.println("#     |          L      `.         .b.         ,8888P /");
		writerRobot.println("#     |           `.      `-.___,o88888o.___,o8888P'.'");
		writerRobot.println("#     |             `-._________________________..-'");
		writerRobot.println("#     |                                    |");
		writerRobot.println("#     |         .-----.........____________J");
		writerRobot.println("#     |       .' |       |      |       |");
		writerRobot.println("#     |      J---|-----..|...___|_______|");
		writerRobot.println("#     |      |   |       |      |       |");
		writerRobot.println("#     |      Y---|-----..|...___|_______|                 -- KILL ALL HUMANS");
		writerRobot.println("#     |       `. |       |      |       |");
		writerRobot.println("#     |         `'-------:....__|______.J");
		writerRobot.println("#     |                                  |");
		writerRobot.println("#      L___                              |");
		writerRobot.println("#          ''''----...______________....--'");
		writerRobot.println("");
		writerRobot.println("User-agent: *");
		writerRobot.println("Disallow: /Robots/RobotSolution.jsp");

		writerSolution.println(jspRobotsSolution);
		writer.close();
		writerRobot.close();
		writerSolution.close();
		logger.debug("brokenAccessControl Boiler Plate Complete");

	}


	private static void csrf1(Level theLevel, String applicationRoot) throws Exception {
		logger.debug("csrf1 Boiler Plate Initiated");
		String csrfHeader = new String(
				"<%@ page import=\"org.owasp.encoder.Encode, levelUtils.XSSChecker, java.util.Random\"%>" + "<% "
						+ "\n	String htmlOutput = new String();" + "\nRandom rand =  new Random();"
						+ "\nString setFalseId = new Integer(rand.nextInt(61)).toString();"
						+ "\nString falseId = new String(\"\");" + "\nif(ses.getAttribute(\"falseId\") != null)"
						+ "\n	falseId = (String) ses.getAttribute(\"falseId\");" + "\nelse"
						+ "\n ses.setAttribute(\"falseId\", setFalseId);" + "\n	String messageForAdmin = new String();"
						+ "\n	if(request.getParameter(\"messageForAdmin\") != null)"
						+ "\n		messageForAdmin = (String) request.getParameter(\"messageForAdmin\").toLowerCase();"
						+ "\nif(!messageForAdmin.isEmpty())" + "\n{" + "\n	"
						+ "\n	boolean validLessonAttack = XSSChecker.findCsrfAttackUrl(messageForAdmin, \"/root/grantComplete/csrflesson\", \"userId\", falseId);"
						+ "\n	" + "\n	if(validLessonAttack)"
						+ "\n		htmlOutput = \"<h2 class='title'>Well Done</h2>You Did it! <br />The Result Key to this Challenge is <span id='actualKey'>"
						+ Encode.forHtml(theLevel.solution) + "</span>\";"
						+ "\n	htmlOutput += \"<h2 class='title'>Message Sent</h2>\" + "
						+ "\n\"<p><table><tr><td>Sent to: </td><td>administrator@CAP</td></tr>\" + "
						+ "\n		\"<tr><td>Message: </td><td>\" + "
						+ "\n		\"<img src='\" + Encode.forHtml(messageForAdmin) + \"'/>\" + "
						+ "\n		\"</td></tr></table></p>\";" + "\n}" + "\nelse" + "\n{"
						+ "\n	falseId = setFalseId;" + "\n}" + " %>");
		String csrfContent = new String("<div id=\"contentDiv\">"
				+ "\n<h2 class=\"title\">SANS 5: Cross-Site Request Forgery (CSRF) [CWE-352]</h2>" + "\n<p>"
				+ "\n</p><div id=\"lessonIntro\">"
				+ "\nA Cross-Site Request Forgery or <i>CSRF</i> attack forces a user's browser to send a <i>forged HTTP request</i> with the user's session cookie to an application. The attacker tricks the user into unknowingly interacting with an application that they are currently logged into. CSRF attacks are possible when the application does not ensure that a user is in fact interacting with it. The severity of a CSRF attack varies with the functionality of the application the victim is tricked into interacting with. If the attack is aimed at an administrator, the severity will be a lot higher than those aimed at a guest user. "
				+ "\n<br>" + "\n<br>"
				+ "\nTo prevent CSRF attacks every request must contain a <i>nonce</i> token (an unpredictable number) to be included with every request. To find CSRF vulnerabilities in applications, this is the token that is tested. If a request does not contain a nonce at all, then it is likely vulnerable to CSRF attacks. If a request does contain a nonce then there are more steps to include in testing for CSRF. Even though the nonce is in the request it may not be validated or may work with a null value. It is possible that the application's nonce management will allow an attacker to use their valid nonce in other user requests!"
				+ "\n<br>" + "\n<br>"
				+ "\nHTTP requests can be sent using JavaScript. Requests that are sent this way include an \"X-Requested-With\" HTTP header. If this is checked when a request comes in the header can serve as CSRF protection without a nonce value. This header cannot be replicated from a remote domain due to the <i>Same Origin Policy</i> and prevent an attacker from delivering the attack remotely. However, it is not advised to use this as a sole CSRF protection model as browser issues are commonly found that allow attackers to send cross-domain requests from a browser."
				+ "\n<br>" + "\n<br>"
				+ "\nCSRF attacks can be performed on <i>GET</i> and <i>POST</i> HTTP requests. To force a victim to seamlessly submit a request in a GET request the request (highlighted) can be embedded into an image tag on a web page such as follows;<br> &lt;img src=\"<a>http://www.secureBank.ie/sendMoney?giveMoneyTo=hacker&amp;giveAmount=1000</a>\"/&gt;"
				+ "\n<br>" + "\n<br>"
				+ "\nTo force a victim to send a POST request requires a little more effort. The easiest way is to create a form that automatically submits using JavaScript, such as the following example;<br> &lt;form name=\"csrfForm\" action=\"<a>http://www.secureBank.ie/sendMoney</a>\" method=\"<a>POST</a>\"&gt;<br> &lt;input type=\"hidden\" name=\"<a>giveMoneyTo</a>\" value=\"hacker\" /&gt;<br> &lt;input type=\"hidden\" name=\"<a>giveAmount</a>\" value=\"1000\" /&gt;<br> &lt;input type=\"submit\"/&gt;<br> &lt;/form&gt;<br> &lt;script&gt;<br> document.csrfForm.submit();<br> &lt;/script&gt;"
				+ "\n</div>" + "\n<br>" + "\n<br>"
				+ "\nThe function used by an administrator to mark this lesson as complete for a user is initiated by the following GET request to this server, where 'exampleId' is a valid userId."
				+ "\n<br>" + "\n<br>"
				+ "\nGET <a href=\"../root/grantComplete/csrfLesson?userId=exampleId\">/root/grantComplete/csrfLesson?userId=exampleId </a>"
				+ "\n<br>"
				+ "\nTo complete this lesson send the administrator a URL in the send message field. This URL will automatically be embedded into an image URL like this<a>&lt;img&gt;</a> and will force the administrator to submit the request. You should replace the <i>exampleId</i> attribute with your temp userId: <a><%= falseId %></a>"
				+ "\n<br>" + "\n<br>" + "\n<br>" + "\n<h2 class=\"title\">Contact Admin</h2>" + "\n<form id=\"leForm\">"
				+ "\n<table>" + "\n<tbody><tr><td>"
				+ "\nPlease enter the <i>URL of the image</i> you want to send to one of CAP 24 hour administrators."
				+ "\n</td></tr>" + "\n<tr><td>"
				+ "\n<input style=\"width: 400px;\" name=\"messageForAdmin\" type=\"text\">" + "\n</td></tr>"
				+ "\n<tr><td>" + "\n<div id=\"submitButton\"><input type=\"submit\" value=\"Send Message\"></div>"
				+ "\n<p style=\"display: none;\" id=\"loadingSign\">Loading...</p>" + "\n</td></tr>"
				+ "\n</tbody></table>" + "\n</form>" + "\n" + "\n<div id=\"resultsDiv\"><%= htmlOutput %></div>"
				+ "\n<p></p>" + "\n</div>");
		String jspPage = new String(commonHeader + "\n" + csrfHeader + csrfContent + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("csrf1 Boiler Plate Complete");
	}


	private static void offline1(Level theLevel, String applicationRoot) throws Exception {
		logger.debug("offline1 Boiler Plate Initiated");
		String jspPage = new String(commonHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name)
				+ "</h1>\n" + "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<em class=\"formLabel\">" + Encode.forHtml(theLevel.downloadDescription) + "<a href=\""
				+ Encode.forHtml(Encode.forJava(theLevel.getLevel_name() + "/" + theLevel.getArtifact()))
				+ "\">Click to Download</a></em>\n" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("offline1 Boiler Plate Complete");
	}


	private static void openRedirect1(Level theLevel, String applicationRoot) throws Exception {
		logger.debug("openRedirect1 Boiler Plate Initiated");
		String openRedirectHeader = new String(
				"<%@ page import=\"org.owasp.encoder.Encode, levelUtils.XSSChecker, java.util.Random, java.net.MalformedURLException, java.net.URL\"%>\n"
						+ "<%\n" + "String htmlOutput = new String();\n" + "Random rand =  new Random();\n"
						+ "String setFalseId = new Integer(rand.nextInt(61)).toString(); \n"
						+ "String falseId = new String(\"\");\n" + "if(ses.getAttribute(\"falseId\") != null)\n"
						+ "	falseId = (String) ses.getAttribute(\"falseId\"); \n" + "else\n"
						+ "	ses.setAttribute(\"falseId\", setFalseId);\n" + "String messageForAdmin = new String();\n"
						+ "if(request.getParameter(\"theURL\") != null)\n"
						+ "	messageForAdmin = (String) request.getParameter(\"theURL\").toLowerCase();\n"
						+ "if(!messageForAdmin.isEmpty())\n" + "{\n" + "	String error = new String();\n"
						+ "	boolean validUrl = true;\n" + "	boolean validSolution = false;\n"
						+ "	boolean validAttack = false;\n" + "	try\n" + "	{\n"
						+ "		URL csrfUrl = new URL(messageForAdmin);\n"
						+ "		validSolution = csrfUrl.getPath().toLowerCase().endsWith(\"/user/redirect\");\n"
						+ "		if(!validSolution)\n" + "			error = new String(\"Invalid Solution\");\n"
						+ "		validSolution = csrfUrl.getQuery().toLowerCase().startsWith((\"to=\").toLowerCase()) && validSolution;\n"
						+ "		if(!validSolution)\n" + "			error = new String(\"Invalid Solution\");\n"
						+ "		if(validSolution)\n" + "		{\n"
						+ "			//log.debug(\"Redirect URL Correct: Now checking the Redirected URL for valid CSRF Attack\");\n"
						+ "			int csrfStart = 0;\n" + "			int csrfEnd = 0;\n"
						+ "			csrfStart = csrfUrl.getQuery().indexOf(\"to=\") + 3;\n"
						+ "			csrfEnd = csrfUrl.getQuery().indexOf(\"&\");\n" + "			if(csrfEnd == -1)\n"
						+ "			{\n" + "				csrfEnd = csrfUrl.getQuery().length();\n" + "			}\n"
						+ "			String csrfAttack = csrfUrl.getQuery().substring(csrfStart, csrfEnd);\n"
						+ "			URL embeddedAttack = new URL(csrfAttack);"
						+ "			//log.debug(\"csrfAttack Found to be: \" + csrfAttack);\n"
						+ "			validAttack = XSSChecker.findCsrfAttackUrl(csrfAttack, embeddedAttack.getPath(), \"userId\", falseId);\n"
						+ "		}\n" + "	}\n" + "	catch(MalformedURLException e)\n" + "	{\n"
						+ "		error = new String(\"Invalid URL: \" + e.toString());\n" + "		validUrl = false;\n"
						+ "		validSolution = false;\n" + "		validAttack = false;\n"
						+ "		messageForAdmin = \"\";\n" + "		htmlOutput=\"Invalid URL\";\n"
						+ "	}				\n" + "	\n" + "	if(validSolution && validAttack)\n" + "	{\n"
						+ "		htmlOutput = \"<h2 class='title'>Well Done</h2>You Did it! <br />The Result Key to this Challenge is <span id='actualKey'>"
						+ Encode.forHtml(theLevel.solution) + "</span>\";\n" + "	}\n" + "	if(validUrl)\n" + "	{\n"
						+ "		//log.debug(\"Adding message to Html: \" + messageForAdmin);\n"
						+ "		htmlOutput += \"<h2 class='title'>Message Sent</h2>\" +\n"
						+ "		\"<p><table><tr><td>Sent to: </td><td>administrator@CAP</td></tr>\" +\n"
						+ "		\"<tr><td>Message: </td><td>\" +\n"
						+ "		\"<a href='\" + Encode.forHtml(messageForAdmin) + \"'/>\" + Encode.forHtml(messageForAdmin) + \"</a>\" +\n"
						+ "		\"</td></tr></table></p>\";\n" + "	}\n" + "}\n" + "else\n" + "{\n"
						+ "	falseId = setFalseId;\n" + "}%>\n");
		String openRedirectContent = new String("<div id=\"contentDiv\">" + "<p>\n" + "</p><div id=\"lessonIntro\">\n"
				+ "An Open Redirect occurs in an application that <i>redirects</i> or <i>forwards</i> their users to a <i>target</i> that is specified by an unvalidated parameter. An unvalidated parameter that is used to redirect a user to a normally safe location can be used by an attacker to trick victims into visiting phishing pages or even have malware installed on their machines.\n"
				+ "<br>\n" + "<br>\n"
				+ "This attack takes advantage of a user's trust in an application. A victim is more likely to click on a link from a site that they trust than one they have never seen before.\n"
				+ "<br>\n" + "<br>\n"
				+ "These attacks can also be used to bypass access control schemes. This is done when a page that a user would not normally have access to such as <i>administrator</i> pages are included in a open redirect.\n"
				+ "</div>\n" + "<br>\n" + "<br>\n"
				+ "To mark this lesson complete you must exploit a <i>Cross-Site Request Forgery</i> vulnerability using an <i>Open Redirect</i>. The CSRF protection that has been implemented in this function is insufficient and can be bypassed easily with an open redirect vulnerability. To protect against CSRF attacks the application is checking that the request's <i>Referer</i> HTTP header from the same host name the application is running on. This is easily bypassed when the request originates from inside the application. When an open redirect is used the Referer header will be the URL of the redirect page.\n"
				+ "<br>\n" + "<br>\n"
				+ "The function vulnerable to open redirects is <a href=\"../user/redirect?to=exampleUrl\">/user/redirect?to=exampleUrl</a>\n"
				+ "<br>\n" + "<br>\n"
				+ "The request to mark this lesson as complete is  <a href=\"../root/grantComplete/unvalidatedredirectlesson?userid=exampleId\">/root/grantComplete/unvalidatedredirectlesson?userid=exampleId</a> where the exampleId is a users TempId.\n"
				+ "<br>\n" + "<br>\n" + "Your ID is <a><%= falseId %></a>\n" + "<br>\n" + "<br>\n"
				+ "<form id=\"leForm\">\n" + "<table>\n" + "<tbody><tr><td>\n"
				+ "The administrator promises to go to any URL you send him. So please use the following form to send him something of interest!\n"
				+ "</td></tr>\n" + "<tr><td>\n" + "<input type=\"text\" name=\"theURL\" style=\"width: 600px;\">\n"
				+ "</td></tr>\n" + "<tr><td>\n"
				+ "<div id=\"submitButton\"><input type=\"submit\" value=\"Send Message\"></div>\n"
				+ "<p style=\"display: none;\" id=\"loadingSign\">Loading...</p>\n" + "</td></tr>\n"
				+ "</tbody></table>\n" + "</form>\n" + "<div id=\"resultsDiv\"><%= htmlOutput %></div>\n" + "<p></p>\n"
				+ "</div>");
		String jspPage = new String(commonHeader + "<h1  class=\"title\">SANS 6: Open Redirect [CWE-601]</h1>\n"
				+ openRedirectHeader + openRedirectContent + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("openRedirect1 Boiler Plate Complete");
	}


	private static void sqlInjection1(Level theLevel, String applicationRoot) throws Exception {
		String sqlInjectionHeader = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String param = new String();\n"
				+ "if(request.getParameter(\"levelInput\") != null) {param = request.getParameter(\"levelInput\");}\n"
				+ "String sql = \"" + Encode.forJava(theLevel.getTableSchemas()) + "\";\n" + "imdb.CreateTable(sql);\n"
				+ "sql = \"" + Encode.forJava(theLevel.getInserts()) + "\";\n" + "imdb.InsertTableData(sql);\n"
				+ "sql = \"" + Encode.forJava(theLevel.getSelects()) + "\";\n"
				+ "String htmlTable = imdb.inMemorySelectOperation(sql, param);%>\n\n");
		logger.debug("sqlInjection1 Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + sqlInjectionHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name)
						+ "</h1>\n" + "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
						+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
						+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
						+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("sqlInjection1 Boiler Plate Complete");
	}


	private static void sqlInjection2(Level theLevel, String applicationRoot) throws Exception {
		String sqlInjectionHeader = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String param = new String();\n"
				+ "if(request.getParameter(\"levelInput\") != null) {param = request.getParameter(\"levelInput\");}\n"
				+ "String sql = \"" + Encode.forJava(theLevel.getTableSchemas()) + "\";\n" + "imdb.CreateTable(sql);\n"
				+ "sql = \"" + Encode.forJava(theLevel.getInserts()) + "\";\n" + "imdb.InsertTableData(sql);\n"
				+ theLevel.getSelects()) + "\n" + "String htmlTable = imdb.inMemorySelectOperation(sql);%>\n\n";
		logger.debug("sqlInjection2 Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + sqlInjectionHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name)
						+ "</h1>\n" + "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
						+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
						+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
						+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("sqlInjection2 Boiler Plate Complete");
	}


	private static void sqlInjection3(Level theLevel, String applicationRoot) throws Exception {
		String sqlInjectionHeader = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String param = new String();\n"
				+ "if(request.getParameter(\"levelInput\") != null) {param = request.getParameter(\"levelInput\");}\n"
				+ "String sql = \"" + Encode.forJava(theLevel.getTableSchemas()) + "\";\n"
				+ "imdb.CreateTable(sql);\n\n" + theLevel.getFilterPhrase() + "\n\n" + "sql = \""
				+ Encode.forJava(theLevel.getInserts()) + "\";\n" + "imdb.InsertTableData(sql);\n"
				+ theLevel.getSelects()) + "\n" + "String htmlTable = imdb.inMemorySelectOperation(sql);%>\n\n";
		logger.debug("sqlInjection3 Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + sqlInjectionHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name)
						+ "</h1>\n" + "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
						+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
						+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
						+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("sqlInjection3 Boiler Plate Complete");
	}


	private static void sqlInjection4(Level theLevel, String applicationRoot) throws Exception {
		String sqlInjectionHeader = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String param = new String();\n"
				+ "if(request.getParameter(\"levelInput\") != null) {param = request.getParameter(\"levelInput\");}\n"
				+ "String param2 = new String();\n"
				+ "if(request.getParameter(\"levelInput2\") != null) {param2 = request.getParameter(\"levelInput2\");}\n"
				+ "String sql = \"" + Encode.forJava(theLevel.getTableSchemas()) + "\";\n"
				+ "imdb.CreateTable(sql);\n\n" + "sql = \"" + Encode.forJava(theLevel.getInserts()) + "\";\n"
				+ "imdb.InsertTableData(sql);\n" + theLevel.getFilterPhrase() + "\n\n" + theLevel.getSelects()) + "\n"
				+ "String htmlTable = imdb.inMemorySelectOperation(sql);%>\n\n";
		logger.debug("sqlInjection4 Boiler Plate Initiated");
		String jspPage = new String(commonHeader + sqlInjectionHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n" + "<form id=\"levelForm\"><table><tr><td>\n"
				+ "<em class=\"formLabel\">User Name: </em>\n" + "</td><td>\n"
				+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\">"
				+ "</td></tr><tr><td>\n" + "<em class=\"formLabel\">User Location: </em>\n" + "</td><td>\n"
				+ "<input id=\"levelInput2\" name=\"levelInput2\" type='text' autocomplete=\"off\">\n"
				+ "</td></tr><tr><td colspan=\"2\">\n" + "<input type=\"submit\" value=\"Submit\">\n"
				+ "</td></tr></table>" + "</form>\n" + "<div id=\"formResults\">\n<%= htmlTable %>\n</div>"
				+ commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("sqlInjection4 Boiler Plate Complete");
	}


	private static void sqlInjection5(Level theLevel, String applicationRoot) throws Exception {
		String sqlInjectionHeader = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String id = new String();\n" + "String name = new String();\n" + "String age = new String();\n"
				+ "String address= new String();\n" + "String salary = new String();\n"
				+ "if(request.getParameter(\"idInput\") != null) {id = request.getParameter(\"idInput\");}\n"
				+ "if(request.getParameter(\"nameInput\") != null) {name = request.getParameter(\"nameInput\");}\n"
				+ "if(request.getParameter(\"ageInput\") != null) {age = request.getParameter(\"ageInput\");}\n"
				+ "if(request.getParameter(\"addressInput\") != null) {address = request.getParameter(\"addressInput\");}\n"
				+ "if(request.getParameter(\"salaryInput\") != null) {salary = request.getParameter(\"salaryInput\");}\n"
				+ "String htmlTable = \"\";\n" + "String htmlTable2 = \"\";\n"

				+ "if( id.length() > 0 && name.length() > 0 && age.length() > 0 && address.length() > 0 && salary.length() > 0) {\n"

				+ "	  String sql = \"" + Encode.forJava(theLevel.getTableSchemas()) + "\";\n"
				+ "	  imdb.CreateTable(sql);\n\n" + theLevel.getFilterPhrase() + "\n\n" + "   sql = \""
				+ Encode.forJava(theLevel.getInserts()) + "\";\n" + "   imdb.InsertTableData(sql);\n"
				+ theLevel.getSelects()) + "\n"
				+ "   htmlTable = imdb.inMemoryInsertOperation(id,name,age,address,salary);\n\n"
				+ "   htmlTable2 = imdb.inMemorySelectOperation(\"SELECT NAME, ADDRESS, SALARY FROM COMPANY WHERE NAME='\"+name+\"' ORDER BY NAME ASC;\");\n\n"
				+ "}\n%>";

		logger.debug("sqlInjection5 Boiler Plate Initiated");
		String jspPage = new String(commonHeader + sqlInjectionHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<form id=\"levelForm\"><em class=\"formLabel\">User Inputs: </em><br>\n"
				+ "<input id=\"idInput\" name=\"idInput\" type='text' placeholder=\"ID\">"
				+ "<input id=\"nameInput\" name=\"nameInput\" type='text' placeholder=\"name\">"
				+ "<input id=\"ageInput\" name=\"ageInput\" type='text' placeholder=\"age\">"
				+ "<input id=\"addressInput\" name=\"addressInput\" type='text' placeholder=\"address\">"
				+ "<input id=\"salaryInput\" name=\"salaryInput\" type='text' placeholder=\"salary\">"
				+ "<input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + "<br><br>"
				+ "<p class=\"levelText\">Get newly inserted record: </p>" + "<%= htmlTable2 %>"
				+ "<% if ( htmlTable2.indexOf(\"java.sql.SQLException: [SQLITE_ERROR] SQL error or missing database (no such table: COMPANY)\") > -1 ) {"
				+ "%> Solution: " + Encode.forHtml(theLevel.solution) + " <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("sqlInjection5 Boiler Plate Complete");
	}


	private static void unauthorisedAccess1(Level theLevel, String applicationRoot) throws Exception {
		logger.debug("unauthorisedAccess1 Boiler Plate Initiated");
		String unauthHeader = new String("<% " + "String userName = new String(\"guest\");\n"
				+ "if (request.getParameter(\"username\") != null){ userName = request.getParameter(\"username\").toString(); }"
				+ "String htmlOutput = new String();\n" + "if(userName.equalsIgnoreCase(\"guest\"))\n" + "{\n"
				+ "htmlOutput = \"<h2 class='title'>User: Guest</h2>\\n\"\n" + "+ \"<table>\\n\"\n"
				+ "+ \"<tbody><tr><th>Age:</th><td>22</td></tr>\\n\"\n"
				+ "+ \"<tr><th>Address:</th><td>54 Kevin Street, Dublin</td></tr>\\n\"\n"
				+ "+ \"<tr><th>Email:</th><td>guestAccount@bootcamp.com</td></tr>\\n\"\n"
				+ "+ \"<tr><th>Private Message:</th><td>No Private Message Set</td></tr>\\n\"\n"
				+ "+ \"</tbody></table>\";\n" + "}\n" + "else if(userName.equalsIgnoreCase(\"admin\"))\n" + "{\n"
				+ "// Get key and add it to the output\n" + "String userKey = new String(\"<span id='actualKey'>"
				+ Encode.forHtml(theLevel.solution) + "</span>\"); \n"
				+ "htmlOutput = \"<h2 class='title'> User: Admin</h2>\"\n" + "+ \"<table>\"\n"
				+ "+ \"<tr><th>Age:</th><td>43</td></tr>\" +\n"
				+ "\"<tr><th>Address:</th><td>12 Bolton Street, Dublin</td></tr>\" +\n"
				+ "\"<tr><th>Email:</th><td>administratorAccount@bootcamp.com</td></tr>\" +\n"
				+ "\"<tr><th>Private Message:</th>\" +\n"
				+ "\"<td>Congradulations. The Result key to the level is the following string: \" + userKey + \"<a></a></td></tr></table>\";\n"
				+ "}\n" + "else\n" + "{\n" + "htmlOutput = \"<h2 class='title'>User not found</h2>\";\n" + "}" + " %>");
		String unauthJspContent = new String("<p class=\"levelText\">"
				+ "Imagine a web page that allows you to view your personal information. This web page displays your information based on a user ID. "
				+ "If this page was vulnerable to <i>Incorrect Authoisation</i> an attacker would be able to modify the user identifier parameter "
				+ "and gain unauthorised access to other user's information in the application. Incorrect Authorisation can occur when an "
				+ "application references an object by its actual ID or name. This object that is referenced directly is used to generate a web "
				+ "page. If the application does not verify that the user is allowed to reference this object then the object is insecurely "
				+ "referenced and incorrect authorisation is in place.<br><br>One way an attacker can use incorrect authorisation to gain access "
				+ "to any information is to modify values sent to the server referenced by a parameter. In the above example, the attacker can "
				+ "access any user's personal information.<br><br>The severity of Incorrect Authorisation varies depending on the data that is "
				+ "compromised. If the compromised data is publicly available or not supposed to be restricted then this is a very low severity "
				+ "vulnerability. Consider a scenario where one company is able to retrieve their competitor's information. Suddenly the business "
				+ "impact of the vulnerability is critical. These vulnerabilities still need to be fixed and should never be found in professional "
				+ "grade applications.<br><br>" + "</p>\n"
				+ "The result key to complete this lesson is stored in the administrators profile.<br><br>\n"
				+ "<form id=\"leForm\"><table><tbody><tr><td>\n"
				+ "<div id=\"submitButton\"><input type=\"hidden\" name=\"username\" value=\"guest\"><input type=\"submit\" value=\"Refresh your Profile\"></div>\n"
				+ "</td></tr></tbody></table></form>\n" + "<div id=\"resultsDiv\">\n" + "<%= htmlOutput %>\n"
				+ "</div>\n<p></p>\n" + "</div>\n");
		String jspPage = new String(
				commonHeader + "<h1  class=\"title\">SANS 21: Incorrect Authorisation [CWE-863]</h1>\n" + unauthHeader
						+ unauthJspContent + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("unauthorisedAccess1 Boiler Plate Complete");
	}


	private static void uncontrolledFormatString(Level theLevel, String applicationRoot) throws Exception {
		String uncontrolledFormatStringHeader = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String param = new String();\n" + "String answerKey = new String();\n"
				+ "if(request.getParameter(\"levelInput\") != null) {param = request.getParameter(\"levelInput\");}\n"
				+ "if (param.equals(\"%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\")) { answerKey = \"1a61376012cfe23f199a044544b93ed2\";}\n"
				+ "String htmlTable = \"AnswerKey is: \" + answerKey;%>\n\n");
		logger.debug("uncontrolledFormatString Boiler Plate Initiated");
		String jspPage = new String(commonHeader + uncontrolledFormatStringHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
				+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("uncontrolledFormatString Boiler Plate Complete");
	}


	private static void xssBoilerPlateTypeOne(Level theLevel, String applicationRoot) throws Exception {
		String xssHeader = new String(
				"" + "<%@ page import=\"java.math.BigInteger, java.security.SecureRandom, levelUtils.XSSCheck\"%>\n"
						+ "<% \n" + "response.setHeader(\"X-XSS-Protection\", \"0\");\n"
						+ "String randomString = new String();\n" + "String csrfToken = new String();\n"
						+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
						+ "boolean showResult = false;\n" + "String result = new String();\n" + "try\n" + "{\n"
						+ "	byte byteArray[] = new byte[16];\n"
						+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
						+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
						+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n"
						+ "}\n" + "catch(Exception e)\n" + "{\n"
						+ "	System.out.println(\"Random Number Error : \" + e.toString());\n" + "}\n"
						+ "String param = new String();\n"
						+ "if(request.getParameter(\"levelInput\") != null) {param = request.getParameter(\"levelInput\");}\n"
						+ "if(ses.getAttribute(\"xssCsrfToken\") != null){\n"
						+ "if(ses.getAttribute(\"xssCsrfToken\").toString().isEmpty()){\n"
						+ "newCsrfTokenNeeded = true;\n" + "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
						+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
						+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"xssCsrfToken\").toString())) {\n"
						+ "newCsrfTokenNeeded = false;\n"
						+ "result = \"Your user input is included in this message in order to simulate a Reflected Cross Site Scripting Scenario. \" + param;\n"
						+ "if(XSSCheck.check(\"<html><head></head><body>\" + param + \"</body></html>\")){\n"
						+ "showResult = true;" + "}\n" + "}\n" + "}\n" + "}\n" + "if(newCsrfTokenNeeded){\n"
						+ "ses.setAttribute(\"xssCsrfToken\", randomString);\n" + "csrfToken = randomString;\n" + "}\n"
						+ "%>\n");
		logger.debug("Xss Type 1 Boiler Plate Initiated");
		String jspPage = new String(commonHeader + xssHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n" + "<p class=\"levelText\">" + commonXssInstructions
				+ "</p>\n" + "<form id=\"levelForm\" method=\"POST\"><em class=\"formLabel\">User Input: </em>\n"
				+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
				+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= result %>\n</div>"
				+ "<% if(showResult) { %> <p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
				+ Encode.forHtml(theLevel.solution) + "</span></p> <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("Xss Type 1 Boiler Plate Complete");
	}


	private static void xssBoilerPlateTypeTwo(Level theLevel, String applicationRoot) throws Exception {
		String xssHeader = new String(
				"" + "<%@ page import=\"java.math.BigInteger, java.security.SecureRandom, levelUtils.XSSCheck\"%>\n"
						+ "<% \n" + "response.setHeader(\"X-XSS-Protection\", \"0\");\n"
						+ "String randomString = new String();\n" + "String csrfToken = new String();\n"
						+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
						+ "boolean showResult = false;\n" + "String result = new String();\n" + "try\n" + "{\n"
						+ "	byte byteArray[] = new byte[16];\n"
						+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
						+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
						+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n"
						+ "}\n" + "catch(Exception e)\n" + "{\n"
						+ "	System.out.println(\"Random Number Error : \" + e.toString());\n" + "}\n"
						+ "String param = new String();\n" + "if(request.getParameter(\"levelInput\") != null) {\n"
						+ "param = request.getParameter(\"levelInput\");" + theLevel.filterPhrase + "\n" + "}\n"
						+ "if(ses.getAttribute(\"xssCsrfToken\") != null){\n"
						+ "if(ses.getAttribute(\"xssCsrfToken\").toString().isEmpty()){\n"
						+ "newCsrfTokenNeeded = true;\n" + "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
						+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
						+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"xssCsrfToken\").toString())) {\n"
						+ "newCsrfTokenNeeded = false;\n"
						+ "result = \"Your user input is included in this message in order to simulate a Reflected Cross Site Scripting Scenario. \" + param;\n"
						+ "if(XSSCheck.check(\"<html><head></head><body>\" + param + \"</body></html>\")){\n"
						+ "showResult = true;" + "}\n" + "}\n" + "}\n" + "}\n" + "if(newCsrfTokenNeeded){\n"
						+ "ses.setAttribute(\"xssCsrfToken\", randomString);\n" + "csrfToken = randomString;\n" + "}\n"
						+ "%>\n");
		logger.debug("Xss Type 2 Boiler Plate Initiated");
		String jspPage = new String(commonHeader + xssHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n" + "<p class=\"levelText\">" + commonXssInstructions
				+ "</p>\n" + "<form id=\"levelForm\" method=\"POST\"><em class=\"formLabel\">User Input: </em>\n"
				+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
				+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= result %>\n</div>"
				+ "<% if(showResult) { %> <p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
				+ Encode.forHtml(theLevel.solution) + "</span></p> <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("Xss Type 2 Boiler Plate Complete");
	}


	private static void xssBoilerPlateTypeThree(Level theLevel, String applicationRoot) throws Exception {
		String xssHeader = new String(
				"" + "<%@ page import=\"java.math.BigInteger, java.security.SecureRandom, levelUtils.XSSCheck\"%>\n"
						+ "<% \n" + "response.setHeader(\"X-XSS-Protection\", \"0\");\n"
						+ "String randomString = new String();\n" + "String csrfToken = new String();\n"
						+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
						+ "boolean showResult = false;\n" + "String result = new String();\n" + "try\n" + "{\n"
						+ "	byte byteArray[] = new byte[16];\n"
						+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
						+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
						+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n"
						+ "}\n" + "catch(Exception e)\n" + "{\n"
						+ "	System.out.println(\"Random Number Error : \" + e.toString());\n" + "}\n"
						+ "String param = new String();\n" + "if(request.getParameter(\"levelInput\") != null) {\n"
						+ "param = request.getParameter(\"levelInput\");\n" + theLevel.filterPhrase + "\n" + "}\n"
						+ "if(ses.getAttribute(\"xssCsrfToken\") != null){\n"
						+ "if(ses.getAttribute(\"xssCsrfToken\").toString().isEmpty()){\n"
						+ "newCsrfTokenNeeded = true;\n" + "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
						+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
						+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"xssCsrfToken\").toString())) {\n"
						+ "newCsrfTokenNeeded = false;\n"
						+ "result = \"Your user input is included in this message in order to simulate a Reflected Cross Site Scripting Scenario. <a href=\\\"\" + param + \"\\\">\" + param + \"</a>\";\n"
						+ "if(XSSCheck.check(\"<html><head></head><body><a href=\\\"\" + param + \"\\\">\" + param + \"</a></body></html>\")){\n"
						+ "showResult = true;" + "}\n" + "}\n" + "}\n" + "}\n" + "if(newCsrfTokenNeeded){\n"
						+ "ses.setAttribute(\"xssCsrfToken\", randomString);\n" + "csrfToken = randomString;\n" + "}\n"
						+ "%>\n");
		logger.debug("Xss Type 3 Boiler Plate Initiated");
		String jspPage = new String(commonHeader + xssHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n" + "<p class=\"levelText\">" + commonXssInstructions
				+ "</p>\n" + "<form id=\"levelForm\" method=\"POST\"><em class=\"formLabel\">User Input: </em>\n"
				+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
				+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= result %>\n</div>"
				+ "<% if(showResult) { %> <p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
				+ Encode.forHtml(theLevel.solution) + "</span></p> <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("Xss Type 3 Boiler Plate Complete");
	}


	private static void xssBoilerPlateTypeFour(Level theLevel, String applicationRoot) throws Exception {
		String xssHeader = new String(
				"" + "<%@ page import=\"java.math.BigInteger, java.security.SecureRandom, levelUtils.XSSCheck\"%>\n"
						+ "<% \n" + "response.setHeader(\"X-XSS-Protection\", \"0\");\n"
						+ "String randomString = new String();\n" + "String csrfToken = new String();\n"
						+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
						+ "boolean showResult = false;\n" + "String result = new String();\n" + "try\n" + "{\n"
						+ "	byte byteArray[] = new byte[16];\n"
						+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
						+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
						+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n"
						+ "}\n" + "catch(Exception e)\n" + "{\n"
						+ "	System.out.println(\"Random Number Error : \" + e.toString());\n" + "}\n"
						+ "String param = new String();\n" + "if(request.getParameter(\"levelInput\") != null) {\n"
						+ "param = request.getParameter(\"levelInput\");\n" + theLevel.filterPhrase + "\n" + "}\n"
						+ "if(ses.getAttribute(\"xssCsrfToken\") != null){\n"
						+ "if(ses.getAttribute(\"xssCsrfToken\").toString().isEmpty()){\n"
						+ "newCsrfTokenNeeded = true;\n" + "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
						+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
						+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"xssCsrfToken\").toString())) {\n"
						+ "newCsrfTokenNeeded = false;\n"
						+ "result = \"Your user input is included in this message in order to simulate a Reflected Cross Site Scripting Scenario. <img src=\\\"\" + param + \"\\\">\";\n"
						+ "if(XSSCheck.check(\"<html><head></head><body><img src=\\\"\" + param + \"\\\"></body></html>\")){\n"
						+ "showResult = true;" + "}\n" + "}\n" + "}\n" + "}\n" + "if(newCsrfTokenNeeded){\n"
						+ "ses.setAttribute(\"xssCsrfToken\", randomString);\n" + "csrfToken = randomString;\n" + "}\n"
						+ "%>\n");
		logger.debug("Xss Type 4 Boiler Plate Initiated");
		String jspPage = new String(commonHeader + xssHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n" + "<p class=\"levelText\">" + commonXssInstructions
				+ "</p>\n" + "<form id=\"levelForm\" method=\"POST\"><em class=\"formLabel\">User Input: </em>\n"
				+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
				+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= result %>\n</div>"
				+ "<% if(showResult) { %> <p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
				+ Encode.forHtml(theLevel.solution) + "</span></p> <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("Xss Type 4 Boiler Plate Complete");
	}


	private static void xssBoilerPlateTypeFive(Level theLevel, String applicationRoot) throws Exception {
		String xssHeader = new String(
				"" + "<%@ page import=\"java.math.BigInteger, java.security.SecureRandom, levelUtils.XSSCheck\"%>\n"
						+ "<% \n" + "response.setHeader(\"X-XSS-Protection\", \"0\");\n"
						+ "String randomString = new String();\n" + "String csrfToken = new String();\n"
						+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
						+ "boolean showResult = false;\n" + "String result = new String();\n" + "try\n" + "{\n"
						+ "	byte byteArray[] = new byte[16];\n"
						+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
						+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
						+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n"
						+ "}\n" + "catch(Exception e)\n" + "{\n"
						+ "	System.out.println(\"Random Number Error : \" + e.toString());\n" + "}\n"
						+ "String param = new String();\n" + "if(request.getParameter(\"levelInput\") != null) {\n"
						+ "param = request.getParameter(\"levelInput\");\n" + theLevel.filterPhrase + "\n" + "}\n"
						+ "if(ses.getAttribute(\"xssCsrfToken\") != null){\n"
						+ "if(ses.getAttribute(\"xssCsrfToken\").toString().isEmpty()){\n"
						+ "newCsrfTokenNeeded = true;\n" + "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
						+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
						+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"xssCsrfToken\").toString())) {\n"
						+ "newCsrfTokenNeeded = false;\n"
						+ "result = \"Your user input is included in this message in order to simulate a Reflected Cross Site Scripting Scenario. <iframe src=\\\"\" + param + \"\\\"></iframe>\";\n"
						+ "if(XSSCheck.check(\"<html><head></head><body><iframe src=\\\"\" + param + \"\\\"></iframe></body></html>\")){\n"
						+ "showResult = true;" + "}\n" + "}\n" + "}\n" + "}\n" + "if(newCsrfTokenNeeded){\n"
						+ "ses.setAttribute(\"xssCsrfToken\", randomString);\n" + "csrfToken = randomString;\n" + "}\n"
						+ "%>\n");
		logger.debug("Xss Type 5 Boiler Plate Initiated");
		String jspPage = new String(commonHeader + xssHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n" + "<p class=\"levelText\">" + commonXssInstructions
				+ "</p>\n" + "<form id=\"levelForm\" method=\"POST\"><em class=\"formLabel\">User Input: </em>\n"
				+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
				+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= result %>\n</div>"
				+ "<% if(showResult) { %> <p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
				+ Encode.forHtml(theLevel.solution) + "</span></p> <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("Xss Type 5 Boiler Plate Complete");
	}


	private static void hashBoilerPlateTypeOne(Level theLevel, String applicationRoot) throws Exception {
		String hashHeader = new String("" + "<%@ page import=\"java.math.BigInteger, java.security.SecureRandom\"%>\n"
				+ "<% \n" + "String randomString = new String();\n" + "String csrfToken = new String();\n"
				+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
				+ "boolean showResult = false;\n" + "String result = new String();\n" + "try\n" + "{\n"
				+ "	byte byteArray[] = new byte[16];\n"
				+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
				+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
				+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n" + "}\n"
				+ "catch(Exception e)\n" + "{\n"
				+ "	System.out.println(\"Random Number Error : \" + e.toString());\n" + "}\n"
				+ "String param = new String();\n" + "if(request.getParameter(\"levelInput\") != null) {\n"
				+ "param = request.getParameter(\"levelInput\");" + "}\n"
				+ "if(ses.getAttribute(\"hashCsrfToken\") != null){\n"
				+ "if(ses.getAttribute(\"hashCsrfToken\").toString().isEmpty()){\n" + "newCsrfTokenNeeded = true;\n"
				+ "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
				+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
				+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"hashCsrfToken\").toString())) {\n"
				+ "newCsrfTokenNeeded = false;\n"
				+ "result = \"Your attempt to reverse engineer the hash returns  \" + param;\n"
				+ "if(param.equals(\"dragonprincess123\")){\n" + "showResult = true;" + "}\n" + "}\n" + "}\n" + "}\n"
				+ "if(newCsrfTokenNeeded){\n" + "ses.setAttribute(\"hashCsrfToken\", randomString);\n"
				+ "csrfToken = randomString;\n" + "}\n" + "%>\n");
		logger.debug("Hash Type 1 Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + hashHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name) + "</h1>\n"
						+ "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
						+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
						+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
						+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
						+ "<div id=\"formResults\">\n<%= result %>\n</div>"
						+ "<% if(showResult) { %> <p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
						+ Encode.forHtml(theLevel.solution) + "</span></p> <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("Hash Type 1 Boiler Plate Complete");
	}


	private static void fileUploadTypeOne(Level theLevel, String applicationRoot) throws Exception {
		String fileUploadHeader = new String(
				"" + "<%@ page import=\"java.math.BigInteger, java.security.SecureRandom, java.util.regex.Matcher, java.util.regex.Pattern\"%>\n"
						+ "<% \n" + "String randomString = new String();\n" + "String csrfToken = new String();\n"
						+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
						+ "boolean showResult = false;\n" + "String result = new String();\n" + "try\n" + "{\n"
						+ "	byte byteArray[] = new byte[16];\n"
						+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
						+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
						+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n"
						+ "}\n" + "catch(Exception e)\n" + "{\n"
						+ "	System.out.println(\"Random Number Error : \" + e.toString());\n" + "}\n"
						+ "String param = new String();\n" + "if(request.getParameter(\"fileName\") != null) {\n"
						+ "param = request.getParameter(\"fileName\");" + "}\n"
						+ "if(ses.getAttribute(\"fileCsrfToken\") != null){\n"
						+ "if(ses.getAttribute(\"fileCsrfToken\").toString().isEmpty()){\n"
						+ "newCsrfTokenNeeded = true;\n" + "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
						+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
						+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"fileCsrfToken\").toString())) {\n"
						+ "newCsrfTokenNeeded = false;\n"
						+ "String mfileRegex = \"([^\\\\s]+(\\\\.(?i)(msi|bat|sh|run|jar))$)\";\n"
						+ "String ifileRegex = \"([^\\\\s]+(\\\\.(?i)(jpg|jpeg|png|bmp|nef|gif))$)\";\n"
						+ "Pattern maliciousFileRegex = Pattern.compile(mfileRegex);\n"
						+ "Pattern imageFileRegex = Pattern.compile(ifileRegex);\n"
						+ "Matcher maliciousMatch = maliciousFileRegex.matcher(param);\n"
						+ "Matcher imageMatch = imageFileRegex.matcher(param);\n" + "if(maliciousMatch.matches()){\n"
						+ "result = \"File <b>\" + param + \"</b> uploaded successfully. Looks like this executable file could be dangerous...\";\n"
						+ "showResult = true;\n" + "}\n" + "else if (imageMatch.matches()){\n"
						+ "result = \"File <b>\" + param + \"</b> uploaded successfully.\";\n" + "}\n" + "else {\n"
						+ "result = \"<b>\" + param + \"</b> - invalid file name or type. File not uploaded.\";\n"
						+ "}\n" + "}\n" + "}\n" + "}\n" + "if(newCsrfTokenNeeded){\n"
						+ "ses.setAttribute(\"fileCsrfToken\", randomString);\n" + "csrfToken = randomString;\n" + "}\n"
						+ "%>\n");
		logger.debug("File Upload Type 1 Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + fileUploadHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name)
						+ "</h1>\n" + "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
						+ "<form id=\"levelForm\"><em class=\"formLabel\">File Name: </em>\n"
						+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
						+ "<input id=\"fileName\" name=\"fileName\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Upload File\"></form>\n"
						+ "<div id=\"formResults\">\n<%= result %>\n</div>"
						+ "<% if(showResult) { %> <p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
						+ Encode.forHtml(theLevel.solution) + "</span></p> <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("File Upload Type 1 Boiler Plate Complete");
	}


	private static void fileUploadTypeTwo(Level theLevel, String applicationRoot) throws Exception {
		String fileUploadHeader = new String(
				"" + "<%@ page import=\"java.math.BigInteger, java.security.SecureRandom, java.util.regex.Matcher, java.util.regex.Pattern\"%>\n"
						+ "<% \n" + "String randomString = new String();\n" + "String csrfToken = new String();\n"
						+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
						+ "boolean showResult = false;\n" + "String result = new String();\n" + "try\n" + "{\n"
						+ "	byte byteArray[] = new byte[16];\n"
						+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
						+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
						+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n"
						+ "}\n" + "catch(Exception e)\n" + "{\n"
						+ "	System.out.println(\"Random Number Error : \" + e.toString());\n" + "}\n"
						+ "String param = new String();\n" + "if(request.getParameter(\"fileName\") != null) {\n"
						+ "param = request.getParameter(\"fileName\");" + "}\n"
						+ "if(ses.getAttribute(\"fileCsrfToken\") != null){\n"
						+ "if(ses.getAttribute(\"fileCsrfToken\").toString().isEmpty()){\n"
						+ "newCsrfTokenNeeded = true;\n" + "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
						+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
						+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"fileCsrfToken\").toString())) {\n"
						+ "newCsrfTokenNeeded = false;\n"
						+ "String mfileRegex = \"([^\\\\s]+(\\\\.(?i)(reg|cmd|dmg|iso|hta))$)\";\n"
						+ "String ifileRegex = \"([^\\\\s]+(\\\\.(?i)(jpg|jpeg|gif))$)\";\n"
						+ "Pattern maliciousFileRegex = Pattern.compile(mfileRegex);\n"
						+ "Pattern imageFileRegex = Pattern.compile(ifileRegex);\n"
						+ "Matcher maliciousMatch = maliciousFileRegex.matcher(param);\n"
						+ "Matcher imageMatch = imageFileRegex.matcher(param);\n" + "if(maliciousMatch.matches()){\n"
						+ "result = \"File <b>\" + param + \"</b> uploaded successfully. Looks like this executable file could be dangerous...\";\n"
						+ "showResult = true;\n" + "}\n" + "else if (imageMatch.matches()){\n"
						+ "result = \"File <b>\" + param + \"</b> uploaded successfully.\";\n" + "}\n" + "else {\n"
						+ "result = \"<b>\" + param + \"</b> - invalid file name or type. File not uploaded.\";\n"
						+ "}\n" + "}\n" + "}\n" + "}\n" + "if(newCsrfTokenNeeded){\n"
						+ "ses.setAttribute(\"fileCsrfToken\", randomString);\n" + "csrfToken = randomString;\n" + "}\n"
						+ "%>\n");
		logger.debug("File Upload Type 2 Boiler Plate Initiated");
		String jspPage = new String(commonHeader + fileUploadHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n" + "<script>" + "function validateFileName() {"
				+ "    var f = document.forms[\"levelForm\"][\"fileName\"].value;"
				+ "    var ext = f.substring(f.lastIndexOf('.') + 1);"
				+ "    if(ext == \"gif\" || ext == \"GIF\" || ext == \"JPEG\" || ext == \"jpeg\" || ext == \"jpg\" || ext == \"JPG\") {"
				+ "        return true;" + "    } else {"
				+ "        document.getElementById('jsresult').innerHTML = '<h4 style=\"color:red;\">Error: ' + f + ' is not a valid image file. Please try again</h4>';"
				+ "        return false;" + "    }" + "}" + "</script>"
				+ "<form onsubmit=\"return validateFileName()\" id=\"levelForm\"><em class=\"formLabel\">File Name: </em>\n"
				+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
				+ "<input id=\"fileName\" name=\"fileName\" type='text' autocomplete=\"off\" required><input type=\"submit\" value=\"Upload File\"></form>\n"
				+ "<div id=\"jsresult\"></div>\n" + "<div id=\"formResults\">\n<%= result %>\n</div>"
				+ "<% if(showResult) { %> <p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
				+ Encode.forHtml(theLevel.solution) + "</span></p> <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("File Upload Type 2 Boiler Plate Complete");
	}


	private static void osCommandInjectionOne(Level theLevel, String applicationRoot) throws Exception {
		String osCommandInjectionOneHeader = new String(
				"<%@ page import=\"java.util.regex.Matcher, java.util.regex.Pattern\"%>\n" + "<% \n"
						+ "String param = new String();\n" + "String levelSolution = new String();\n"
						+ "String htmlinitTable = new String();\n"
						+ "if(request.getParameter(\"levelInput\") != null) {param = request.getParameter(\"levelInput\");}\n"
						+ "String paraminitRegex = \"[a-zA-Z0-9 ]+\";\n"
						+ "String paramRegex = \"[a-zA-Z0-9 ]+\\\" *; *(ls|cd|touch|finger|sudo).*\";\n"
						+ "Pattern inputinitRegex = Pattern.compile(paraminitRegex);\n"
						+ "Pattern inputRegex = Pattern.compile(paramRegex);\n"
						+ "Matcher checkinitMatch = inputinitRegex.matcher(param);\n"
						+ "Matcher checkMatch = inputRegex.matcher(param);\n" + "if(checkinitMatch.matches())"
						+ "{htmlinitTable = \"Hall of Fame: \" + param;}\n" + "if(checkMatch.matches())"
						+ "{ levelSolution = \"fdglkflri395ydkvjbj59fgij45y09jbfdkj5iufgbplk2sdgflk65dgeprj\";}\n"
						+ "String htmlTable = \"The level solution is: \" + levelSolution;%>\n\n");
		logger.debug("osCommandInjection1 Boiler Plate Initiated");
		String jspPage = new String(commonHeader + osCommandInjectionOneHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
				+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"hallofFame\">\n<%= htmlinitTable %>\n</div>"
				+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("osCommandInjection1 Boiler Plate Complete");
	}


	private static void csrfBoilerPlateTypeTwo(Level theLevel, String applicationRoot) throws Exception {
		String csrfHeader = new String(""
				+ "<%@ page import=\"java.math.BigInteger, java.security.SecureRandom, java.util.Random\"%>\n"
				+ "<%! long randomID = (long) Math.floor(Math.random() * 9000000000L) + 1000000000L;%>\n"// accountID
																											// 10
																											// digit
																											// number
				+ "<%! String reqURL = null; %>\n"
				+ "<% reqURL = request.getScheme()+ \"://\" + request.getServerName()+\":\"+ request.getServerPort() + request.getRequestURI(); %>\n"
				+ "<% \n" + "String randomString = new String();\n" + "String csrfToken = new String();\n"
				+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
				+ "boolean showResult = false;\n" + "String result = new String();\n" + "try\n" + "{\n"
				+ "	byte byteArray[] = new byte[16];\n"
				+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
				+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
				+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n" + "}\n"
				+ "catch(Exception e)\n" + "{\n"
				+ "	System.out.println(\"Random Number Error : \" + e.toString());\n" + "}\n"
				+ "String param = new String();\n" + "if(request.getParameter(\"levelInput\") != null) {\n"
				+ "param = request.getParameter(\"levelInput\");" + "}\n"
				+ "if(ses.getAttribute(\"hashCsrfToken\") != null){\n"
				+ "if(ses.getAttribute(\"hashCsrfToken\").toString().isEmpty()){\n" + "newCsrfTokenNeeded = true;\n"
				+ "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
				+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
				+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"hashCsrfToken\").toString())) {\n"
				+ "newCsrfTokenNeeded = false;\n" + "result = \"Your have entered  \" + param;\n"
				+ "if(param.equals(reqURL.substring(0, reqURL.length()-4)+\"/bankTransferFunds?amount=4000&accountID=\"+randomID)){\n"
				+ "showResult = true;" + "}\n" + "else{result += \" .... <b>TRY  AGAIN!!</b>\";}\n" + "}\n" + "}\n"
				+ "}\n" + "if(newCsrfTokenNeeded){\n" + "ses.setAttribute(\"hashCsrfToken\", randomString);\n"
				+ "csrfToken = randomString;\n" + "}\n" + "%>\n");
		logger.debug("CSRF Type 2 Boiler Plate Initiated");
		String jspPage = new String(commonHeader + csrfHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n" + "<em><%= randomID  %></em>\n"
				+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
				+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
				+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= result %>\n</div>"
				+ "<% if(showResult) { %> <p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
				+ Encode.forHtml(theLevel.solution) + "</span></p> <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("CSRF Type 2 Boiler Plate Complete");
	}


	private static void missingAuthorization(Level theLevel, String applicationRoot) throws Exception {
		String missingAuthorizationStringHeader = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String param = new String();\n" + "String answerKey = new String();\n"
				+ "if(request.getParameter(\"levelInput\") != null) {param = request.getParameter(\"levelInput\");}\n"
				+ "%>\n\n");
		logger.debug("untrustedUserInputs Boiler Plate Initiated");
		String jspPage = new String(commonHeader + missingAuthorizationStringHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
				+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
				+ commonSolution + commonFooter);
		String missingAuthorizationAdminStringHeader = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String param = new String();\n" + "String answerKey = new String();\n" + "%>\n\n");
		String jspAdmin = new String(commonHeader + missingAuthorizationAdminStringHeader
				+ "<h1  class=\"title\">AdminConsole : " + Encode.forHtml(theLevel.level_name) + "</h1>\n"
				+ "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<div id=\"formResults\">\nYou are in the admin console. Please copy this key : bWlzc2luZ19hdXRob3JpemF0aW9u and paste into the solution box on the previous page!!\n</div>"
				+ commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		PrintWriter writerAdmin = new PrintWriter(applicationRoot + "/levels/AdminConsole.jsp", "UTF-8");
		writer.println(jspPage);
		writerAdmin.println(jspAdmin);
		writer.close();
		writerAdmin.close();
		logger.debug("missingAuthorization Boiler Plate Complete");
	}



	private static void brokenCryptography(Level theLevel, String applicationRoot) throws Exception {
		String brokenCryptographyHeader = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String param = new String();\n" + "String answerKey = new String();\n"
				+ "if(request.getParameter(\"levelInput\") != null) {param = request.getParameter(\"levelInput\");}\n"
				+ "if (param.equalsIgnoreCase(\"the woods are lovely, dark and deep\")) { answerKey = \"2b72487123dff34e200b155655c04fe3\";}\n"
				+ "String htmlTable = \"AnswerKey is: \" + answerKey;%>\n\n");
		logger.debug("uncontrolledFormatString Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + brokenCryptographyHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name)
						+ "</h1>\n" + "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
						+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
						+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
						+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("brokenCryptography Boiler Plate Complete");
	}


	private static void relianceOnUntrustedInputs(Level theLevel, String applicationRoot) throws Exception {
		String relianceOnUntrustedInputsHeader = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String param = new String();\n" + "String answerKey = new String();\n"
				+ "if(request.getParameter(\"accessValue\") != null) {param = request.getParameter(\"accessValue\");}\n"
				+ "if (param.equals(\"SuperUser\")) { answerKey = \"d9ab4782321ccb984679e470cd8fa685\";}\n"
				+ "else { answerKey = \"OK Clark, Lois really needs you\";}\n"
				+ "String htmlTable = \"AnswerKey is: \" + answerKey;%>\n\n");
		logger.debug("relianceOnUntrusted Boiler Plate Initiated");
		String jspPage = new String(commonHeader + relianceOnUntrustedInputsHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
				+ "<input id=\"accessValue\" name=\"accessValue\" value=\"normalUser\" type='hidden'>\n"
				+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("relianceOnUntrusted Boiler Plate Complete");
	}


	private static void useOfHardCodedCreds(Level theLevel, String applicationRoot) throws Exception {
		String useOfHardCodedCredsHeader = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String param1 = new String();\n" + "String param2 = new String();\n"
				+ "String answerKey = new String();\n"
				+ "if(request.getParameter(\"username\") != null && request.getParameter(\"password\") != null){\n"
				+ "\t param1 = request.getParameter(\"username\");\n"
				+ "\t param2 = request.getParameter(\"password\");\n"
				+ "if (param1.equals(\"admin0\") && param2.equals(\"d41d8cd98f00b204e9800998ecf8427e\")) {\n "
				+ "\t answerKey = \" " + Encode.forHtml(theLevel.solution) + " \";} \n"
				+ "else answerKey = \"<p style='color:red'>Wrong Username or Password!</p>\"; \n" + "}\n"
				+ "String htmlTable = \"AnswerKey is: \" + answerKey;%>\n\n");
		logger.debug("useOfHardCodedCreds Boiler Plate Initiated");
		String jspPage = new String(commonHeader + useOfHardCodedCredsHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n" + "<form id=\"levelForm\">"
				+ "<em class=\"username\">username: </em>\n"
				+ "<input id=\"levelInput\" name=\"username\" type='text' autocomplete=\"off\">"
				+ "<em class=\"password\">password: </em>\n"
				+ "<input id=\"levelInput\" name=\"password\" type='text' autocomplete=\"off\">"
				+ "<input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + "<!-- Link to our webapp props <a href=\""
				+ Encode.forHtml(Encode.forJava(theLevel.getLevel_name() + "/" + theLevel.getArtifact())) + "\">-->"
				+ commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("useOfHardCodedCreds Boiler Plate Complete");
	}



	private static void missingAuthForFunctBoilerPlateTypeOne(Level theLevel, String applicationRoot) throws Exception {

		logger.debug("Missing Auth For Critical function Type one Boiler Plate Initiated");
		String jspPage = new String(commonHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name)
				+ "</h1>\n" + "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n" + "<%"
				+ "org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(this.getClass());   "
				+ "String levelKey = \"" + Encode.forHtml(theLevel.solution) + "\";  "
				+ "String loggedIn = request.getParameter(\"loggedin\");   "
				+ "if (request.getMethod().equals(\"POST\"))   { "
				+ "String username = request.getParameter(\"username\");  	"
				+ "String password = request.getParameter(\"password\");   	"
				+ "logger.debug(\"Received username/password: \" + username + \" / \" + password);"
				+ "if (username == null) { username = new String(); }"
				+ "if (password == null) { password = new String(); }"
				+ "if (username.equals(\"admin\") && password.equals(\"jf8390djhgdkd7ghasl\")) "
				+ "{ response.setStatus(HttpServletResponse.SC_OK); response.setContentType(\"text/plain\");  java.io.PrintWriter printWriter = response.getWriter();   printWriter.print(\"Login credentials verified;  proceed\");  printWriter.close(); }"
				+ " else "
				+ "{ response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); response.setContentType(\"text/plain\"); java.io.PrintWriter printWriter = response.getWriter(); printWriter.print(\"Wrong username / password\"); printWriter.close(); }"
				+ "} else if (request.getMethod().equals(\"GET\") && loggedIn != null) "
				+ "{logger.debug(\"Received LoggedIn Verification: \" + loggedIn); "
				+ "    if (loggedIn.equals(\"verification1477492929282\")) "
				+ "       { response.setStatus(HttpServletResponse.SC_OK);  response.setContentType(\"text/plain\"); java.io.PrintWriter printWriter = response.getWriter(); printWriter.print(\"Login Verfification Succeeded: you have logged in successfully! The key is: \" + levelKey);  		printWriter.close();  	}"
				+ "   else "
				+ "       { response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); response.setContentType(\"text/plain\");  java.io.PrintWriter printWriter = response.getWriter();  		printWriter.print(\"Login Verification Failed\");  		printWriter.close();"
				+ "	}"
				+ "}else { out.println(\"<form id=\\\"loginform\\\" method=\\\"POST\\\">\");  	out.println(\"<fieldset>\");  	out.println(\"<legend>Enter your login credentials</legend>\");  	out.println(\"<dl>\");  	out.println(\"<dt><label for=\\\"username\\\">Username:</label></dt>\");  	out.println(\"<dd><input type=\\\"text\\\" name=\\\"username\\\" id=\\\"username\\\" autofocus /></dd>\");  	out.println(\"<dt><label for=\\\"password\\\">Password:</label>\");  	out.println(\"<dd><input type=\\\"password\\\" name=\\\"password\\\" id=\\\"password\\\" /></dd>\");  	out.println(\"</dl>\");  	out.println(\"<input id=\\\"loginsubmit\\\" type=\\\"submit\\\" value=\\\"Login\\\">\");  	out.println(\"</fieldset>\");  	out.println(\"</form>\");  }"
				+ "%>" + "<p id=\"output-text\"></p> "
				+ "<script type=\"text/javascript\">  var loginForm = document.getElementById('loginform');   function displayMessage(text) { 	document.getElementById('output-text').textContent = text;  }   function displayError(text) { 	document.getElementById('output-text').textContent = 'Error: ' + text;  }   loginForm.addEventListener('submit', function (event) { 	event.preventDefault();  	 	var ajax = new XMLHttpRequest();  	 	ajax.onload = function () { 		switch (ajax.status) { 		case 200: 			displayMessage(ajax.responseText);  			 			var xhr = new XMLHttpRequest();  			 			xhr.onload = function () { 				switch (xhr.status) { 				case 200: 					displayMessage(xhr.responseText);  					break;  				default: 					displayError(xhr.responseText);  					break;  				}  			} ;  			 			xhr.open('GET', '\\u003F\\u006C\\u006F\\u0067\\u0067\\u0065\\u0064\\u0069\\u006E\\u003D\\u0076\\u0065\\u0072\\u0069\\u0066\\u0069\\u0063\\u0061\\u0074\\u0069\\u006F\\u006E\\u0031\\u0034\\u0037\\u0037\\u0034\\u0039\\u0032\\u0039\\u0032\\u0039\\u0032\\u0038\\u0032');  			xhr.send();  			break;  		case 401: 			displayError(ajax.responseText);  			break;  		default: 			displayError('Login error (', ajax.status, '): ', ajax.responseText);  			break;  		}  	} ;  	 	ajax.open('POST', '');  	ajax.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');  	var data = 'username=' + 		encodeURIComponent(document.getElementById('username').value) + 		'&password=' + 		encodeURIComponent(document.getElementById('password').value);  	ajax.send(data);  } );  </script>"
				+ commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("Missing Auth for Critical Function Boiler Plate Complete");
	}


	private static void dataValidationOne(Level theLevel, String applicationRoot) throws Exception {
		String dvHeader = new String("<%@ page import=\"levelUtils.XSSCheck\"%>\n" + "<% \n"
				+ "response.setHeader(\"X-XSS-Protection\", \"0\");\n" + "String randomString = new String();\n"
				+ "String csrfToken = new String();\n" + "boolean showResult = false;\n"
				+ "boolean basicValid = false;\n" + "String result = new String();\n"
				+ "String param1 = new String();\n" + "String param2 = new String();\n"
				+ "String param3 = new String();\n" + "String param4 = new String();\n" + "int param1Int = 0;\n"
				+ "int param2Int = 0;\n" + "int param3Int = 0;\n" + "int param4Int = 0;\n" + "int param1Cost = 15;\n"
				+ "int param2Cost = 30;\n" + "int param3Cost = 3000;\n" + "int param4Cost = 45;\n"
				+ "if(request.getParameter(\"item1\") != null) {\n" + "param1 = request.getParameter(\"item1\");"
				+ "}\n" + "if(request.getParameter(\"item2\") != null) {\n"
				+ "param2 = request.getParameter(\"item2\");" + "}\n"
				+ "if(request.getParameter(\"item3\") != null) {\n" + "param3 = request.getParameter(\"item3\");"
				+ "}\n" + "if(request.getParameter(\"item4\") != null) {\n"
				+ "param4 = request.getParameter(\"item4\");" + "}\n" + "try { \n"
				+ "	if(!(param1.isEmpty() || param2.isEmpty() || param3.isEmpty() || param4.isEmpty())) {\n"
				+ "		param1Int = Integer.parseInt(param1);\n"
				+ "System.out.println(\"Param1 \" + param1Int);\n" 
				+ "		param2Int = Integer.parseInt(param2);\n"
				+ "		param3Int = Integer.parseInt(param3);\n" 
				+ "		param4Int = Integer.parseInt(param4);\n"
				+ "		basicValid = true;\n" + "	}\n" + "} catch (Exception e) { \n" + "//TODO - handle Exception\n"
				+ "}\n" + "if(basicValid) { \n"
						+ "System.out.println(\"basicValue\");\n" + "boolean validData = false;\n" + theLevel.getFilterPhrase() + "\n"// Validates
																													// paramNInt
																													// 1-4
				+ "if(!param1.isEmpty() && !param2.isEmpty() && !param3.isEmpty() && !param4.isEmpty()){\n"
				+ "int cost = (param1Int*param1Cost) + (param2Int*param2Cost) + (param3Int*param3Cost) + (param4Int*param4Cost);\n" // Calculate
																																	// Order
																																	// Cost
																																	// here
				+ "result = \"<table border=\\\"1\\\"><tr><th>Item1</th><td>\"+(param1Int*param1Cost)+\"</td></tr><tr><th>Item2</th><td>\"+(param2Int*param2Cost)+\"</td></tr><tr><th>Item3</th><td>\"+(param3Int*param3Cost)+\"</td></tr><tr><th>Item4</th><td>\"+(param4Int*param4Cost)+\"</td></tr><tr><th>Total Cost</th><td>\"+cost+\"</td></tr></table>\";\n"
				+ "if(cost <= 0 && param3Int > 0) { \n"
				+ "result += \"Congradulations, you have ordered item three and got the order for free! The key for this challenge is "
				+ theLevel.getSolution() + "\";\n" + "}\n" + "}\n" + "}\n" + "%>\n");
		logger.debug("Data Validation One Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + dvHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name) + "</h1>\n"
						+ "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
						+ "<form id=\"levelForm\" method=\"POST\"><em class=\"formLabel\">User Input: </em>\n"
						+ "<table><tr><th>Item Name</th><th>Cost</th><th>Quantity</th></tr>"
						+ "<tr><td>item1</td><td>15</td><td><input id=\"item1\" name=\"item1\" type='text' value='0' autocomplete=\"off\"></td></tr>"
						+ "<tr><td>item2</td><td>30</td><td><input id=\"item2\" name=\"item2\" type='text' value='0' autocomplete=\"off\"></td></tr>"
						+ "<tr><td>item3</td><td>3000</td><td><input id=\"item3\" name=\"item3\" type='text' value='0' autocomplete=\"off\"></td></tr>"
						+ "<tr><td>item4</td><td>45</td><td><input id=\"item4\" name=\"item4\" type='text' value='0' autocomplete=\"off\"></td></tr>"
						+ "<tr><td colspan=\"3\"><input type=\"submit\" value=\"Submit\"></td></tr></table></form>\n"
						+ "<div id=\"formResults\">\n<%= result %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("Data Validation 1 Boiler Plate Complete");
	}


	private static void offlineQuestionsAndAnswers(Level theLevel, String applicationRoot) throws Exception {
		logger.debug("questionsAndAnswers Boiler Plate Initiated");
		String jspPage = new String(commonHeader + "<%@ page import=\"java.math.BigInteger\"%>\n"
				+ "<%@ page import=\"org.json.simple.*\"%>\n" + "<%@ page import=\"org.json.simple.parser.*\"%>\n"
				+ "<%@ page import=\"utils.JSONUtil\"%>\n"
				+ "<%@ page import=\"org.owasp.encoder.Encode\"%>\n" + "<%@ page import=\"java.util.ArrayList\"%>\n"
				+ "<%@ page import=\"java.net.URLDecoder\"%>\n" + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<form id=\"levelForm\" method=\"POST\"><div style=\"text-align: left\">" + "<em class=\"formLabel\">"
				+ Encode.forHtml(theLevel.downloadDescription) + "<a href=\""
				+ Encode.forHtml(Encode.forJava(theLevel.getLevel_name() + "/" + theLevel.getArtifact()))
				+ "\">Click to Download</a></em><br>\n" + questionAndAnswerForm(theLevel) + commonSolution
				+ commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("questionsAndAnswers Boiler Plate Complete");
	}


	private static void brokenCrypto2(Level theLevel, String applicationRoot) throws Exception {
		String xssHeader = new String(
				"<%@ page import=\"java.math.BigInteger, java.security.SecureRandom, levelUtils.XSSCheck\"%>\n"
						+ "<% \n" + "response.setHeader(\"X-XSS-Protection\", \"0\");\n"
						+ "String randomString = new String();\n" + "String csrfToken = new String();\n"
						+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
						+ "boolean showResult = false;\n" + "String result = new String();\n"
						+ "String htmlOutput = new String();\n" + "String decryptionKey = new String(\""
						+ theLevel.getSolution() + "\");\n" + "try\n" + "{\n" + "	byte byteArray[] = new byte[16];\n"
						+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
						+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
						+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n"
						+ "}\n" + "catch(Exception e)\n" + "{\n"
						+ "	System.out.println(\"Random Number Error : \"+ e.toString());\n" + "}\n"
						+ "String param = new String();\n" + "if(request.getParameter(\"levelInput\") != null) {\n"
						+ "param = request.getParameter(\"levelInput\");\n" + "try{\n" + "//Decryption Block Starts\n"
						+ theLevel.filterPhrase // Decryption Happens Here
						+ "\n//Decryption Block Starts\n" + "} catch (Exception e) {\n"
						+ "result = \"Could not Complete Decryption: \" + e.toString();\n" + "}\n" + "}\n"
						+ "if(ses.getAttribute(\"xssCsrfToken\") != null){\n"
						+ "if(ses.getAttribute(\"xssCsrfToken\").toString().isEmpty()){\n"
						+ "newCsrfTokenNeeded = true;\n" + "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
						+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
						+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"xssCsrfToken\").toString())) {\n"
						+ "newCsrfTokenNeeded = false;\n" + "htmlOutput = \"Decrypted Content: \" + result;\n" + "}\n"
						+ "}\n" + "}\n" + "if(newCsrfTokenNeeded){\n"
						+ "ses.setAttribute(\"xssCsrfToken\", randomString);\n" + "csrfToken = randomString;\n" + "}\n"
						+ "%>\n");
		logger.debug("Bad Crypto 2 Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + xssHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name) + "</h1>\n"
						+ "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
						+ "<form id=\"levelForm\" method=\"POST\"><em class=\"formLabel\">User Input: </em>\n"
						+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
						+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
						+ "<div id=\"formResults\">\n<%= result %>\n</div>" + "</p>\n" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("Bad Crypto 2 Boiler Plate Complete");
	}



	private static void brokenCrypto3(Level theLevel, String applicationRoot) throws Exception {
		String brokenCrypto3Header = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String param = new String();\n" + "String answerKey = new String();\n"
				+ "if(request.getParameter(\"levelInput\") != null) {param = request.getParameter(\"levelInput\");}\n"
				+ "if (param.equals(\"TheanswerforthislevelisBrokenCrypto\")) { answerKey = \"<h2 class='title'>Well Done</h2>You Did it! <br />The Result Key to this Challenge is <span id='actualKey'>"
				+ Encode.forHtml(theLevel.solution) + "</span>\";} \n"
				+ "String htmlTable = \"AnswerKey is: \" + answerKey;%>\n\n");
		logger.debug("brokenCrypto3Header Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + brokenCrypto3Header + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name)
						+ "</h1>\n" + "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
						+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
						+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\"><input type=\"submit\" value=\"Submit\"></form>\n"
						+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("brokenCrypto3 Boiler Plate Complete");
	}




	private static void integerOverflowOne(Level theLevel, String applicationRoot) throws Exception {
		String dvHeader = new String(
				"<%@ page import=\"java.math.BigInteger, java.security.SecureRandom, levelUtils.XSSCheck\"%>\n"
						+ "<% \n" + "response.setHeader(\"X-XSS-Protection\", \"0\");\n"
						+ "boolean showResult = false;\n" + "boolean basicValid = false;\n"
						+ "String result = new String();\n" + "String order = new String();\n"
						+ "String param1 = new String();\n" + "String param2 = new String();\n"
						+ "String param3 = new String();\n" + "String param4 = new String();\n"
						+ "short param1Int = 0;\n" + "short param2Int = 0;\n" + "byte param2aInt = 0;\n"
						+ "short param3Int = 0;\n" + "short param4Int = 0;\n" + "short param1Cost = 115;\n"
						+ "short param2Cost = 126;\n" + "short param3Cost = 190;\n" + "short param4Cost = 245;\n"
						+ "if(request.getParameter(\"item1\") != null) {\n"
						+ "param1 = request.getParameter(\"item1\");" + "}\n"
						+ "if(request.getParameter(\"item2\") != null) {\n"
						+ "param2 = request.getParameter(\"item2\");" + "}\n"
						+ "if(request.getParameter(\"item3\") != null) {\n"
						+ "param3 = request.getParameter(\"item3\");" + "}\n"
						+ "if(request.getParameter(\"item4\") != null) {\n"
						+ "param4 = request.getParameter(\"item4\");" + "}\n" + "try { \n"
						+ "param1Int = Short.parseShort(param1);\n" + "param2Int = Short.parseShort(param2);\n"
						+ "param3Int = Short.parseShort(param3);\n" + "param4Int = Short.parseShort(param4);\n"
						+ "basicValid = true;\n" + "} catch (Exception e) { \n"
						// enable for debugging
						// + "result = \"Number parsing exception : \"+
						// e.toString();\n"
						+ "result = \"Your order is incorrect! Try again...\";" + "}\n" + "if(basicValid) { \n"
						+ "boolean validData = false;\n" + theLevel.getFilterPhrase() + "\n"// Validates
																							// paramNInt
																							// 1-4
						+ "param2aInt = (byte) param2Int;\n"
						+ "if(!param1.isEmpty() && !param2.isEmpty() && !param3.isEmpty() && !param4.isEmpty()){\n"
						+ "int cost = (param1Int*param1Cost) + (param2aInt*param2Cost) + (param3Int*param3Cost) + (param4Int*param4Cost);\n" // Calculate
																																				// Order
																																				// Cost
																																				// here
						+ "if(cost > 100000) { \n" + "order = \"Your order is incorrect! Try again...\";\n" + "}\n"
						+ "else {\n"
						+ "order = \"<table><tr><th width=\\\"200\\\">Your order summary:</th><th></th></tr><tr><td align=\\\"center\\\" width=\\\"120\\\">item1</td><td align=\\\"center\\\" width=\\\"60\\\">\"+(param1Int*param1Cost)+\"</td></tr><tr><td align=\\\"center\\\" width=\\\"120\\\">item2</td><td align=\\\"center\\\" width=\\\"60\\\">\"+(param2aInt*param2Cost)+\"</td></tr><tr><td align=\\\"center\\\" width=\\\"70\\\">item3</td><td align=\\\"center\\\" width=\\\"60\\\">\"+(param3Int*param3Cost)+\"</td></tr><tr><td align=\\\"center\\\" width=\\\"120\\\">item4</td><td align=\\\"center\\\" width=\\\"60\\\">\"+(param4Int*param4Cost)+\"</td></tr><tr><th align=\\\"center\\\" width=\\\"120\\\">Total Cost</th><td align=\\\"center\\\" width=\\\"60\\\">\"+cost+\"</td></tr></table></br>\";\n"
						+ "}\n" + "if(cost < 0) { \n"
						+ "result = \"Congratulations, you have made your purchase for free!</br>The key for this challenge is "
						+ theLevel.getSolution() + "\";\n" + "}\n" + "}\n" + "}\n" + "%>\n");
		logger.debug("Integer Overflow One Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + dvHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name) + "</h1>\n"
						+ "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
						+ "<form id=\"levelForm\" method=\"POST\"><em class=\"formLabel\">Can you make an order that will cost you less than 0?</em></br>"
						+ "<table><tr><th width=\"100\">Item Name</th><th width=\"70\">Cost</th><th width=\"70\">Quantity</th></tr>"
						+ "<tr><td align=\"center\">item1</td><td align=\"center\">115</td><td><input id=\"item1\" name=\"item1\" type='text' autocomplete=\"off\"></td></tr>"
						+ "<tr><td align=\"center\">item2</td><td align=\"center\">126</td><td><input id=\"item2\" name=\"item2\" type='text' autocomplete=\"off\"></td></tr>"
						+ "<tr><td align=\"center\">item3</td><td align=\"center\">190</td><td><input id=\"item3\" name=\"item3\" type='text' autocomplete=\"off\"></td></tr>"
						+ "<tr><td align=\"center\">item4</td><td align=\"center\">245</td><td><input id=\"item4\" name=\"item4\" type='text' autocomplete=\"off\"></td></tr>"
						+ "<tr><td colspan=\"3\"><input type=\"submit\" value=\"Submit\"></td></tr></table></form>\n"
						+ "<div id=\"formResults\">\n<%= order %>\n</div>"
						+ "<div id=\"formResults\">\n<%= result %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("Integer Overflow 1 Boiler Plate Complete");
	}



	private static void improperRestrictionOfLoginAttempts(Level theLevel, String applicationRoot) throws Exception {
		String improperRestrictionOfLoginAttemptsHeader = new String(
				"<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
						+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
						+ "String paramName = new String();\n" + "String paramPass = new String();\n"
						+ "String answerKey = new String();\n"
						+ "if(request.getParameter(\"UserName\") != null && request.getParameter(\"password\") != null){\n"
						+ "\t paramName = request.getParameter(\"UserName\");\n"
						+ "\t paramPass = request.getParameter(\"password\");\n"
						+ "if (paramPass.equals(\"Pa55wurD\")) {\n "
						+ "\t answerKey = \"<h2 class='title'>Well Done</h2>You Did it! <br />The Result Key to this Challenge is <span id='actualKey'>"
						+ Encode.forHtml(theLevel.solution) + "</span>\";} \n"
						+ "else answerKey = \"<p style='color:red'>Wrong Username or Password!</p>\"; \n" + "}\n"
						+ "String htmlTable = \"AnswerKey is: \" + answerKey;%>\n\n");
		logger.debug("uncontrolledFormatString Boiler Plate Initiated");
		String jspPage = new String(commonHeader + improperRestrictionOfLoginAttemptsHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<form id=\"levelForm\"><em class=\"formLabel\">User Login</em><br>\n"
				+ "<label><b>Username: </b></label><input id=\"UserName\" name=\"UserName\" type='text' autocomplete=\"off\" placeholder=\"Enter Username\" required><br>"
				+ "<label><b>Password: </b></label><input id=\"password\" name=\"password\" type='text' autocomplete=\"off\" placeholder=\"Enter Password\" required><br>"
				+ "<input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("improperRestrictionOfLoginAttempts Boiler Plate Complete");
	}



	private static void missingEncryptionOfSensitiveData(Level theLevel, String applicationRoot) throws Exception {
		String missingEncryptionOfSensitiveDataHeader = new String("<%@ page import=\"levelUtils.InMemoryDatabase\"%>\n"
				+ "<% InMemoryDatabase imdb = new InMemoryDatabase();\n" + "imdb.Create();\n"
				+ "String paramName = new String();\n" + "String answerKey = new String();\n"
				+ "if(request.getParameter(\"Enckey\") != null) {paramName = request.getParameter(\"Enckey\");\n"
				+ "if (paramName.equals(\"" + theLevel.solution
				+ "\")) { answerKey = \"<h2 class='title'>Well Done</h2>You Did it! <br />The Result Key to this Challenge is <span id='actualKey'>"
				+ Encode.forHtml(theLevel.solution) + "</span>\";} \n"
				+ "else answerKey = \"<p style='color:red'>Wrong Username or Password!</p>\"; \n" + "}\n"
				+ "String htmlTable = \"AnswerKey is: \" + answerKey;%>\n\n");
		logger.debug("uncontrolledFormatString Boiler Plate Initiated");
		String jspPage = new String(commonHeader + missingEncryptionOfSensitiveDataHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">" + theLevel.description
				+ "</p>\n" + "<form id=\"levelForm\"><em class=\"formLabel\">Secret</em><br>\n"
				+ "<input id=\"Enckey\" name=\"Enckey\" type='text' autocomplete=\"off\" placeholder=\"Please enter the secret here\" required><br>"
				+ "<input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("missingEncryptionOfSensitiveData Boiler Plate Complete");
	}

	private static void unauthorisedAccess2(Level theLevel, String applicationRoot) throws Exception {
		logger.debug("unauthorisedAccess1 Boiler Plate Initiated");
		String unauthHeader = new String("<% " + "String userName = new String();\n"
				+ "if (request.getParameter(\"username\") != null){ userName = request.getParameter(\"username\").toString();}"
				+ "String htmlOutput = new String();\n" + "if(userName.equals(\"NXxop-DXRNV-i8Y6H-r2nK4-sA3Z1\"))\n"
				+ "{\n htmlOutput = \"<table><tr><th><b>Username: </b></th><td>Administrator</td><tr><th><b>Dept: </b></th><td>IT Head</td><tr><th><b>Notes: </b></th><td>Likes being secure with a long key like "
				+ Encode.forHtml(theLevel.solution) + "</td></table>\";" + "}\n" // "+Encode.forHtml(theLevel.solution)+"
				+ "else if(userName.equals(\"NXxop-DXRNV-i8Y6H-r2nK4-sA3Z3\"))\n"
				+ "{\n htmlOutput = \"<table><tr><th><b>Username: </b></th><td>Adam</td><tr><th><b>Dept: </b></th><td>IT</td><tr><th><b>Notes: </b></th><td>Likes toast</td></table>\";"
				+ "}\n" + "else if(userName.equals(\"NXxop-DXRNV-i8Y6H-r2nK4-sA3Z5\"))\n"
				+ "{\n htmlOutput = \"<table><tr><th><b>Username: </b></th><td>Bob</td><tr><th><b>Dept: </b></th><td>IT</td><tr><th><b>Notes: </b></th><td>Likes football</td></table>\";"
				+ "}\n" + "else if(userName.equals(\"NXxop-DXRNV-i8Y6H-r2nK4-sA3Z7\"))\n"
				+ "{\n htmlOutput = \"<table><tr><th><b>Username: </b></th><td>Carl</td><tr><th><b>Dept: </b></th><td>IT</td><tr><th><b>Notes: </b></th><td>Likes video</td></table>\";"
				+ "}\n" + "else if(userName.equals(\"NXxop-DXRNV-i8Y6H-r2nK4-sA3Z9\"))\n"
				+ "{\n htmlOutput = \"<table><tr><th><b>Username: </b></th><td>Dan</td><tr><th><b>Dept: </b></th><td>IT</td><tr><th><b>Notes: </b></th><td>Likes radio</td></table>\";"
				+ "}\n" + "else\n" + "{\n" + "htmlOutput = \"<h2 class='title'>User not found</h2>\";\n" + "}" + " %>");
		String unauthJspContent = new String("<p class=\"levelText\">"
				+ "Imagine a web page that allows you to view your personal information. This web page displays your information based on a user ID. "
				+ "If this page was vulnerable to <i>Incorrect Authoisation</i> an attacker would be able to modify the user identifier parameter "
				+ "and gain unauthorised access to other user's information in the application. Incorrect Authorisation can occur when an "
				+ "application references an object by its actual ID or name. This object that is referenced directly is used to generate a web "
				+ "page. If the application does not verify that the user is allowed to reference this object then the object is insecurely "
				+ "referenced and incorrect authorisation is in place.<br><br>One way an attacker can use incorrect authorisation to gain access "
				+ "to any information is to modify values sent to the server referenced by a parameter. In the above example, the attacker can "
				+ "access any user's personal information.<br><br>The severity of Incorrect Authorisation varies depending on the data that is "
				+ "compromised. If the compromised data is publicly available or not supposed to be restricted then this is a very low severity "
				+ "vulnerability. Consider a scenario where one company is able to retrieve their competitor's information. Suddenly the business "
				+ "impact of the vulnerability is critical. These vulnerabilities still need to be fixed and should never be found in professional "
				+ "grade applications.<br><br>" + "</p>\n"
				+ "The result key to complete this lesson is stored in the administrators profile.<br><br>\n"
				+ "<form id=\"leForm\"><table><tbody><tr><td>\n"
				// + "<div id=\"submitButton\"><input type=\"hidden\"
				// name=\"username\" value=\"guest\"><input type=\"submit\"
				// value=\"Refresh your Profile\"></div>\n"
				+ "<div id=\"submitButton\"><select name=\"username\"><option value=\"NXxop-DXRNV-i8Y6H-r2nK4-sA3Z3\">Adam</option><option value=\"NXxop-DXRNV-i8Y6H-r2nK4-sA3Z5\">Bob</option><option value=\"NXxop-DXRNV-i8Y6H-r2nK4-sA3Z7\">Carol</option><option value=\"NXxop-DXRNV-i8Y6H-r2nK4-sA3Z9\">Dan</option><input type=\"submit\" value=\"Recall user details\"></select</div>\n"
				+ "</td></tr></tbody></table></form>\n" + "<div id=\"resultsDiv\">\n" + "<%= htmlOutput %>\n"
				+ "</div>\n<p></p>\n" + "</div>\n");
		String jspPage = new String(
				commonHeader + "<h1  class=\"title\">SANS 21: Incorrect Authorisation [CWE-863]</h1>\n" + unauthHeader
						+ unauthJspContent + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("unauthorisedAccess1 Boiler Plate Complete");
	}


	private static void brokenSessionManagementOne(Level theLevel, String applicationRoot) throws Exception {
		String brokenSessionManagementOneHeader = new String("<%@ page import=\"java.util.Random\"%>\n" + "<% \n"
				+ "response.setHeader(\"X-XSS-Protection\", \"0\");\n" + "String randomString = new String();\n"
				+ "String csrfToken = new String();\n" + "boolean csrfCheck = false;\n"
				+ "boolean newCsrfTokenNeeded = true;\n" + "boolean showResult = false;\n"
				+ "String result = new String();\n" + "String htmlOutput = new String();\n"
				+ "Cookie[] cookies = request.getCookies();\n" + theLevel.filterPhrase + "\n"
				+ "boolean cookieFound = false;\n" + "boolean adminSesh = false;\n" + "boolean validSesh = false;\n"
				+ "for (int i = 0; i < cookies.length; i++)\n" + "{\n"
				+ "if(cookies[i].getName().equalsIgnoreCase(\"sessionCookie\"))\n" + "	{\n"
				+ "		cookieFound = true;\n" + "		if(cookies[i].getValue().equalsIgnoreCase(sessionArray[9]))\n"
				+ "		{\n" + "			adminSesh = true;\n" + "		} else {\n"
				+ "			for(int j = 0; j < sessionArray.length; j++) {\n"
				+ "				if(cookies[i].getValue().equalsIgnoreCase(sessionArray[j]))\n"
				+ "					validSesh = true;\n" // Check if any valid
															// value was
															// submitted
				+ "			}\n" + "		}\n" + "		break;\n" + "	}\n" + "}\n" + "if(!cookieFound)\n" + "{\n"
				+ "Random r = new Random();\n" + "int random = r.nextInt(9);\n"
				+ "Cookie cookie = new Cookie(\"sessionCookie\", sessionArray[random]);\n"
				+ "response.addCookie(cookie);" + "}\n" + "if(adminSesh)\n" + "{\n"
				+ "	result = \"<h2>Welcome Administrator</h2><p>The key for this challenge is: <b>"
				+ theLevel.getSolution() + "</b></p>\";\n" + "} else if (validSesh){\n"
				+ " result = \"<h2>Welcome User</h2>You are authenciated as a user, and currently have an active session.\";\n"
				+ "} else {\n" + " result = \"<h2>Invalid Session Detected</h2>\";\n" + "}\n" + "%>\n");
		logger.debug("brokenSessionManagementOne Boiler Plate Initiated");
		String jspPage = new String(commonHeader + brokenSessionManagementOneHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n" + "<div id=\"formResults\">\n<%= result %>\n</div>"
				+ "</p>\n" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("brokenSessionManagementOneHeader Complete");
	}


	private static void brokenSessionManagementTwo(Level theLevel, String applicationRoot) throws Exception { // TODO
																												// -
																												// Test
																												// This
		String brokenSessionManagementOneHeader = new String(
				"<%@ page import=\"levelUtils.InMemoryDatabase, java.sql.Connection, java.sql.ResultSet, java.sql.Statement\"%>\n"
						+ "<% \n" + "response.setHeader(\"X-XSS-Protection\", \"0\");\n"
						+ "String randomString = new String();\n" + "String csrfToken = new String();\n"
						+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
						+ "boolean showResult = false;\n" + "boolean userFound = false;\n"
						+ "boolean userAuthenticated = false;" + "String result = new String();\n"
						+ "String htmlOutput = new String();\n" + "String retrievedUsername = new String();\n"
						+ "String errorString = new String();" + "InMemoryDatabase imdb = new InMemoryDatabase();\n"
						+ "imdb.Create();\n" + "String sql = \"" + Encode.forJava(theLevel.getTableSchemas()) + "\";\n"
						+ "imdb.CreateTable(sql);\n\n" + "sql = \"" + Encode.forJava(theLevel.getInserts()) + "\";\n"
						+ "imdb.InsertTableData(sql);\n" + "String param = new String();\n"
						+ "if(request.getParameter(\"levelInput\") != null) {param = request.getParameter(\"levelInput\");}\n"
						+ "String param2 = new String();\n"
						+ "if(request.getParameter(\"levelInput2\") != null) {param2 = request.getParameter(\"levelInput2\");}\n"
						+ "String answerString = new String();\n"
						+ "if(request.getParameter(\"answer\") != null) {answerString = request.getParameter(\"answer\");}\n"
						+ "Connection myInMemoryConnection = imdb.Create();\n" + "Statement stmt = null;\n"
						+ "ResultSet rs = null;\n" + "try{\n" + "stmt = myInMemoryConnection.createStatement();\n"
						+ "if(!answerString.isEmpty() && !param.isEmpty()) {\n" // Check
																				// if
																				// the
																				// Answer
																				// matches
																				// the
																				// user
						+ "	sql = \"SELECT answer, passw FROM users WHERE username = '\" + param.replaceAll(\"'\", \"''\") + \"';\";\n"
						+ "	rs = stmt.executeQuery(sql);\n" + " if(rs.next()) {\n"
						+ "		if(rs.getString(1).equalsIgnoreCase(answerString)) { \n"
						+ "			result = \"<h2>Correct Answer</h2><p>Your password is: <b>\" + rs.getString(2) + \"</b></p>\";"
						+ "		} else { \n"
						+ "			result = \"<h2>Incorrect Answer</h2><p>That is not the correct answer. We have something Different in our storage</p>\";"
						+ "		}\n" + "	} else {\n" + "		result = \"Answer Look up Error\";\n" + "	}\n"
						+ "} else if (!param.isEmpty() && !param2.isEmpty()) {\n" // Then
																					// continue
																					// with
																					// Auth
																					// Attempt
						+ "sql = \"SELECT username FROM users WHERE username = '\" + param + \"';\";\n" + "try\n"
						+ "{\n" + " myInMemoryConnection.setAutoCommit(false);\n" + " rs = stmt.executeQuery(sql);\n"
						+ "	if(rs.next()) {\n" + "		retrievedUsername = rs.getString(1);\n" // IF
																								// User
																								// was
																								// Retrieved,
																								// Continue
																								// to
																								// Auth
						+ "		userFound = true;\n"
						+ "		sql = \"SELECT username FROM users WHERE username = '\" + param.replaceAll(\"'\", \"''\") + \"' AND passw = '\" + param2.replaceAll(\"'\", \"''\") + \"'\";\n"
						+ "		rs = stmt.executeQuery(sql);\n" + "		if(rs.next()) {\n"
						+ "			userAuthenticated = true;" + "		}\n" + "		if(userAuthenticated) {\n" // Return
																													// Result
						+ "			result = \"<h2>Authenticated</h2><p>Congratulations, you have successfully authenticated. "
						+ "			The solution key to this challenge is " + theLevel.solution + "</p>\";\n"
						+ "		} else if (userFound) {\n" // Return Forgot
															// password Form
						+ "			String question = new String();\n"
						+ "			sql = \"SELECT question FROM users WHERE username = '\" + param.replaceAll(\"'\", \"''\") + \"';\";\n"
						+ "			rs = stmt.executeQuery(sql);\n" + "			if(rs.next()) {\n"
						+ "				question = rs.getString(1);\n"
						+ "			} else if (retrievedUsername.isEmpty()){ \n"
						+ "				question = \"Could not find question for user name submitted.\";\n"
						+ "			} else {\n"
						+ "				question = \"Could not find question for user name submitted.<!-- \" + retrievedUsername + \" -->\";"
						+ "			}\n"
						+ "			result = \"<h2>Incorrect Password</h2><p>Have you forgotten your password?</p><form id=\\\"questionForm\\\">\"\n"
						+ "				+ \"<div id=\\\"forgotPassDiv\\\" ><table><tr><td>\"\n"
						+ "				+ \"<em class=\\\"formLabel\\\">Question: </em>\"\n"
						+ "				+ \"</td><td>\"\n" + "				+ question\n" // The
																							// Question
																							// From
																							// the
																							// DB
																							// or
																							// QUestion
																							// Error
						+ "				+ \"</td></tr><tr><td><em class=\\\"formLabel\\\">Answer: </em>\"\n"
						+ "				+ \"</td><td>\"\n"
						+ "				+ \"<input id=\\\"answer\\\" name=\\\"answer\\\" type=\\\"text\\\">\"\n"
						+ "				+ \"<input id=\\\"levelInput\\\" name=\\\"levelInput\\\" type=\\\"hidden\\\" value=\\\"\" + retrievedUsername + \"\\\">\"\n"
						+ "				+ \"</td></tr><tr><td colspan=\\\"2\\\">\"\n"
						+ "				+ \"<input type=\\\"submit\\\" value=\\\"Retrieve Password\\\">\"\n"
						+ "				+ \"</td></tr></table></div>\"\n" + "			+ \"</form>\";\n" + "		}\n"
						+ "	} else {\n" // Return Auth Failed error
						+ "		result = \"<h2>Authentication Failure</h2><p>The System was unable to Authenticate you with those credentials</p>\";\n"
						+ "	}\n" + " rs.close();\n" + " stmt.close();\n" + "}\n" + "catch ( Exception e )\n" + "{\n"
						+ "	if(!userFound) {\n" + "		errorString = \"User Look Up Failed: \" + e.toString();\n"
						+ "	} else { \n" + "		errorString = \"Auth Failed: \" + e.toString();\n" + "	}\n"
						+ "	result = \"<h2>Authentication Failure</h2><p>The System was unable to Authenticate you with those credentials</p><!-- \" + errorString + \" -->\";\n"
						+ "}\n" + "} else {\n" + "	result = new String();\n" + "}" + "}\n" + "catch ( Exception e )\n"
						+ "{\n" + "		result = \"Answer Look Up Fail\";\n" + "}\n" + "%>\n");
		logger.debug("brokenSessionManagementTwo Boiler Plate Initiated");
		String jspPage = new String(commonHeader + brokenSessionManagementOneHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n" + "<form id=\"levelForm\">" + "<table><tr><td>\n"
				+ "<em class=\"formLabel\">User Name: </em>\n" + "</td><td>\n"
				+ "<input id=\"levelInput\" name=\"levelInput\" type='text' autocomplete=\"off\">"
				+ "</td></tr><tr><td>\n" + "<em class=\"formLabel\">Password : </em>\n" + "</td><td>\n"
				+ "<input id=\"levelInput2\" name=\"levelInput2\" type='password'>\n"
				+ "</td></tr><tr><td colspan=\"2\">\n" + "<input type=\"submit\" value=\"Submit\">\n"
				+ "</td></tr><tr><td colspan=\"2\" style=\"display: none;\">\n"
				+ "<a id=\"forgotPass\" href=\"javascript;\">Forgot Your Password?</a>\n" + "</td></tr></table>"
				+ "</form>\n" + "<div id=\"formResults\">\n<%= result %>\n</div>" + "</p>\n" + commonSolution
				+ commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("brokenSessionManagementTwo Complete");
	}



	private static void classicBufferOverflow(Level theLevel, String applicationRoot) throws Exception {
		String classicBufferOverflowHeader = new String(
				"<% String paramName = new String();\n" + "String answerKey = new String();\n"
						+ "if(request.getParameter(\"Lastname\") != null) {paramName = request.getParameter(\"Lastname\");\n"
						+ "if (paramName.length() > 20) { answerKey = \"<h2 class='title'>Buffer Overflow exploited, well done</h2>You Did it! <br />The Result Key to this Challenge is <span id='actualKey'>"
						+ Encode.forHtml(theLevel.solution) + "</span>\";} \n"
						+ "else answerKey = \"<p style='color:red'>Welcome \" + paramName + \"!</p>\"; \n" + "}\n"
						+ "String htmlTable = answerKey;%>\n\n");
		if (theLevel.clientScript != null) {
			classicBufferOverflowHeader = classicBufferOverflowHeader.concat(
					"<script type=\"text/javascript\">$(function () {" + theLevel.clientScript + "});</script>");
		}
		logger.debug("classicBufferOverflow Boiler Plate Initiated");
		String jspPage = new String(commonHeader + classicBufferOverflowHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<form id=\"levelForm\"><em class=\"formLabel\">Please enter your Last Name:</em><br>\n"
				+ "<input id=\"Lastname\" name=\"Lastname\" type='text' autocomplete=\"off\" placeholder=\"Smith\" required><br>"
				+ "<input type=\"submit\" value=\"Submit\"></form>\n"
				+ "<div id=\"formResults\">\n<%= htmlTable %>\n</div>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("classicBufferOverflow Boiler Plate Complete");
	}


	private static void csrfBoilerPlateTypeThree(Level theLevel, String applicationRoot) throws Exception {
		String csrfHeader = new String(
				"" + "<%@ page import=\"java.math.BigInteger, java.util.regex.*, java.security.SecureRandom\"%>\n"
						+ "<% \n" + "String randomString = new String();\n" + "String csrfToken = new String();\n"
						+ "String regex =\"<body\\\\s+onload\\\\s*=\\\\s*\\\"((document.)|(window.document.))((form1.)|(forms\\\\[1\\\\].)|(getElementById\\\\(\\\'csrf_form\\\'\\\\).))submit\\\\(\\\\s*\\\\)\\\\s*;\\\\s*\\\"\\\\s*>\";\n"
						+ "Pattern pRegex = Pattern.compile(regex);\n" + "boolean csrfCheck = false;\n"
						+ "boolean newCsrfTokenNeeded = true;\n" + "boolean showResult = false;\n"
						+ "String result = new String();\n" + "try\n" + "{\n" + "	byte byteArray[] = new byte[16];\n"
						+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
						+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
						+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n"
						+ "}\n" + "catch(Exception e)\n" + "{\n"
						+ "	System.out.println(\"Random Number Error : \" + e.toString());\n" + "}\n"
						+ "String param = new String();\n" + "if(request.getParameter(\"levelInput\") != null) {\n"
						+ "param = request.getParameter(\"levelInput\");" + "}\n"
						+ "if(ses.getAttribute(\"hashCsrfToken\") != null){\n"
						+ "if(ses.getAttribute(\"hashCsrfToken\").toString().isEmpty()){\n"
						+ "newCsrfTokenNeeded = true;\n" + "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
						+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
						+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"hashCsrfToken\").toString())) {\n"
						+ "newCsrfTokenNeeded = false;\n" + "Matcher matchRegex = pRegex.matcher(param);\n"
						+ "if(matchRegex.matches()){\n" + "showResult = true;" + "}\n"
						+ "else{result += \" .... <b>TRY  AGAIN!!</b>\";}\n" + "}\n" + "}\n" + "}\n"
						+ "if(newCsrfTokenNeeded){\n" + "ses.setAttribute(\"hashCsrfToken\", randomString);\n"
						+ "csrfToken = randomString;\n" + "}\n" + "%>\n");
		logger.debug("CSRF Type 3 Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + csrfHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name) + "</h1>\n"
						+ "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "\n"
						+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
						+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
						+ "<input id=\"levelInput\" name=\"levelInput\" type='text'><input type=\"submit\" value=\"Submit\"></form>\n"
						+ "<form id=\"csrf_form \" name=\"form1\" action=\"https://banksite/transferfunds?amout=1000&custId=1010101010\">\n"
						+ "<input  name=\"token\" type=\"hidden\" value=\"1010101010\">" + "</form>\n"
						+ "<div id=\"formResults\">\n<%= result %>\n</div>"
						+ "<% if(showResult) { %> <p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
						+ Encode.forHtml(theLevel.solution) + "</span></p> <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("CSRF Type 3 Boiler Plate Complete");
	}

	private static void hashBoilerPlateTypeTwo(Level theLevel, String applicationRoot) throws Exception {
		String hashHeader = new String("" + "<%@ page import=\"java.math.BigInteger, java.security.SecureRandom\"%>\n"
				+ "<% \n" + "String randomString = new String();\n" + "String csrfToken = new String();\n"
				+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
				+ "boolean showResult = false;\n" + "String result = new String();\n" + "try\n" + "{\n"
				+ "	byte byteArray[] = new byte[16];\n"
				+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
				+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
				+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n" + "}\n"
				+ "catch(Exception e)\n" + "{\n"
				+ "	System.out.println(\"Random Number Error : \" + e.toString());\n" + "}\n"
				+ "String param = new String();\n" + "if(request.getParameter(\"levelInput\") != null) {\n"
				+ "param = request.getParameter(\"levelInput\");" + "}\n"
				+ "if(ses.getAttribute(\"hashCsrfToken\") != null){\n"
				+ "if(ses.getAttribute(\"hashCsrfToken\").toString().isEmpty()){\n" + "newCsrfTokenNeeded = true;\n"
				+ "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
				+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
				+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"hashCsrfToken\").toString())) {\n"
				+ "newCsrfTokenNeeded = false;\n"
				+ "result = \"Your attempt to reverse engineer the hash returns  \" + param;\n" + "if(param.equals(\""
				+ Encode.forJava(theLevel.filterPhrase) + "\")){\n" + "showResult = true;" + "}\n" + "}\n" + "}\n"
				+ "}\n" + "if(newCsrfTokenNeeded){\n" + "ses.setAttribute(\"hashCsrfToken\", randomString);\n"
				+ "csrfToken = randomString;\n" + "}\n" + "%>\n");
		logger.debug("Hash Type 2 Boiler Plate Initiated");
		String jspPage = new String(
				commonHeader + hashHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name) + "</h1>\n"
						+ "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
						+ "<form id=\"levelForm\"><em class=\"formLabel\">User Input: </em>\n"
						+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
						+ "<input id=\"levelInput\" name=\"levelInput\" type='text'><input type=\"submit\" value=\"Submit\"></form>\n"
						+ "<% if(showResult) { %> <p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
						+ Encode.forHtml(theLevel.solution) + "</span></p> <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("Hash Type 2 Boiler Plate Complete");
	}


	private static String questionAndAnswerForm(Level theLevel) {
		return "\n" + "<% JSONArray containsArray = null;\n" 
				+ "JSONObject resultData = new JSONObject();\n"
				+ "String result = \"\";\n"
				+ "JSONUtil jUtil = new JSONUtil(\""+ Encode.forJava(theLevel.solution)+ "\",\""+ Encode.forJava(theLevel.questions) +"\", containsArray, resultData, result);\n"
				+ "jUtil.questionType(request);\n"
				+ "String output = jUtil.processResult(request);\n %>"
				+ "<%= output %>";
	}


	private static void sourceCode(Level theLevel, String applicationRoot) throws Exception {
		logger.debug("sourceCode Boiler Plate Initiated");
		String sourceType = Encode.forHtml(theLevel.sourceType);
		String brushJS = "";
		if (sourceType.equalsIgnoreCase("as3")) {
			brushJS = "shBrushAS3.js";
		} else if (sourceType.equalsIgnoreCase("applescript")) {
			brushJS = "shBrushAppleScript.js";
		} else if (sourceType.equalsIgnoreCase("bash")) {
			brushJS = "shBrushBash.js";
		} else if (sourceType.equalsIgnoreCase("csharp")) {
			brushJS = "shBrushCSharp.js";
		} else if (sourceType.equalsIgnoreCase("coldfusion")) {
			brushJS = "shBrushColdFusion.js";
		} else if (sourceType.equalsIgnoreCase("cpp")) {
			brushJS = "shBrushCpp.js";
		} else if (sourceType.equalsIgnoreCase("css")) {
			brushJS = "shBrushCss.js";
		} else if (sourceType.equalsIgnoreCase("delphi")) {
			brushJS = "shBrushDelphi.js";
		} else if (sourceType.equalsIgnoreCase("diff")) {
			brushJS = "shBrushDiff.js";
		} else if (sourceType.equalsIgnoreCase("erlang")) {
			brushJS = "shBrushErlang.js";
		} else if (sourceType.equalsIgnoreCase("groovy")) {
			brushJS = "shBrushGroovy.js";
		} else if (sourceType.equalsIgnoreCase("jscript")) {
			brushJS = "shBrushJScript.js";
		} else if (sourceType.equalsIgnoreCase("java")) {
			brushJS = "shBrushJava.js";
		} else if (sourceType.equalsIgnoreCase("javafx")) {
			brushJS = "shBrushJavaFX.js";
		} else if (sourceType.equalsIgnoreCase("perl")) {
			brushJS = "shBrushPerl.js";
		} else if (sourceType.equalsIgnoreCase("php")) {
			brushJS = "shBrushPhp.js";
		} else if (sourceType.equalsIgnoreCase("plain")) {
			brushJS = "shBrushPlain.js";
		} else if (sourceType.equalsIgnoreCase("powershell")) {
			brushJS = "shBrushPowerShell.js";
		} else if (sourceType.equalsIgnoreCase("python")) {
			brushJS = "shBrushPython.js";
		} else if (sourceType.equalsIgnoreCase("ruby")) {
			brushJS = "shBrushRuby.js";
		} else if (sourceType.equalsIgnoreCase("sass")) {
			brushJS = "shBrushSass.js";
		} else if (sourceType.equalsIgnoreCase("scala")) {
			brushJS = "shBrushScala.js";
		} else if (sourceType.equalsIgnoreCase("sql")) {
			brushJS = "shBrushSql.js";
		} else if (sourceType.equalsIgnoreCase("vb")) {
			brushJS = "shBrushVb.js";
		} else if (sourceType.equalsIgnoreCase("xml")) {
			brushJS = "shBrushXml.js";
		}
		System.out.println(theLevel.questions.replace("\"", "\\\"").replaceAll("\n", "").replaceAll("\r", ""));

		String jspPage = new String(commonHeader
				+ "<link href=\"../styles/shCoreDefault.css\" rel=\"stylesheet\" type=\"text/css\" media=\"screen\" />\n"
				+ "<script type=\"text/javascript\" src=\"../scripts/shCore.js\"></script>\n" + "<style>.AnswerError{\n"
				+ "	color: red;\n" + "}\n" + ".AnswerError:checked + label{\n" + "	color: red;\n" + "}\n"
				+ "</style>\n"

				+ "<script type=\"text/javascript\" src=\"../scripts/" + brushJS + "\"></script>\n"

				+ "	<script type=\"text/javascript\">SyntaxHighlighter.all();</script>"
				+ "<%@ page import=\"java.math.BigInteger\"%>\n" + "<%@ page import=\"org.json.simple.*\"%>\n"
				+ "<%@ page import=\"org.json.simple.parser.*\"%>\n"
				+ "<%@ page import=\"org.owasp.encoder.Encode\"%>\n" + "<%@ page import=\"java.util.ArrayList\"%>\n"
				+ "<%@ page import=\"java.net.URLDecoder\"%>\n" + "<%@ page import=\"utils.JSONUtil\"%>\n"
				+ "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<form id=\"levelForm\" method=\"POST\"><div style=\"text-align: left\">"

				+ "<pre class=\"brush: " + Encode.forHtml(theLevel.sourceType) + ";\">"
				+ Encode.forHtml(theLevel.sourceCode) + "</pre><br>\n"

				+ questionAndAnswerForm(theLevel) + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("sourceCode Boiler Plate Complete");
	}


	private static void externallyHostedContent(Level theLevel, String applicationRoot) throws Exception {
		logger.debug("externallyHosterContent Boiler Plate Initiated");
		String jspPage = new String(commonHeader + "<%@ page import=\"java.math.BigInteger\"%>\n"
				+ "<%@ page import=\"org.json.simple.*\"%>\n" + "<%@ page import=\"org.json.simple.parser.*\"%>\n"
				+ "<%@ page import=\"org.owasp.encoder.Encode\"%>\n" + "<%@ page import=\"java.util.ArrayList\"%>\n"
				+ "<%@ page import=\"java.net.URLDecoder\"%>\n" + "<%@ page import=\"utils.JSONUtil\"%>\n"
				+ "<style>.AnswerError{\n" + "	color: red;\n" + "}\n" + ".AnswerError:checked + label{\n"
				+ "	color: red;\n" + "}\n" + "</style>\n" + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<form id=\"levelForm\" method=\"POST\"><div style=\"text-align: left\">" + "<em class=\"formLabel\">"
				+ Encode.forHtml(theLevel.downloadDescription) + "<a href=\""
				+ Encode.forHtml(Encode.forJava(theLevel.downloadURL)) + "\">Click to Download</a></em><br>\n"
				+ questionAndAnswerForm(theLevel) + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("externallyHosterContent Boiler Plate Complete");
	}


	private static void offlineImageEmbed(Level theLevel, String applicationRoot) throws Exception {
		logger.debug("offlineImageEmbed Boiler Plate Initiated");
		String jspPage = new String(commonHeader + "<h1  class=\"title\">" + Encode.forHtml(theLevel.level_name)
				+ "</h1>\n" + "<p class=\"levelText\">" + Encode.forHtml(theLevel.description) + "</p>\n"
				+ "<img height=\"280px\" src=\""
				+ Encode.forHtml(Encode.forJava(theLevel.getLevel_name() + "/" + theLevel.getArtifact())) + "\" />\n"
				+ commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("offlineImageEmbed Boilter Plate Complete");
	}

	private static void verboseErrorMessageOne(Level theLevel, String applicationRoot) throws Exception {
		String fileUploadHeader = new String(
				"" + "<%@ page import=\"java.math.BigInteger, java.security.SecureRandom, java.util.regex.Matcher, java.util.regex.Pattern\"%>\n"
						+ "<% \n" + "String randomString = new String();\n" + "String csrfToken = new String();\n"
						+ "boolean csrfCheck = false;\n" + "boolean newCsrfTokenNeeded = true;\n"
						+ "boolean showResult = false;\n" + "String result = new String();\n" + "try\n" + "{\n"
						+ "	byte byteArray[] = new byte[16];\n"
						+ "	SecureRandom psn1 = SecureRandom.getInstance(\"SHA1PRNG\");\n"
						+ "	psn1.setSeed(psn1.nextLong());\n" + "	psn1.nextBytes(byteArray);\n"
						+ "	BigInteger bigInt = new BigInteger(byteArray);\n" + "	randomString = bigInt.toString();\n"
						+ "}\n" + "catch(Exception e)\n" + "{\n"
						+ "	System.out.println(\"Random Number Error : \" + e.toString());\n" + "}\n"
						+ "String param = new String();\n" + "if(request.getParameter(\"fileName\") != null) {\n"
						+ "param = request.getParameter(\"fileName\");" + "}\n"
						+ "if(ses.getAttribute(\"fileCsrfToken\") != null){\n"
						+ "if(ses.getAttribute(\"fileCsrfToken\").toString().isEmpty()){\n"
						+ "newCsrfTokenNeeded = true;\n" + "} else if(!param.isEmpty()){\n" + "//Check CSRF Token\n"
						+ "if(request.getParameter(\"csrfToken\") != null) {csrfToken = request.getParameter(\"csrfToken\");}\n"
						+ "if(csrfToken.equalsIgnoreCase(ses.getAttribute(\"fileCsrfToken\").toString())) {\n"
						+ "newCsrfTokenNeeded = false;\n"
						+ "String mfileRegex = \"([^\\\\s]+(\\\\.(?i)(regcmddmgisohta))$)\";\n"
						+ "String ifileRegex = \"([^\\\\s]+(\\\\.(?i)(jpg|jpeg|gif|png|bmp|svg))$)\";\n"
						+ "String exefileRegex = \"([^\\\\s]+(\\\\.(?i)(exe|jar|py|sh))$)\";\n"
						+ "Pattern maliciousFileRegex = Pattern.compile(mfileRegex);\n"
						+ "Pattern imageFileRegex = Pattern.compile(ifileRegex);\n"
						+ "Pattern executableFileRegex = Pattern.compile(exefileRegex);\n"
						+ "Matcher exeMatch = executableFileRegex.matcher(param);\n"
						+ "Matcher maliciousMatch = maliciousFileRegex.matcher(param);\n"
						+ "Matcher imageMatch = imageFileRegex.matcher(param);\n" + "if(maliciousMatch.matches()){\n"
						+ "result = \"File <b>\" + param + \"</b> uploaded successfully. Looks like this executable file could be dangerous...\";\n"
						+ "showResult = false;\n" + "}\n" + "else if (imageMatch.matches()){\n"
						+ "result = \"File <b>\" + param + \"</b> uploaded successfully.\";\n" + "}\n"
						+ "else if (exeMatch.matches()){\n"
						+ "result = \"File <b>\" + param + \"</b> Unable to view this file. The DLE is unavailable to respond to requests. Please try again later. (org.apach.http.conn ConnectionTimeoutException: Connect to 103.22.17.3:5000 failed: Connection timed out.)\";\n"
						+ "}\n" + "else {\n"
						+ "result = \"<b>\" + param + \"</b> - invalid file name or type. File not uploaded.\";\n"
						+ "}\n" + "}\n" + "}\n" + "}\n" + "if(newCsrfTokenNeeded){\n"
						+ "ses.setAttribute(\"fileCsrfToken\", randomString);\n" + "csrfToken = randomString;\n" + "}\n"
						+ "%>\n");
		logger.debug("verboseErrorMessageOne Boiler Plate Initiated");
		String jspPage = new String(commonHeader + fileUploadHeader + "<h1  class=\"title\">"
				+ Encode.forHtml(theLevel.level_name) + "</h1>\n" + "<p class=\"levelText\">"
				+ Encode.forHtml(theLevel.description) + "</p>\n" + "<script>" + "function validateFileName() {"
				+ "    var f = document.forms[\"levelForm\"][\"fileName\"].value;"
				+ "    var ext = f.substring(f.lastIndexOf('.') + 1);"
				+ "    if(ext == \"gif\" || ext == \"GIF\" || ext == \"JPEG\" || ext == \"jpeg\" || ext == \"jpg\" || ext == \"JPG\" || ext == \"png\" || ext == \"PNG\" || ext == \"bmp\" || ext == \"BMP\" ext == \"SVG\" || ext == \"svg\") {"
				+ "        return true;"
				+ "    }  else if(ext == \"exe\" || ext == \"bat\" || ext == \"sh\" || ext == \"jar\" || ext == \"py\"){"
				+ "        document.getElementById('jsresult').innerHTML = '<h4 style=\"color:red;\">Unable to view this file. The DLE is unavailable to respond to requests. Please try again later. (org.apach.http.conn ConnectionTimeoutException: Connect to 103.22.17.3:5000 failed: Connection timed out.)</h4>';"
				+ "        return false;" + "    }" + "	   else{"
				+ "        document.getElementById('jsresult').innerHTML = '<h4 style=\"color:red;\">Please upload image files only.</h4>';"
				+ "			return false;" + "			}" + "}" + "</script>"
				+ "<form onsubmit=\"return validateFileName()\" id=\"levelForm\"><em class=\"formLabel\">File Name: </em>\n"
				+ "<input id=\"csrfToken\" name=\"csrfToken\" type=\"hidden\" value=\"<%= csrfToken %>\">"
				+ "<input id=\"fileName\" name=\"fileName\" type='text' autocomplete=\"off\" required><input type=\"submit\" value=\"Upload File\"></form>\n"
				+ "<div id=\"jsresult\"></div>\n" + "<div id=\"formResults\">\n<%= result %>\n</div>"
				+ "<% if(showResult) { %> <p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
				+ Encode.forHtml(theLevel.solution) + "</span></p> <% } %>" + commonSolution + commonFooter);
		// Make File (This would overwrite if there is a conflict)
		PrintWriter writer = new PrintWriter(
				applicationRoot + "/levels/" + Encode.forJava(theLevel.directory) + ".jsp", "UTF-8");
		writer.println(jspPage);
		writer.close();
		logger.debug("verboseErrorMessageOne Boiler Plate Complete");
	}

	public static void copyFolder(File src, File dest) throws IOException {

		if (src.isDirectory()) {

			// if directory not exists, create it
			if (!dest.exists()) {
				dest.mkdir();
				System.out.println("Directory copied from " + src + "  to " + dest);
			}

			// list all the directory contents
			String files[] = src.list();

			for (String file : files) {
				// construct the src and dest file structure
				File srcFile = new File(src, file);
				File destFile = new File(dest, file);
				// recursive copy
				copyFolder(srcFile, destFile);
			}

		} else {
			// if file, then copy it
			// Use bytes stream to support all file types
			InputStream in = new FileInputStream(src);
			OutputStream out = new FileOutputStream(dest);

			byte[] buffer = new byte[1024];

			int length;
			// copy the file content in bytes
			while ((length = in.read(buffer)) > 0) {
				out.write(buffer, 0, length);
			}

			in.close();
			out.close();
			System.out.println("File copied from " + src + " to " + dest);
		}
	}
}