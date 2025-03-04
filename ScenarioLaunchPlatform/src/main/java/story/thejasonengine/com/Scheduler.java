/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package story.thejasonengine.com;

import java.util.List;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Scheduler 
{

	private static final Logger LOGGER = LogManager.getLogger(Scheduler.class);
	private List<Story> storyList;
	private long delayInMillis;

	public Scheduler(List<Story> storyList, long delayInMillis) 
	{
        this.storyList = storyList;
        this.delayInMillis = delayInMillis;
    }
	
	public void runStoryInSequence() 
	{
        for (Story story : storyList) 
        {
            story.execute();
            try 
            {
                // Introduce a delay between jobs
                Thread.sleep(delayInMillis);
            } 
            catch (InterruptedException e) 
            {
                LOGGER.error("Story execution was interrupted:" + e.toString());
                Thread.currentThread().interrupt();
            }
        }
    }

}


