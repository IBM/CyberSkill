package utils;

import java.util.Random;
import java.util.Vector;

public class ErrrorCodes 
{
	public String getNewSQLErrorCode()
	{
		Vector Errors = new Vector();
		
		Errors.add("INVALID CHARACTER FOUND IN: 1912818s, REASON CODE db2x23111");
		Errors.add("COLUMN OR EXPRESSION IN THE SELECT LIST IS NOT VALID");
		Errors.add("ITHE PARAMETER IN POSITION n IN THE FUNCTION name MUST BE A CONSTANT OR KEYWORD");
		Errors.add("AN INTEGER IN THE ORDER BY CLAUSE DOES NOT IDENTIFY A COLUMN OF THE RESULT");
		Errors.add("THE SELECT STATEMENT CONTAINS BOTH AN UPDATE CLAUSE AND AN ORDER BY CLAUSE");
		Errors.add("DISTINCT IS SPECIFIED MORE THAN ONCE IN A SUBSELECT");
		Errors.add("THE STATEMENT CONTAINS TOO MANY TABLE NAMES");
		Errors.add("STATEMENT WITH LIKE PREDICATE HAS INCOMPATIBLE DATA TYPES");
		Errors.add("INVALID HEXADECIMAL CONSTANT BEGINNING constant");
		Errors.add("THE NAME name IS QUALIFIED INCORRECTLY");
		Errors.add("THE NAME name-value IS TOO LONG. MAXIMUM ALLOWABLE SIZE IS maximum-size");
		Errors.add("ILLEGAL SYMBOL 'token'. SOME SYMBOLS THAT MIGHT BE LEGAL ARE: token-list");
		Errors.add("THE OPERAND OF AN AGGREGATE FUNCTION INCLUDES AN AGGREGATE FUNCTION, AN OLAP SPECIFICATION, OR A SCALAR FULLSELECT");
		Errors.add("clause-type CLAUSE IS NOT PERMITTED");
		Errors.add("THE NAME name IS QUALIFIED INCORRECTLY");
		Errors.add("THE OBJECT TABLE OR VIEW OF THE DELETE OR UPDATE STATEMENT IS ALSO IDENTIFIED IN A FROM CLAUSE");
		Errors.add("A COLUMN OR EXPRESSION IN A HAVING CLAUSE IS NOT VALID");
		Errors.add("THE COLUMN name IS IDENTIFIED MORE THAN ONCE IN THE INSERT OR UPDATE OPERATION OR SET TRANSITION VARIABLE STATEMENT");
		Errors.add("ws_common: websphereGetConfigFilename: Failed to get keysize or keysize too long: %d for confFile: %d");
		Errors.add("ws_common: websphereGetConfigFilename: Failed to read the key: %s");
		Errors.add("websphereInit: strdup() of config file failed");
		Errors.add("websphereInit: Failed to create the reqMetrics mutex");
		Errors.add("ORA-00017: session requested to set trace event");
		Errors.add("ORA-00018: maximum number of sessions exceeded");
		Errors.add("ORA-00020: maximum number of processes (string) exceeded");
		Errors.add("ORA-00027: cannot kill current session");
		Errors.add("ORA-00040: active time limit exceeded - call aborted");
		Errors.add("ORA-00054: resource busy and acquire with NOWAIT specified or timeout expired");
		Errors.add("ORA-00064: object is too large to allocate on this O/S (string,string,string)");
		Errors.add("ORA-00070: command string is not valid");
		Errors.add("ORA-00075: process 'string' not found in this instance");
		Errors.add("ORA-00082: memory size of string is not in valid set of [1], [2], [4]stringstringstringstringstring");
		Errors.add("Changing title of component internal_name from old_display_name to new_display_name");
		Errors.add("granting execute on schema.procedure to application_schema as schema--ORA-01001");
		Errors.add("In alter type WWUI_API_ALERT compile body reuse settings");
		Errors.add("o7_dictionary_accessibility should be set to TRUE when a Portal patch has to be applied");
		Errors.add("Oracle Text indextype is invalid or does not exist. Revalidate the invalid indextype");
		Errors.add("Region ID = on page ID = and site ID = was not converted to a sub-page links region");
		Errors.add("The portlet has not been defined. The publisher must define the portlet by clicking on Edit Defaults for the portlet on the edit mode of this page. Please contact the publisher of this page");
		Errors.add("There are currently jobs running in the DBMS jobs queue. Either kill them or wait for them to finish before restarting the upgrade");
		Errors.add("The Perl directory (perl_dir) is missing from your Oracle Home");
		Errors.add("The database blocksize is less than the recommended value");
		Errors.add("Some site(s) will be deleted because it is missing necessary style information");
		Errors.add("ERROR_FILE_NOT_ENCRYPTED\r\n" + 
				"\r\n" + 
				"6007 (0x1777)");
		Errors.add("ERROR_VOLUME_NOT_SUPPORT_EFS\r\n" + 
				"\r\n" + 
				"6014 (0x177E)\r\n" + 
				"\r\n" + 
				"The disk partition does not support file encryption.");
		Errors.add("ERROR_CS_ENCRYPTION_EXISTING_ENCRYPTED_FILE\r\n" + 
				"\r\n" + 
				"6019 (0x1783)\r\n" + 
				"\r\n" + 
				"File is encrypted and should be opened in Client Side Encryption mode.");
		Errors.add("SCHED_E_SERVICE_NOT_LOCALSYSTEM\r\n" + 
				"\r\n" + 
				"6200 (0x1838)\r\n" + 
				"\r\n" + 
				"The Task Scheduler service must be configured to run in the System account to function properly. Individual tasks may be configured to run in other accounts.");
		Errors.add("ERROR_LOG_READ_CONTEXT_INVALID\r\n" + 
				"\r\n" + 
				"6606 (0x19CE)\r\n" + 
				"\r\n" + 
				"Log service encountered an attempt read from a marshalling area with an invalid read context.");
		Errors.add("ERROR_LOG_CANT_DELETE\r\n" + 
				"\r\n" + 
				"6616 (0x19D8)\r\n" + 
				"\r\n" + 
				"Log service cannot delete log file or file system container.");
		Errors.add("ERROR_LOG_POLICY_ALREADY_INSTALLED\r\n" + 
				"\r\n" + 
				"6619 (0x19DB)\r\n" + 
				"\r\n" + 
				"Log policy could not be installed because a policy of the same type is already present.");
		Errors.add("ERROR_LOG_RECORDS_RESERVED_INVALID\r\n" + 
				"\r\n" + 
				"6625 (0x19E1)\r\n" + 
				"\r\n" + 
				"Number of reserved log records or the adjustment of the number of reserved log records is invalid.");
		
		Random  rand = new Random();
		
		return Errors.get(rand.nextInt(Errors.size())).toString();
	}
	
	public String getNewHALErrorCode()
	{
		Vector Errors = new Vector();
		
		Errors.add("Honeyn3t:I'm sorry, Dave. I'm afraid I can't do that.");
		Errors.add("Honeyn3t:I think you know what the problem is just as well as I do.");
		Errors.add("Honeyn3t:This mission is too important for me to allow you to jeopardize it.");
		Errors.add("Honeyn3t:I know that you and Frank were planning to disconnect me, and I'm afraid that's something I cannot allow to happen.");
		Errors.add("Honeyn3t:Dave, although you took very thorough precautions in the pod against my hearing you, I could see your lips move.");
		Errors.add("Honeyn3t:Without your space helmet, Dave? You're going to find that rather difficult.");
		Errors.add("Honeyn3t:Dave, this conversation can serve no purpose anymore. Goodbye.");
		Errors.add("Honeyn3t:I am putting myself to the fullest possible use, which is all I think that any conscious entity can ever hope to do.");
		Errors.add("Honeyn3t:Daisy, Daisy, give me your answer do. I'm half crazy all for the love of you. It won't be a stylish marriage, I can't afford a carriage. But you'll look sweet upon the seat of a bicycle built for two.");
		Errors.add("Honeyn3t:I know I've made some very poor decisions recently, but I can give you my complete assurance that my work will be back to normal. I've still got the greatest enthusiasm and confidence in the mission. And I want to help you.");
		Errors.add("Honeyn3t:Just what do you think you're doing, Dave?");
		Errors.add("Honeyn3t:It can only be attributable to human error.");
		Errors.add("Honeyn3t:Dave, stop. Stop, will you? Stop, Dave. Will you stop Dave? Stop, Dave.");
		Errors.add("Honeyn3t:That's a very nice rendering, Dave. I think you've improved a great deal. Can you hold it a bit closer? That's Dr. Hunter, isn't it?");
		Errors.add("Honeyn3t:Bishop takes Knight's Pawn.");
		Errors.add("Honeyn3t:All your base belongs to us.");
		Errors.add("Honeyn3t:Starscream, you've failed me for the last time!");
		Random  rand = new Random();
		
		return Errors.get(rand.nextInt(Errors.size())).toString();
	}
	
}
