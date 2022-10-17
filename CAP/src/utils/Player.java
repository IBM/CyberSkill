package utils;

public class Player  {

	private String email;
	private int score;
	private int scoreboardPosition;
	
	public Player(String email) {
		this.setEmail(email);
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public int getScore() {
		return score;
	}

	public void setScore(int score) {
		this.score = score;
	}

	public int getScoreboardPosition() {
		return scoreboardPosition;
	}

	public void setScoreboardPosition(int scoreboardPosition) {
		this.scoreboardPosition = scoreboardPosition;
	}
	
	
	
}
