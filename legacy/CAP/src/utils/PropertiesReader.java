package utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PropertiesReader {
	private static final Logger logger = LoggerFactory
			.getLogger(PropertiesReader.class);
	private static final String SITE_PROPERTIES_FILENAME = "site.properties";
	private static final String KEYS_PROPERTIES_FILENAME = "keys.properties";

	/**
	 * Get all properties defined in a .properties file
	 * 
	 * @param filename
	 *            the filename containing the properties
	 * @return A Properties object containing all read properties
	 */
	public static Properties readProperties(String filename) {
		Properties props = new Properties();
		InputStream inputStream = PropertiesReader.class.getClassLoader()
				.getResourceAsStream(filename);
		try {
			props.load(inputStream);
		} catch (IOException ioe) {
			logger.error(ioe.getMessage());
		} finally {
			if (inputStream != null) {
				try {
					inputStream.close();
				} catch (IOException e) {
					logger.error(e.getMessage());
				}
			}
		}

		// logger.debug("Read " + props.size() + " properties from " +
		// filename);

		return props;
	}

	/**
	 * Get all properties defined in the site.properties file.
	 * 
	 * @return A Properties object containing all read properties
	 */
	public static Properties readSiteProperties() {
		return readProperties(SITE_PROPERTIES_FILENAME);
	}
	public static Properties readKEYSProperties() {
		return readProperties(KEYS_PROPERTIES_FILENAME);
	}
}