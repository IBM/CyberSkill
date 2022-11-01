package utils;

public class SetterStatements {
	
	public final static String updateModuleFeedMonitor = "insert into modulefeedmonitor(username, submitted) VALUES (?, NOW())";
	
	public final static String submit_valid_solution = "select submitusersolution(?, ?)";
	
	public final static String user_login_activity = "INSERT INTO activity (firstname,lastname,username,comporganization,faction,lastlogin) VALUES (?,?,?,?,?,now())\r\n"
			+ "  ON CONFLICT (username)\r\n"
			+ "  DO\r\n"
			+ "  UPDATE SET lastlogin = now()";

}
