package levelUtils;

import java.io.IOException;
import java.io.StringReader;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;


public class SaxParser extends DefaultHandler {
	
    
    private static final Logger logger = LoggerFactory.getLogger(SaxParser.class);
    String tmpValue;
    
    boolean level_name = false;
    boolean directory = false;
    boolean difficulty = false;
    boolean tableSchemas = false;
    boolean inserts = false;
    boolean selects = false;
    boolean updates = false;
    boolean deletes = false;
    boolean solution = false;
    boolean description = false;
    boolean OWASPCategory = false;
    boolean SANS25Category = false;
    boolean clue1 = false;
    boolean clue2 = false;
    boolean clue3 = false;
    boolean boilerPlate = false;
    boolean filterPhrase = false;
    boolean artifact = false;
    boolean downloadDescription = false;
    boolean questions = false;
    boolean clientScript = false;
    boolean sourceCode = false;
    boolean sourceType = false;
    boolean downloadURL = false;
    
    Level level;
    
    public SaxParser(String xml, Level leveltmp) 
    {
    	level = leveltmp;
    	parseDocument(xml);
    }
    
    private void parseDocument(String xml) 
    {
        // parse
        SAXParserFactory factory = SAXParserFactory.newInstance();
        try 
        {
        	SAXParser parser = factory.newSAXParser();
            parser.parse(new InputSource(new StringReader(xml)), this);
        } 
        catch (ParserConfigurationException e) 
        {
            System.out.println("ParserConfig error: " + e.toString());
        } 
        catch (SAXException e) 
        {
            System.out.println("SAXException : xml not well formed: " + e.toString());
        } 
        catch (IOException e) 
        {
            System.out.println("IO error:" + e.toString());
        }
    }
    @Override
    public void startElement(String s, String s1, String elementName, Attributes attributes) throws SAXException 
    {
    	if (elementName.equalsIgnoreCase("name")) 
        {
    		level_name = true;
        }
    	if (elementName.equalsIgnoreCase("directory")) 
        {
    		directory = true;
        }
    	if (elementName.equalsIgnoreCase("difficulty")) 
        {
    		difficulty = true;
        }
    	if (elementName.equalsIgnoreCase("tableSchemas")) 
        {
    		tableSchemas = true;
        }
    	if (elementName.equalsIgnoreCase("inserts")) 
        {
    		inserts = true;
        }
    	if (elementName.equalsIgnoreCase("selects")) 
        {
    		selects = true;
        }
    	if (elementName.equalsIgnoreCase("updates")) 
        {
    		updates = true;
        }
    	if (elementName.equalsIgnoreCase("deletes")) 
        {
    		deletes = true;
        }
    	if (elementName.equalsIgnoreCase("solution")) 
        {
    		solution = true;
        }
    	if (elementName.equalsIgnoreCase("description")) 
        {
    		description = true;
        }
    	if (elementName.equalsIgnoreCase("OWASPCategory")) 
        {
    		OWASPCategory = true;
        }
    	if (elementName.equalsIgnoreCase("SANS25Category")) 
        {
    		SANS25Category = true;
        }
    	if (elementName.equalsIgnoreCase("clue1")) 
        {
    		clue1 = true;
        }
    	if (elementName.equalsIgnoreCase("clue2")) 
        {
    		clue2 = true;
        }
    	if (elementName.equalsIgnoreCase("clue3")) 
        {
    		clue3 = true;
        }
    	if (elementName.equalsIgnoreCase("boilerplate")) 
        {
    		boilerPlate = true;
        }
    	if (elementName.equalsIgnoreCase("filterPhrase")) 
        {
    		filterPhrase = true;
        }
    	if (elementName.equalsIgnoreCase("artifact")) 
        {
    		artifact = true;
        }
    	if (elementName.equalsIgnoreCase("downloadDescription")) 
        {
    		downloadDescription = true;
        }
    	if (elementName.equalsIgnoreCase("questions")) 
        {
    		questions = true;
        }
    	if (elementName.equalsIgnoreCase("clientScript")) 
        {
    		clientScript = true;
        }
    	if (elementName.equalsIgnoreCase("sourceCode")) 
        {
    		sourceCode = true;
        }
    	if (elementName.equalsIgnoreCase("sourceType")) 
        {
    		sourceType = true;
        }
    	if (elementName.equalsIgnoreCase("downloadURL")){
    		downloadURL = true;
    	}
    }
    
    @Override
    public void endElement(java.lang.String uri,java.lang.String localName,java.lang.String elementName)
    throws SAXException
    {
    	 //Only write the packet to the database when we have hit the closing PACKET string.
    	if (elementName.equalsIgnoreCase("level")) 
        {
    		try
	        {
	        	logger.debug("End of level.xml detail detected");
	        }
	        catch(Exception e)
	        {
	        	logger.error("Unable to parse level.xml: "+ e.getMessage());
	        }
        }
     }
    @Override
    public void characters(char[] ac, int i, int j) throws SAXException 
    {
    	tmpValue = new String(ac, i, j);
    	if (level_name) 
    	{
			logger.info("Level Name : " + tmpValue);
			level.setLevel_name(tmpValue);
			level_name = false;
		}
    	if (directory) 
    	{
			logger.info("directory : " + tmpValue);
			level.setDirectory(tmpValue);
			directory = false;
		}
    	if (difficulty) 
    	{
			logger.info("difficulty : " + tmpValue);
			level.setDifficulty(tmpValue);
			difficulty = false;
		}
    	if (tableSchemas) 
    	{
			logger.info("tableSchemas : " + tmpValue);
			level.setTableSchemas(tmpValue);
			tableSchemas = false;
		}
    	if (inserts) 
    	{
			logger.info("inserts : " + tmpValue);
			level.setInserts(tmpValue);
			inserts = false;
		}
    	if (selects) 
    	{
			logger.info("selects : " + tmpValue);
			level.setSelects(tmpValue);
			selects = false;
		}
    	if (updates) 
    	{
			logger.info("updates : " + tmpValue);
			level.setUpdates(tmpValue);
			updates = false;
		}
    	if (deletes) 
    	{
			logger.info("deletes : " + tmpValue);
			level.setDeletes(tmpValue);
			deletes = false;
		}
    	if (solution) 
    	{
			logger.info("solution : " + tmpValue);
			level.setSolution(tmpValue);
			solution = false;
		}
    	if (description) 
    	{
			logger.info("description : " + tmpValue);
			level.setDescription(tmpValue);
			description = false;
		}
    	if (OWASPCategory) 
    	{
			logger.info("OWASPCategory : " + tmpValue);
			level.setOWASPCategory(tmpValue);
			OWASPCategory = false;
		}
    	if (SANS25Category) 
    	{
			logger.info("SANS25Category : " + tmpValue);
			level.setSANS25Category(tmpValue);
			SANS25Category = false;
		}
    	if (clue1) 
    	{
			logger.info("clue1 : " + tmpValue);
			level.setClue1(tmpValue);
			clue1 = false;
		}
    	if (clue2) 
    	{
			logger.info("clue2 : " + tmpValue);
			level.setClue2(tmpValue);
			clue2 = false;
		}
    	if (clue3) 
    	{
			logger.info("clue3 : " + tmpValue);
			level.setClue3(tmpValue);
			clue3 = false;
		}
    	if(boilerPlate)
    	{
    		logger.info("boilerPlate : " + tmpValue);
			level.setBoilerPlate(tmpValue);
			boilerPlate = false;
    	}
    	if(filterPhrase)
    	{
    		logger.info("filterPhrase : " + tmpValue);
			level.setFilterPhrase(tmpValue);
			filterPhrase = false;
    	}
    	if(artifact)
    	{
    		logger.info("artifact : " + tmpValue);
			level.setArtifact(tmpValue);
			artifact = false;
    	}
    	if(downloadDescription)
    	{
    		logger.info("downloadDescription : " + tmpValue);
			level.setDownloadDescription(tmpValue);
			downloadDescription = false;
    	}
    	if (questions)
    	{
    		logger.info("questions : " + tmpValue);
    		level.setQuestions(tmpValue);
    		questions = false;
    	}
    	if (clientScript)
    	{
    		logger.info("clientScript : " + tmpValue);
    		level.setClientScript(tmpValue);
    		clientScript = false;
    	}
    	if (sourceCode){
    		logger.info("sourceCode : " + tmpValue);
    		level.setSourceCode(tmpValue);
    		sourceCode = false;
    	}
    	if (sourceType){
    		logger.info("sourceType : " + tmpValue);
    		level.setSourceType(tmpValue);
    		sourceType = false;
    	}
    	if (downloadURL){
    		logger.info("downloadURL : " + tmpValue);
    		level.setDownloadURL(tmpValue);
    		downloadURL = false;
    	}
    }
    public static void start(String xml, Level leveltmp) 
    {
        new SaxParser(xml,leveltmp);
    }
}