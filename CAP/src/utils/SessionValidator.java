package utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SessionValidator {
	private static final Logger logger = LoggerFactory.getLogger(SessionValidator.class);

	public static boolean validate(HttpSession ses) {
		boolean result = false;
		if (ses == null) {
			logger.debug("No Session Found");
		} else {
			if (ses.getAttribute("JWT") != null) {
				logger.debug("JWT + " + ses.getAttribute("JWT").toString() + " detected");
				result = true;
			} else {
				logger.debug("Session has no JWT credentials");
			}
		}
		return result;
	}

	public static boolean isAdmin(HttpSession ses) throws SQLException {
		boolean result = false;
		if (ses == null) {
			logger.debug("No Session Found");
		} else {
			if (ses.getAttribute("userName") != null) {
				logger.error("User + " + ses.getAttribute("userName").toString() + " detected. Checking if Admin");
				Database db = new Database();
				Connection con = db.getConnection();
				PreparedStatement ps = con.prepareStatement("SELECT email FROM users WHERE email = ? AND admin = ?");
				ps.setString(1, ses.getAttribute("userName").toString().toLowerCase());
				ps.setBoolean(2, true);
				ResultSet rs = ps.executeQuery();
				if (rs.next()) {
					logger.debug("Admin found");
					result = true;
				} else {
					logger.error("Admin not found '" + ses.getAttribute("userName").toString() + "'");
				}
				rs.close();
				ps.close();
			} else {
				logger.error("Session has no credentials");
			}
		}
		return result;
	}

}
