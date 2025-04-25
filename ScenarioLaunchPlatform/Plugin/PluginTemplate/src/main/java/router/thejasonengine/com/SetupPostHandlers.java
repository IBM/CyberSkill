/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package router.thejasonengine.com;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;


public class SetupPostHandlers 
{
	private static final Logger LOGGER = LogManager.getLogger(SetupPostHandlers.class);
	
	
	public Handler<RoutingContext> runLoadRunner;
	
	
		
	public SetupPostHandlers(Vertx vertx)
    {
		
		runLoadRunner = SetupPostHandlers.this::handleRunLoadRunner;
		
		
	}
	private void handleRunLoadRunner(RoutingContext routingContext)
	{
		LOGGER.info("inside handleRunLoadRunner");
		LoadRunnerHandler.handleRunLoadRunner(routingContext);
	}
	
	
	/**
	 * @return **********************************************************/
	/*
	/* This function validates and returns true if JWT token validates
	/*
	/************************************************************/
	public static boolean validateJWTToken(JsonObject JSONpayload)
	{
		boolean result = false;
		
		
		LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
		
		String [] chunks = JSONpayload.getString("jwt").split("\\.");
		if(chunks.length > 2)
		{
			JsonObject header = new JsonObject(decode(chunks[0]));
			JsonObject payload = new JsonObject(decode(chunks[1]));
			
			LOGGER.info("Basic JWT structure test has passed with a payload of: " + payload );
			LOGGER.info("String to be base64Url Encoded: " + payload.encode());
			LOGGER.info("base64UrlEncoder: " +  base64UrlEncoder(payload.encode()));
			LOGGER.debug("Basic JWT structure test has passed with a header of: " + header);
			
			result = true;
			//Now validate that the user account is still active
			
		}
		else
		{
			result = false;
		}
		
		if(result == true)
		{
			//next validate the signature
			
			String headerPlusPayload = chunks[0] + "." + chunks[1];
			LOGGER.debug("headerPlusPayload: " + headerPlusPayload);
			
			String signature = chunks[2];
			LOGGER.debug("signature: " + signature);
		
			try
			{
				String generateSignature = hmacSha256(chunks[0].toString() + "." + chunks[1].toString(), "keyboard cat");
				LOGGER.debug("Generated signature: " + generateSignature);
				
				if(signature.compareTo(generateSignature)== 0)
				{
					LOGGER.debug("*********** JWT Signature match ***************");
				}
				else
				{
					LOGGER.error("**Potential security violation* JWT SIGNATURE ERROR**");
					result = false;
				}
			}
			catch(Exception e)
			{
				LOGGER.error("Uable to perform signature match of JWT Token: " + e.toString());
				result = false;
			}
		}
		return result;
	}
	/*********************************************************************************/
	public static String base64UrlEncoder(String originalInput)
	{
		String encodedString = Base64.getEncoder().encodeToString(originalInput.getBytes());
		return encodedString;
	}
	/*********************************************************************************/
	public String base64UrlDecoder(String encodedString)
	{
		byte[] decodedBytes = Base64.getDecoder().decode(encodedString);
		String decodedString = new String(decodedBytes);
		return decodedString;
	}
	/*********************************************************************************/
	public static String encode(byte[] bytes) 
	{
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
	}
	/*********************************************************************************/
	public static String decode(String encodedString) {
	    return new String(Base64.getUrlDecoder().decode(encodedString));
	}
	/*********************************************************************************/
	private static String hmacSha256(String data, String secret) {
	    try {

	        byte[] hash = secret.getBytes(StandardCharsets.UTF_8);
	        Mac sha256Hmac = Mac.getInstance("HmacSHA256");
	        SecretKeySpec secretKey = new SecretKeySpec(hash, "HmacSHA256");
	        sha256Hmac.init(secretKey);

	        byte[] signedBytes = sha256Hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));

	        return encode(signedBytes);
	    } 
	    catch (Exception e) 
	    {
	        LOGGER.error("Unable to encode: " + e.toString());
	        return null;
	    }
	}
	/**
	 * Method to hash and salt password before use
	 * @param inputPass
	 * @returns actual password in db for match
	 * 
	 */
	public static String hashAndSaltPass (String inputPass)
	{
		String salt = "Rasputin";
		//hash the input password for later comparison with password in db
		MessageDigest md = null;
		try 
		{
			md = MessageDigest.getInstance("SHA-256");
		} 
		catch (NoSuchAlgorithmException e1) 
		{
			LOGGER.error("SHA-256 Not Found: " + e1.toString());
		}
		String text = inputPass+salt;
		try 
		{
			md.update(text.getBytes("UTF-8"));
		} 
		catch (UnsupportedEncodingException e) 
		{
			LOGGER.error("Could not convert Hash to Encoding: " + e.toString());
		} 
		// Change this to "UTF-16" if needed
		byte[] digest = md.digest();
	
		//convert the byte to hex format method 1
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < digest.length; i++) 
        {
          sb.append(Integer.toString((digest[i] & 0xff) + 0x100, 16).substring(1));
        }
        
        return sb.toString();
	}
}
	
	
	

