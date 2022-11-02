package utils;

import org.owasp.encoder.Encode;

public class GetterStatements 
{
	public static String get_all_scores_by_date = "select users.faction, (select name from levels where levels.id = scoreboard_breakdown.fk_level_id), scoreboard_breakdown.score, scoreboard_breakdown.submitted, users.username, users.email from users, scoreboard_breakdown where scoreboard_breakdown.username = users.username order by scoreboard_breakdown.submitted";
	
	public static String get_all_scores_by_username = "select users.faction, (select name from levels where levels.id = scoreboard_breakdown.fk_level_id), scoreboard_breakdown.score, scoreboard_breakdown.submitted, users.username from users, scoreboard_breakdown where scoreboard_breakdown.username = users.username and users.username = ? order by scoreboard_breakdown.submitted";
	
	public static String get_all_faction_scores_by_username = "select users.faction, (select name from levels where levels.id = scoreboard_breakdown.fk_level_id), scoreboard_breakdown.score, scoreboard_breakdown.submitted, users.username from users, scoreboard_breakdown where scoreboard_breakdown.username = users.username and users.username = ? order by scoreboard_breakdown.submitted"; 
			
	public static String get_all_scores_by_faction = "select sum(scoreboard_breakdown.score), users.username from users, scoreboard_breakdown where scoreboard_breakdown.username = users.username and faction = ? group by users.username";

	public static String get_all_scores_in_a_faction_by_username = "select sum(scoreboard_breakdown.score), users.faction, users.username from users, scoreboard_breakdown where scoreboard_breakdown.username = users.username and faction = (select users.faction from users where users.username = ?) group by users.username, users.faction";
	
	public static String get_all_scores_aggregated_by_faction = "Select users.faction, SUM(scoreboard_breakdown.score) from users, scoreboard_breakdown  where scoreboard_breakdown.username = users.username group by users.faction";
	
	public static String get_all_factions = "select faction from users";
	
	public static String get_all_open_challenges_by_time = "select directory, id,name,sans25Category,status,originalScore,timeopened from levels where status = 'enabled' AND timeopened is not NULL order by timeopened DESC";
	
	public static String get_10_open_challenges_by_time = "select directory, id,name,sans25Category,status,originalScore,timeopened from levels where status = 'enabled' AND timeopened is not NULL order by timeopened DESC LIMIT 10";
	
	public static String get_all_members_of_my_faction = "select firstname, lastname, email, username from users where faction = ?";
	
	public static String get_level_details_by_directory = "select * from levels where directory = ?";
	
	public static String get_basic_performance_stats = "(Select count(*) from claimed where userid = (select id from users where username = ?) and award IS NOT NULL)\r\n"
			+ "UNION ALL\r\n"
			+ "(Select count(*) from claimed where userid = (select id from users where username = ?))\r\n"
			+ "UNION ALL\r\n"
			+ "(Select count(*) from claimed where award IS NOT NULL)\r\n"
			+ "UNION ALL\r\n"
			+ "(Select count(*) from claimed);";
	
	public static String get_faction_member_by_solve_time = "select distinct SB.username, SB.submitted, l.name, U.faction\r\n"
			+ "from scoreboard_breakdown SB\r\n"
			+ "JOIN levels l on l.id = SB.fk_level_id\r\n"
			+ "JOIN users U on U.username = SB.username\r\n"
			+ "where faction = ?";
	
	public static String  get_faction_login_activity = "SELECT * FROM ACTIVITY where faction = ? ORDER BY lastlogin DESC limit 10";
	
	public static String get_admin_comments = "SELECT * FROM admincomments ORDER BY submitted limit 10";
	
	public static String get_more_player_data = "select score, submitted, fk_level_id AS levelId from scoreboard_breakdown where username = ?";
}
