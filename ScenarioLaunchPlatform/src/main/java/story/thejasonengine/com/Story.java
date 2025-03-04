/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package story.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Story implements Builder
{
	private static final Logger LOGGER = LogManager.getLogger(Story.class);
	@Override
    public void execute() 
	{
        LOGGER.debug("Executing Story Component");
    }

}
