package org.lared.desinventar.util;

//	 SAX
	import org.xml.sax.XMLReader;
	import org.xml.sax.SAXException;
	import org.xml.sax.InputSource;

//	 Java
	import java.io.IOException;
	import java.io.InputStream;
	import java.io.FileInputStream;
	import java.io.File;
	import java.sql.Connection;

import javax.xml.parsers.*;

	/**
	 * Entry class for reading a CyberMuse navigation configuration from an XML file 
	 * and creating a MenuItem object.
	 */

	public class XmlReader {


	    /** show a full dump on error   */
	    private static boolean errorDump = false;

	    /** inputsource for navigation file   */
	    private InputSource filename;

	    public String sCountryCode="";
	    
	    
        public XmlImporter dataParser = new XmlImporter();

	    
	    /**
	     * creates a navigation reader
	     * @param filename the file which contains the navigation information
	     */
	    public XmlReader(String filename) throws Exception
	    {
        	this.filename = new InputSource(new FileInputStream(filename));
        	
	    }

	    public XmlReader(InputStream filename) throws Exception
	    {
        	this.filename = new InputSource(filename);
	    }

	    
	    public void setCountryCode (String scode)
	    {
	    	sCountryCode=scode;
	    }
	    
	    /**
	     * intantiates parser and starts parsing of config file
	     */
	    public void start(Connection con, int dbtype) throws Exception {
	    	
	        XMLReader parser = createParser();
	        dataParser.setConnection(con, dbtype);
	        dataParser.setCountryCode(sCountryCode);
	        parser.setContentHandler(dataParser);

	        try {
	            parser.parse(filename);
	        } 
	        catch (SAXException e) 
	        {
	            // log error here
	        	throw new Exception(e);
	        } 
	        catch (IOException e) {
	            // log error here
	            throw new Exception(e);
	        }
	    }

	    /**
	     * creates a SAX parser
	     *
	     * @return the created SAX parser
	     */
	    public static XMLReader createParser() throws Exception {
	        try {
	            SAXParserFactory spf = javax.xml.parsers.SAXParserFactory.newInstance();
	            spf.setNamespaceAware(true);
	            XMLReader xmlReader = spf.newSAXParser().getXMLReader();
	            //System.out.println("Using " + xmlReader.getClass().getName() + " as SAX2 Parser"); 
	            return xmlReader;
	        } catch (javax.xml.parsers.ParserConfigurationException e) {
	          throw new Exception(e);
	        } catch (org.xml.sax.SAXException e) {
	          throw new Exception( e);
	        }
	    }

	    /**
	     * Dumps an error
	     */
	    public void dumpError(Exception e) {
	        if (errorDump) {
	            if (e instanceof SAXException) {
	                e.printStackTrace();
	                if (((SAXException)e).getException() != null) {
	                    ((SAXException)e).getException().printStackTrace();
	                }
	            } else {
	                e.printStackTrace();
	            }
	        }
	    }

	    /**
	     * long or short error messages
	     *
	     */
	    public void setDumpError(boolean dumpError) {
	        errorDump = dumpError;
	    }


		public boolean bTableTransfer[]={
				true,true,true,true,true,true,true,true,true,true
				,true,true,true,true,true,true,true,true,true,true
				,true,true,true,true,true,true,true,true,true,true
				};
		
		public final int DATAMODEL=0;
		public final int EVENTOS=1;
		public final int CAUSAS=2;
		public final int NIVELES=3;
		public final int LEV0=4;
		public final int LEV1=5;
		public final int LEV2=6;
		public final int REGIONES=7;
		public final int EXTENSIONTABS=8;
		public final int EXTENSIONCODES=9;
		public final int DICCIONARIO=10;
		public final int FICHAS=11;
		public final int EXTENSION=12;
		public final int LEVEL_MAPS=13;
		public final int INFO_MAPS=14;
		public final int LEVEL_ATTRIBUTES=15;
		public final int ATTRIBUTE_METADATA=16;

		public final int METADATA_NATIONAL=17;
		public final int METADATA_NATIONAL_VALUES=18;
		public final int METADATA_NATIONAL_LANG=19;
		
		public final int METADATA_INDICATOR=20;
		public final int METADATA_INDICATOR_LANG=21;

		public final int METADATA_ELEMENT=22;
		public final int METADATA_ELEMENT_COSTS=23;
		public final int METADATA_ELEMENT_LANG=24;
		public final int METADATA_ELEMENT_INDICATOR=25;

		public void setOptions(String metadata, String events,String causes,String levels,String geography,String data,String definition,String extension,String maps)
		{

			// the datamodel SHOULD NEVER be transfered. This will be just info for future decisionss
			dataParser.bTableTransfer[dataParser.DATAMODEL]=false;
			
			if (!"Y".equalsIgnoreCase(metadata))
				{
				dataParser.bTableTransfer[dataParser.METADATA_NATIONAL_VALUES]=false;
				dataParser.bTableTransfer[dataParser.METADATA_NATIONAL_LANG]=false;
				dataParser.bTableTransfer[dataParser.METADATA_NATIONAL]=false;
				dataParser.bTableTransfer[dataParser.METADATA_ELEMENT_COSTS]=false;
				dataParser.bTableTransfer[dataParser.METADATA_ELEMENT_LANG]=false;
				dataParser.bTableTransfer[dataParser.METADATA_ELEMENT_INDICATOR]=false;
				dataParser.bTableTransfer[dataParser.METADATA_ELEMENT]=false;
				dataParser.bTableTransfer[dataParser.METADATA_INDICATOR_LANG]=false;
				dataParser.bTableTransfer[dataParser.METADATA_INDICATOR]=false;
				}
			
			if (!"Y".equalsIgnoreCase(events))
				dataParser.bTableTransfer[dataParser.EVENTOS]=false;
			if (!"Y".equalsIgnoreCase(causes))
				dataParser.bTableTransfer[dataParser.CAUSAS]=false;
			if (!"Y".equalsIgnoreCase(levels))
				{
				dataParser.bTableTransfer[dataParser.NIVELES]=false;
				dataParser.bTableTransfer[dataParser.LEVEL_ATTRIBUTES]=false;
				dataParser.bTableTransfer[dataParser.LEVEL_MAPS]=false;
				dataParser.bTableTransfer[dataParser.ATTRIBUTE_METADATA]=false;
				}
			if (!"Y".equalsIgnoreCase(geography))
				{
				dataParser.bTableTransfer[dataParser.LEV0]=false;
				dataParser.bTableTransfer[dataParser.LEV1]=false;
				dataParser.bTableTransfer[dataParser.LEV2]=false;
				}
			if (!"Y".equalsIgnoreCase(data))
				{
				dataParser.bTableTransfer[dataParser.FICHAS]=false;
				dataParser.bTableTransfer[dataParser.EXTENSION]=false;
				}
			if (!"Y".equalsIgnoreCase(definition))
				{
				dataParser.bTableTransfer[dataParser.DICCIONARIO]=false;
				dataParser.bTableTransfer[dataParser.EXTENSIONTABS]=false;
				dataParser.bTableTransfer[dataParser.EXTENSIONCODES]=false;
				}
			if (!"Y".equalsIgnoreCase(extension))
				dataParser.bTableTransfer[dataParser.EXTENSION]=false;
			if (!"Y".equalsIgnoreCase(maps))
				dataParser.bTableTransfer[dataParser.REGIONES]=false;
		}

		
		/**
		 * @param args
		 */
		public static void main(String[] args) {
			// UNIT TEST stub
			try{
				String database="c:/temp/bugwork/DI_exportXML.xml ";				
				File f=new File (database);
				if (f.exists() && f.isFile() && f.canRead())
				{
					XmlReader Xml = new XmlReader(database);
					
					//String sDbDriverName = "com.microsoft.jdbc.sqlserver.SQLServerDriver";
					//pooledConnection pc=new pooledConnection(sDbDriverName, "jdbc:microsoft:sqlserver://localhost:1433;DatabaseName=myanmar_ki_leader","sa","mag");				

					String sDbDriverName = "oracle.jdbc.driver.OracleDriver";
					pooledConnection pc=new pooledConnection(sDbDriverName, "jdbc:oracle:thin:@127.0.0.1:1521:XE","colombia","colombia");				
					pc.getConnection();
					Connection con=pc.connection;
					try {
						Xml.start(con,0);					
					}
					catch (Exception exml)
					{
						System.out.println("[DI] Error reported by XML importer:"+exml.toString());
					}
				}

				
			}
			catch (Exception ex)
			{
			System.out.println("Exception thrown:"+ex.toString());
			}
		}

	}


