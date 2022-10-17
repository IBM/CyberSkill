package utils;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.owasp.encoder.Encode;

import levelUtils.Level;

public class JSONUtil {
	public String theLevelSolution;
	public String theLevelQuestions;
	public ArrayList<JSONArray> containsArray;
	public JSONObject resultData;
	public String result;
	public String output = "";
	public int questionCount;
	public int containsArrayCounter;

	public JSONUtil(String theLevelSolution, String theLevelQuestions, ArrayList<JSONArray> containsArray,
			JSONObject resultData, String result) {
		this.theLevelSolution = theLevelSolution;
		this.theLevelQuestions = theLevelQuestions;
		if (containsArray == null) {
			this.containsArray = new ArrayList<JSONArray>();
		} else {
			this.containsArray = containsArray;
		}
		this.resultData = resultData;
		this.result = result;
	}

	public static JSONArray getJSONArray(JSONObject object, String JSONKey) {
		JSONArray jArray = new JSONArray();
		jArray = (JSONArray) object.get(JSONKey);
		System.out.println("Returning data as JSONArray: " + jArray.toString());
		return jArray;
	}

	private static Boolean getIgnoreCase(JSONArray jobj, String key) {

	    @SuppressWarnings("unchecked")
		Iterator<String> iter = jobj.iterator();
	    while (iter.hasNext()) {
	        String key1 = iter.next();
	        if (key1.equalsIgnoreCase(key)) {
	           return true;
	        }
	    }

	    return false;

	}
	
	public static Boolean compareUserAnswer(JSONArray jArray, String userAnswer) {
		System.out.println("userAnswer in compareUserAnswer: " + userAnswer);
		if (userAnswer.equals("") || userAnswer.equals(null)) {
			System.out.println("userAnswer was empty");
			return false;
		}
		System.out.println("Possible answers: " + jArray.toString());

		for (int i = 0; i < jArray.size(); i++) {
			if (getIgnoreCase(jArray, userAnswer)) {
				System.out.println("Match found for "+ userAnswer + " in "+ jArray.toString() +". Returning True");
				return true;
			}
		}
		System.out.println("Match not found for "+ userAnswer + " in "+ jArray.toString() +". Returning False");
		return false;
	}

	@SuppressWarnings("unchecked")
	public void questionType(HttpServletRequest request) {
		JSONParser parser = new JSONParser();
		questionCount = 0;
		try {
			System.out.println("In questionType");
			System.out.println(theLevelQuestions);
			JSONArray jsonArray = (JSONArray) parser.parse(theLevelQuestions);
			System.out.println("jsonArray parsed");
			for (int i = 0; i < jsonArray.size(); i++) {
				boolean containsFound = false;
				JSONObject questionJsonObj = (JSONObject) jsonArray.get(i);
				String questionStr = (String) questionJsonObj.get("question");
				String answerStr = (String) questionJsonObj.get("answer");
				String q = "question_" + questionCount;
				String kindOfMatch = (String) questionJsonObj.get("kindOfMatch");
				String userAnswerStr = "";
				if (request.getParameter(q) != null)
					userAnswerStr = request.getParameter(q);
				if (kindOfMatch.equalsIgnoreCase("MCQ")) {
					JSONArray possibleAnswers = (JSONArray) questionJsonObj.get("possibleAnswers");
					output += "<p><b>" + questionStr + "</b></p>\n";
					System.out.println("User answer: " + URLDecoder.decode(userAnswerStr));
					for (int m = 0; m < possibleAnswers.size(); m++) {
						System.out.println("Possible answer: " + (String) possibleAnswers.get(m));
						if (userAnswerStr.equalsIgnoreCase((String) possibleAnswers.get(m))) {
							System.out.println("Checked question: " + q);
							output += "<input type=\"radio\" name=\"" + q + "\" value=\"" + possibleAnswers.get(m)
									+ "\" checked><label for=\"" + q + "\">" + possibleAnswers.get(m) + "</label><br>";
						} else {
							output += "<input type=\"radio\" name=\"" + q + "\" value=\"" + possibleAnswers.get(m)
									+ "\"><label for=\"" + q + "\">" + possibleAnswers.get(m) + "</label><br>";
						}
					}
				} else if (kindOfMatch.equalsIgnoreCase("SANS")) {
					output += "<p><b>" + questionStr
							+ " <a href=\"../academy.jsp\" target=\"_blank\">Academy page</a></b></p>"
							+ "<select form=\"levelForm\" name=\"" + q + "\">";
					for (int t = 1; t < 26; t++) {
						String[] sansNames = {"Improper Neutralization of Special Elements used in an SQL Command ('SQL Injection')",
								"Improper Neutralization of Special Elements used in an OS Command ('OS Command Injection')",
								"Buffer Copy without Checking Size of Input ('Classic Buffer Overflow')",
								"Improper Neutralization of Input During Web Page Generation ('Cross-site Scripting')",
								"Missing Authentication for Critical Function",
								"Missing Authorization",
								"Use of Hard-coded Credentials",
								"Missing Encryption of Sensitive Data",
								"Unrestricted Upload of File with Dangerous Type",
								"Reliance on Untrusted Inputs in a Security Decision",
								"Execution with Unnecessary Privileges",
								"Cross-Site Request Forgery (CSRF)",
								"Improper Limitation of a Pathname to a Restricted Directory ('Path Traversal')",
								"Download of Code Without Integrity Check",
								"Incorrect Authorization",
								"Inclusion of Functionality from Untrusted Control Sphere",
								"Incorrect Permission Assignment for Critical Resource",
								"Use of Potentially Dangerous Function",
								"Use of a Broken or Risky Cryptographic Algorithm",
								"Incorrect Calculation of Buffer Size",
								"Improper Restriction of Excessive Authentication Attempts",
								"URL Redirection to Untrusted Site ('Open Redirect')",
								"Uncontrolled Format String",
								"Integer Overflow or Wraparound",
								"Use of a One-Way Hash without a Salt"};
						
						String valueName = "Sans" + String.valueOf(t);
						System.out.println("---- " + userAnswerStr);
						if (userAnswerStr.equalsIgnoreCase(valueName)) {
							System.out.println("Value for Sans: " + valueName);
							output += "<option value=\"" + valueName + "\" selected>" + sansNames[t-1] + "</options>";
						} else {
							output += "<option value=\"" + valueName + "\">" + sansNames[t-1] + "</options>";
						}
					}
					output += "</select>";
				} else if (kindOfMatch.equalsIgnoreCase("contains")) {
					containsArray.add(JSONUtil.getJSONArray(questionJsonObj, "contains"));
					containsFound = true;
					System.out
							.println("containsArray values are: " + containsArray.get(containsArrayCounter).toString());
					containsArrayCounter++;
					output += "<p><b>" + questionStr + "</b></p> <input type=\"text\" id=\"" + q + "\" name=\"" + q
							+ "\" value=\"" + userAnswerStr + "\"><br>";
				} else {
					output += "<p><b>" + questionStr + "</b></p> <input type=\"text\" id=\"" + q + "\" name=\"" + q
							+ "\" value=\"" + userAnswerStr + "\"><br>";
				}
				questionCount++;
				if (containsFound) {
					System.out.println("containsFound was true for question: " + q);
					resultData.put(q, "k0iezy96xo");
					result += "k0iezy96xo";
				} else {
					resultData.put(q, answerStr);
					result += answerStr;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("An exception occurred: " + e.getMessage());
		}
		System.out.println("\n");
	}

	public String processResult(HttpServletRequest request) {
		String UserResult = "";
		ArrayList<String> errorCount = new ArrayList<String>();
		boolean contains = false;
		int ContainsArrayCounter = 0;
		for (int k = 0; k < questionCount; k++) {
			String qs = "question_" + String.valueOf(k);
			if (request.getParameter(qs) != null) {
				if (containsArray != null) {
					try{
						System.out.println(resultData.toJSONString());
						if (resultData.get(qs).equals("k0iezy96xo")){
							System.out.println("User supplied answer in processResult for " + qs + " is " + request.getParameter(qs));
							// get(k) can be bigger than the number of containsArray values in the array. Needs a counter to track this independently
							if (JSONUtil.compareUserAnswer(containsArray.get(ContainsArrayCounter), request.getParameter(qs))) {
								System.out.println("User answer was found in containsArray");
								System.out.println(containsArray.toString());
								contains = true;
							}
							ContainsArrayCounter++;
						}
					}catch (IndexOutOfBoundsException e){
						System.out.println("containsArray value out of bounds");
					}
					catch (NullPointerException e){
						System.out.println("resultData element not found");
					}
				} else {
					System.out.println("Contains was false");
					contains = false;
				}
				if ((!request.getParameter(qs).equalsIgnoreCase((String) resultData.get(qs))) && (!contains)) {
					System.out.println(
							"User answer didn't match:" + request.getParameter(qs) + " vs " + resultData.get(qs));
					errorCount.add(qs);
				}
				if (!contains) {
					UserResult += request.getParameter(qs);
				} else {
					UserResult += "k0iezy96xo";
				}
			}
			contains = false;
			System.out.println(qs + " " + UserResult);
			System.out.println("\n");
		}
		output += "<br><input type=\"submit\" value=\"Submit\"></div></form>" + "<script>"
				+ "$( document ).ready(function() {";
		for (int x = 0; x < errorCount.size(); x++) {
			output += "$(\"#" + errorCount.get(x) + "\").addClass(\"AnswerError\");\n" + "$('input[name=\""
					+ errorCount.get(x) + "\"]:checked').addClass(\"AnswerError\");" + "$('select[name=\""
					+ errorCount.get(x) + "\"]').css(\"color\", \"red\");";
		}
		output += "});</script>";
		// TODO 
		System.out.println("Result answer vs User answer: " + result + " vs " + UserResult);
		if ("POST".equalsIgnoreCase(request.getMethod())) {
			if (UserResult.equalsIgnoreCase(result)) {
				output += "<p class=\"solutionKey\"> Well done, you have completed this challenge. Please use this key in the solution form to collect your points: <span id='actualKey'>"
						+ Encode.forHtml(theLevelSolution) + "</span></p>";
			} else {
				output += "<p style='color:red'>Wrong answer/s!</p>";
			}
		}
		return output;
	}
}
