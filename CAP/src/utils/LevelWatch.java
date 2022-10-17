package utils;

import static java.nio.file.StandardWatchEventKinds.ENTRY_CREATE;
import static java.nio.file.StandardWatchEventKinds.ENTRY_DELETE;
import static java.nio.file.StandardWatchEventKinds.ENTRY_MODIFY;

import java.io.File;
import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.WatchEvent;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.Date;
import java.util.Properties;
import java.util.Random;

import org.apache.commons.io.FileUtils;
import org.owasp.encoder.Encode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import levelUtils.BoilerPlates;
import levelUtils.Level;
import levelUtils.SaxParser;
import levelUtils.UniZipper;
 

public class LevelWatch {
	private final Logger logger = LoggerFactory.getLogger(LevelWatch.class);
 
    public void startService(String applicationRoot)
    {
        try {
        	logger.debug("Starting Service");
            WatchService watcher = FileSystems.getDefault().newWatchService();
            Properties siteProperties = PropertiesReader.readSiteProperties();
    		String activefolder = siteProperties.getProperty("activefolder");
    		String swapSpace = siteProperties.getProperty("swapSpace");
    		
            Path dir = Paths.get(activefolder);
            dir.register(watcher, ENTRY_CREATE, ENTRY_DELETE, ENTRY_MODIFY);
             
            logger.debug("Watch Service registered for dir: " + dir.getFileName());
             
            while (true) 
            {
                WatchKey key;
                try {
                    key = watcher.take();
                } 
                catch (InterruptedException ex) 
                {
                    return;
                }
                 
                for (WatchEvent<?> event : key.pollEvents()) {
                    WatchEvent.Kind<?> kind = event.kind();
                     
                    @SuppressWarnings("unchecked")
                    WatchEvent<Path> ev = (WatchEvent<Path>) event;
                    Path fileName = ev.context();
                    logger.debug(kind.name() + ": " + fileName);
                    if(kind.name().equalsIgnoreCase("ENTRY_DELETE"))
                    {
                    	logger.debug("A zip has been removed from the active folder, removing it from the application as result");
                    	File jspFile = new File(applicationRoot+"/levels/"+fileName.toString().substring(0, fileName.toString().length()-4)+".jsp");
                    	File swapFile = new File(swapSpace+"/"+fileName.toString().substring(0, fileName.toString().length()-4));
                    	File artifactDirectory = new File(applicationRoot+"/levels/"+fileName.toString().substring(0, fileName.toString().length()-4));
                    	if(jspFile.delete())
                		{
                			logger.debug("Successfully deleted: " + applicationRoot+"/levels/"+fileName.toString().substring(0, fileName.toString().length()-4)+".jsp");
                			if(artifactDirectory.exists())
                			{
                				logger.debug("Level has Artifact Directory, deleting it and it's contents");
                				deleteFolder(artifactDirectory);
                				if(!artifactDirectory.exists())
                				{
                					logger.debug("Deleted Artifact Directory");
                				}
                				else
                				{
                					logger.error("Could not Delete Artifact Directory");
                				}
                			}
                			else
                				logger.debug("Level does not have an artifact to delete... Skipping");
                			/*
                			We will no longer leverage this managment service for the creation/deletion of content. As the database and challenges will be pre-populated moving forward*
                			*Obviously this plan will change and be a nightmare to re-instate :)
                			Api api = new Api();
                            api.setPersistantDatabase(fileName.toString().substring(0, fileName.toString().length()-4), "easy", "moot", "moot", "disabled");
                			*/
                		}
                		else
                		{
                			logger.error("Unable to delete:" +applicationRoot+"/levels/"+fileName.toString().substring(0, fileName.toString().length()-4)+".jsp" +" manually investigate+");
                		}
                    	deleteFolder(swapFile);
                    }
                    if(kind.name().equalsIgnoreCase("ENTRY_CREATE"))
                    {
                    	if(fileName.toString().contains(".zip"))
                    	{
                    		String timeStamp = new SimpleDateFormat("dd.MM.HH.mm.ss").format(new Date());
                    		UniZipper UZ = new UniZipper();
                    		UZ.unzip(activefolder+"/"+fileName.toString(),swapSpace+"/"+timeStamp);
                    		logger.debug("Successfully Unzipped Folder to Swap Space");
                    		File xmlFile = new File(swapSpace+"/"+timeStamp+"/level.xml");
                    		Level leveltmp = new Level();
                    		SaxParser.start(FileUtils.readFileToString(xmlFile), leveltmp);
                    		
                    		if(leveltmp.getDirectory() == null)
                            {
                            	logger.debug("....... -> No directory parameter was found in the XML document. Creating one");
                            	String directory = createNewDirectoryHash();
                            	logger.debug("....... -> Created directory: " + directory);
                            	leveltmp.setDirectory(directory);
                            }
                            else
                            {
                            	logger.debug("....... -> A directory parameter was found in the document: " + leveltmp.getDirectory());
                            }
                            
                    		
                    		
                    		File unzippeddir = new File(swapSpace+"/"+timeStamp);
                            /* Original - replaced with a new directory field in the xml schema*/
                    		File xmldirName = new File(swapSpace+"/"+leveltmp.getLevel_name());
                            
                    		//File xmldirName = new File(swapSpace+"/"+leveltmp.getDirectory());
                            
                            
                            if(unzippeddir.renameTo(xmldirName))
                            {
                            	/*	Original - replaced with a new directory field in the xml schema*/
                            		logger.debug("Successfully renamed directory to: " + leveltmp.getLevel_name());
                            	
                            	//logger.debug("Successfully renamed directory to: " + xmldirName.getName());
                            	
                            	BoilerPlates.applyBoilerPlate(leveltmp, applicationRoot);
                            	logger.debug("Checking if Artifact Level");
                            	if(leveltmp.getArtifact() == null)
                            		logger.debug("Null Artifact... So there isnt");
                            	else if(!leveltmp.getArtifact().trim().isEmpty() && !leveltmp.getArtifact().trim().startsWith("--"))
                            	{
                            		logger.debug("Arifact Level Detected: Found '" + leveltmp.getArtifact().trim() + "' String From XML");
                            		String artifactFileName = leveltmp.getArtifact();
                            		logger.debug("Make Directory based on level Name");
                            		
                            		/*	Original - replaced with a new directory field in the xml schema */
                            		File artifactDirectory = new File(applicationRoot + "/levels/" + Encode.forJava(leveltmp.getLevel_name()));
                            		
                            		//File artifactDirectory = new File(applicationRoot + "/levels/" + Encode.forJava(xmldirName.getName()));
                            		
                            		if(artifactDirectory.mkdir())
                            		{
                            			logger.debug("Directory Created. Putting Artifact in Directory");
                            			/*	Original - replaced with a new directory field in the xml schema*/
                                		String source = swapSpace+"/"+leveltmp.getLevel_name()+"/artifacts/"+artifactFileName;
                            			
                            			//String source = swapSpace+"/"+xmldirName.getName()+"/artifacts/"+artifactFileName;
                            			
                            			logger.debug("Source: " + source);
                            			File zipArtifact = new File(source);
                            			FileUtils.copyFileToDirectory(zipArtifact, artifactDirectory);
                            			File levelArtifact = new File (artifactDirectory + "/" + artifactFileName);
                            			if(levelArtifact.exists())
                            			{
                            				logger.debug("Created " + artifactFileName + " successfully");
                            			}
                            			else
                            			{
                            				logger.error("Failed to Create Artifact: " + artifactFileName);
                            			}
                            		}
                            	}
                            }
                            else
                            {
                            	logger.error("Unable to rename swap folder");
                            }
                            /*	Original - replaced with a new directory field in the xml schema*/
                            File hold = new File(activefolder+"/"+leveltmp.getLevel_name()+".zip");
                            
                            //File hold = new File(activefolder+"/"+xmldirName.getName()+".zip");
                            
                            File Orig = new File(activefolder+"/"+fileName.toString());
                           
                            if(Orig.renameTo(hold))
                            {
                            	logger.debug("Successfully renamed: "+Orig.toString() + " to: " + hold.toString());
                            }
                            else
                            {
                            	logger.error("Unable to rename: "+Orig.toString() + " to: " + hold.toString());
                            }
                            Api api = new Api();
                            /*	Original - replaced with a new directory field in the xml schema*/
                            //api.setPersistantDatabase(leveltmp.getDirectory(), leveltmp.getLevel_name(), leveltmp.getDifficulty(), leveltmp.getOWASPCategory(), leveltmp.getSANS25Category(), "enabled");
                            
                            
                            
                            api.setPersistantDatabase(leveltmp.getDirectory(), leveltmp.getLevel_name(), leveltmp.getDifficulty(), leveltmp.getOWASPCategory(), leveltmp.getSANS25Category(), "enabled");
                            
                    	}
                    	else
                    	{
                    		logger.debug("non zip file uploaded. Deleting the file from the server");
                    		File f = new File(activefolder+"/"+fileName.toString());
                    		if(f.delete())
                    		{
                    			logger.debug("Successfully deleted: " + activefolder+"/"+fileName.toString());
                    		}
                    		else
                    		{
                    			logger.error("Unable to delete:" + activefolder+"/"+fileName.toString() +" manually investigate+");
                    		}
                    	}
                    }
                    if (kind == ENTRY_MODIFY && fileName.toString().equalsIgnoreCase("killLevelWatchService.now")) 
            		{
            	 		logger.debug("Killing the level watch service now, you will need to restart it");
                		break;
            		}
                }
                boolean valid = key.reset();
                if (!valid) 
                {
                    break;
                }
            }
        } 
        catch (IOException ex) 
        {
            logger.error(ex.toString());
        }
    }
    public String createNewDirectoryHash()
    {
    	String hold = "";
    	long now = Instant.now().toEpochMilli();
    	Random rand = new Random();
    	
    	Long  temp = Long.sum(now, rand.nextLong());  
    	hold = hold + Long.toString(temp);
    	return getMd5(hold);
    }
    
    public String getMd5(String input)
    {
    	String hashtext ="";
    	try {
  
            MessageDigest md = MessageDigest.getInstance("MD5");
  
            // digest() method is called to calculate message digest
            //  of an input digest() return array of byte
            byte[] messageDigest = md.digest(input.getBytes());
  
            // Convert byte array into signum representation
            BigInteger no = new BigInteger(1, messageDigest);
  
            // Convert message digest into hex value
            hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            
        } 
  
        // For specifying wrong message digest algorithms
        catch (Exception e) 
        {
            logger.error("unable to create new hash: " + e.toString());
        }
    	return hashtext;
    }
    
    public void stopService()
    {
    	//to do
    }
    public void monitorService()
    {
    	//to do
    }
    public static void deleteFolder(File folder) {
        File[] files = folder.listFiles();
        if(files!=null) { //some JVMs return null for empty dirs
            for(File f: files) {
                if(f.isDirectory()) {
                    deleteFolder(f);
                } else {
                    f.delete();
                }
            }
        }
        folder.delete();
    }
}