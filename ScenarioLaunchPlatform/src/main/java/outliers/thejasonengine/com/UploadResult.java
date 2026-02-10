/*  Upload Result
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*/

package outliers.thejasonengine.com;

import java.util.ArrayList;
import java.util.List;

/**
 * Result object for ZIP upload operations
 */
public class UploadResult {
    
    private List<OutlierScript> addedScripts;
    private List<String> skippedDuplicates;
    
    public UploadResult() {
        this.addedScripts = new ArrayList<>();
        this.skippedDuplicates = new ArrayList<>();
    }
    
    public void addScript(OutlierScript script) {
        addedScripts.add(script);
    }
    
    public void addSkippedDuplicate(String scriptName) {
        skippedDuplicates.add(scriptName);
    }
    
    public List<OutlierScript> getAddedScripts() {
        return addedScripts;
    }
    
    public List<String> getSkippedDuplicates() {
        return skippedDuplicates;
    }
    
    public int getAddedCount() {
        return addedScripts.size();
    }
    
    public int getSkippedCount() {
        return skippedDuplicates.size();
    }
    
    public int getTotalProcessed() {
        return addedScripts.size() + skippedDuplicates.size();
    }
    
    public boolean hasDuplicates() {
        return !skippedDuplicates.isEmpty();
    }
}

