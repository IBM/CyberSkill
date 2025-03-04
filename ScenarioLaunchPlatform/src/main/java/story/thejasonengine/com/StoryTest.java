/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package story.thejasonengine.com;

import java.util.Arrays;

public class StoryTest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		 // Create the jobs
        Story story0 = new Story();
        Story story1 = new Story();
        Story story2 = new Story();
        
        
       
        
        
        long delayInMillis = 2000;  
        // Add jobs to the list
        Scheduler scheduler = new Scheduler(Arrays.asList(story0, story1, story2),delayInMillis);
        
        // Run the jobs in sequence
        scheduler.runStoryInSequence();

	}

}
