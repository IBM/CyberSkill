package utils;

public class SetterStatements {
	
	public final static String updateModuleFeedMonitor = "insert into modulefeedmonitor(username, submitted) VALUES (?, NOW())";
	
	public final static String submit_valid_solution = "select submitusersolution(?, ?)";

}
