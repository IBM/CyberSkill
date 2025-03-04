/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package utils.thejasonengine.com;

import org.apache.commons.text.StringEscapeUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import java.net.URLEncoder;
import java.net.URLDecoder;

public class Encodings 
{
	private static final Logger LOGGER = LogManager.getLogger(Encodings.class);
	public String EscapeString(String toEscape)
	{
		LOGGER.debug("Attempting to encode: " + toEscape);
		String escaped = "Error encoding query: ";
		//String escaped = StringEscapeUtils.escapeHtml4(toEscape);
		try
		{
			escaped  = URLEncoder.encode(toEscape, "UTF-8");
		}
		catch(Exception e)
		{
			escaped = escaped.concat(e.toString());
		}
		
		LOGGER.debug("Result of encode: " + escaped);
		
		return escaped;
	}
	public String UnescapeString(String toUnescape)
	{
		LOGGER.debug("Attempting to encode: " + toUnescape);
		String unescaped ="Error unencoding query: ";
		try
		{
			unescaped  = URLDecoder.decode(toUnescape, "UTF-8");
		}
		catch(Exception e)
		{
			unescaped = unescaped.concat(e.toString());
		}
		
		LOGGER.debug("Result of encode: " + unescaped);
		return unescaped;
	}
}
