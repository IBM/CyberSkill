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
	public static String get_all_open_challenges_by_time = "select id,name,sans25Category,status,originalScore,timeopened from levels where status = 'enabled' AND timeopened is not NULL";
	
	
}
