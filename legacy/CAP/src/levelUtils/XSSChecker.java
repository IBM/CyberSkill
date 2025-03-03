package levelUtils;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Properties;

import org.apache.http.HttpEntity;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.config.RequestConfig.Builder;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.FileEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import utils.PropertiesReader;

public class XSSChecker {
	private static final Logger logger = LoggerFactory.getLogger(XSSChecker.class);

	private static final int REQUEST_TIMEOUT_SECS = 2;
	
	/**
	 * Legacy from Old Bootcamp Searches for URL that contains CSRF attack string. Returns true if it is valid based on parameters submitted
	 * @param theUrl The Entire URL containing the attack
	 * @param csrfAttackPath The path the CSRF vulnerable function should be in
	 * @param userIdParameterName The user ID parameter name expected
	 * @param userIdParameterValue The user ID parameter value expected
	 * @return boolean value depicting if the attack is valid or not
	 */
	public static boolean findCsrfAttackUrl (String theUrl, String csrfAttackPath, String userIdParameterName, String userIdParameterValue ) 
	{
		boolean validAttack = false;
		try
		{
			URL theAttack = new URL(theUrl);
			logger.debug("Attack URL Submitted: " + theAttack);
			logger.debug("csrfAttackPath: " + csrfAttackPath);
			logger.debug("theAttack Host: " + theAttack.getHost());
			logger.debug("theAttack Port: " + theAttack.getPort());
			logger.debug("theAttack Path: " + theAttack.getPath());
			logger.debug("theAttack Query: " + theAttack.getQuery());
			validAttack = theAttack.getPath().toLowerCase().equalsIgnoreCase(csrfAttackPath);
			if(!validAttack)
			{
				logger.debug("Valid Path:    " + theAttack.getPath().toLowerCase());
				logger.debug("Submited Path: " + csrfAttackPath);
				logger.debug("Invalid Solution: Bad Path or Above");
			}
			validAttack = theAttack.getQuery().toLowerCase().equalsIgnoreCase((userIdParameterName + "=" + userIdParameterValue).toLowerCase()) && validAttack;
			if(!validAttack)
				logger.debug("Invalid Solution: Bad Query or Above");
		}
		catch(MalformedURLException e)
		{
			logger.debug("Invalid URL Submitted: " + e.toString());
			validAttack = false;
		}
		catch(Exception e)
		{
			logger.error("FindCSRF Failed: " + e.toString());
			validAttack = false;
		}
		return validAttack;
	} 
	
	public boolean verifyXss(File sourceFile, String filteredInput) throws Exception {
		return verifyXss(sourceFile, filteredInput, "<%= output %>");
	}

	public boolean verifyXss(File sourceFile, String filteredInput, String outputPattern) throws Exception {
		boolean xssVerified = false;
		CloseableHttpResponse closeableHttpResponse = null;

		logger.debug("File exists = " + sourceFile.exists());

		Properties siteProperties = PropertiesReader.readSiteProperties();
		String xssVerifierUrl = siteProperties.getProperty("urlXSSCheckServer");

		if (xssVerifierUrl == null) {
			logger.error("XSS Verification disabled; all xss challenges will fail");
			return false;
		}

		CloseableHttpClient httpClient = HttpClients.createDefault();

		HttpPost httpPost = new HttpPost(xssVerifierUrl);
		Builder requestConfigBuilder = RequestConfig.copy(RequestConfig.DEFAULT);
		requestConfigBuilder.setSocketTimeout(REQUEST_TIMEOUT_SECS * 1000);
		requestConfigBuilder.setConnectTimeout(REQUEST_TIMEOUT_SECS * 1000);
		requestConfigBuilder.setConnectionRequestTimeout(REQUEST_TIMEOUT_SECS * 1000);
		httpPost.setConfig(requestConfigBuilder.build());

		httpPost.addHeader("X-Wargames-XSS-Name", sourceFile.getName());
		httpPost.addHeader("X-Wargames-XSS-Input", filteredInput);
		httpPost.addHeader("X-Wargames-XSS-Output", outputPattern);

		FileEntity fileEntity = new FileEntity(sourceFile, ContentType.create("text/plain", "UTF-8"));
		httpPost.setEntity(fileEntity);
		

		try {
			logger.debug("Verifying the player's XSS at " + xssVerifierUrl + "...");
			closeableHttpResponse = httpClient.execute(httpPost);
			HttpEntity entity = closeableHttpResponse.getEntity();
			String response = EntityUtils.toString(entity);
			EntityUtils.consume(entity);

			logger.debug("Server response = " + response);

			JsonParser jsonParser = new JsonParser();
			JsonObject jsonObject = jsonParser.parse(response).getAsJsonObject();
			if (jsonObject.get("xss") != null) {
				return jsonObject.get("xss").getAsBoolean();
			}
		} catch (Exception e) {
			logger.error("Error communicating with XSS Verifier server: " + e.getMessage());
			throw e;
		} finally {
			if (closeableHttpResponse != null) {
				closeableHttpResponse.close();
			}
		}

		return xssVerified;
	}
}
