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
import metrics.thejasonengine.com.MetricsCollector;

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
        MetricsCollector metrics = MetricsCollector.getInstance();
        
        for (Story story : storyList)
        {
            long startTime = System.currentTimeMillis();
            metrics.incrementActiveStories();
            
            try
            {
                story.execute();
                
                // Record successful story execution
                long duration = System.currentTimeMillis() - startTime;
                metrics.recordStory(true, duration);
                LOGGER.debug("Story executed successfully in {}ms", duration);
                
                // Introduce a delay between jobs
                Thread.sleep(delayInMillis);
            }
            catch (InterruptedException e)
            {
                long duration = System.currentTimeMillis() - startTime;
                metrics.recordStory(false, duration);
                metrics.recordError("InterruptedException", "Story execution was interrupted: " + e.toString(), getStackTrace(e));
                LOGGER.error("Story execution was interrupted:" + e.toString());
                Thread.currentThread().interrupt();
            }
            catch (Exception e)
            {
                long duration = System.currentTimeMillis() - startTime;
                metrics.recordStory(false, duration);
                metrics.recordError(e.getClass().getSimpleName(), "Story execution failed: " + e.getMessage(), getStackTrace(e));
                LOGGER.error("Story execution failed:" + e.toString(), e);
            }
            finally
            {
                metrics.decrementActiveStories();
            }
        }
    }
    
    private String getStackTrace(Exception e) {
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        e.printStackTrace(pw);
        return sw.toString();
    }

}


