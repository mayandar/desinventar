package org.lared.desinventar.map;

//	 SAX
	import org.xml.sax.XMLReader;
	import org.xml.sax.SAXException;
	import org.xml.sax.InputSource;

//	 Java
	import java.io.IOException;
	import java.io.FileInputStream;
	import java.io.File;
	import java.sql.Connection;
import java.util.ArrayList;

import javax.xml.parsers.*;

	/**
	 * Entry class for reading a CyberMuse navigation configuration from an XML file 
	 * and creating a MenuItem object.
	 */

	public class WMSGetCapabilitiesReader{


	    /** show a full dump on error   */
	    private static boolean errorDump = false;

	    /** inputsource for navigation file   */
	    private InputSource filename;

        public WMSImporter dataParser = new WMSImporter();

	    
        public ArrayList<String> vLayers=new ArrayList<String>();
        public ArrayList<String> vLayerNames=new ArrayList<String>();
        
        
        public void setLayerArrayList(ArrayList extLayers)
        {
        	vLayers=extLayers;
        }
        public void setLayerNamesArrayList(ArrayList extLayers)
        {
        	vLayerNames=extLayers;
        }
        
        
        public ArrayList getLayerArrayList()
        {
        	return vLayers;
        }
        
        public ArrayList getLayerNamesArrayList()
        {
        	return vLayerNames;
        }
        
        
	    /**
	     * creates a navigation reader
	     * @param filename the file which contains the navigation information
	     */
	    public WMSGetCapabilitiesReader(String filename) throws Exception
	    {
        	this.filename = new InputSource(new FileInputStream(filename));
        	
	    }

	    /**
	     * intantiates parser and starts parsing of config file
	     */
	    public void start() throws Exception {
	    	
	    	XMLReader parser = createParser();
	        parser.setContentHandler(dataParser);

	        dataParser.setLayerArrayList(vLayers);
	        dataParser.setLayerNamesArrayList(vLayerNames);

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


		
		/**
		 * @param args
		 */
		public static void main(String[] args) {
			// UNIT TEST stub
			try{
				String database="c:/temp/bugwork/ows.xml ";				
				File f=new File (database);
				if (f.exists() && f.isFile() && f.canRead())
				{
					WMSGetCapabilitiesReader WmsCaps = new WMSGetCapabilitiesReader(database);

					try {
						WmsCaps.start();					
					}
					catch (Exception exml)
					{
						System.out.println("[DI9] Error reported by WMS_XML importer:"+exml.toString());
					}
				for (int j=0; j<WmsCaps.vLayers.size(); j++)
					{
					System.out.println("Layer #"+j+"  name="+WmsCaps.vLayerNames.get(j)+"  value="+WmsCaps.vLayers.get(j));
					}
				}

				
			}
			catch (Exception ex)
			{
			System.out.println("[DI9] Exception thrown:"+ex.toString());
			}
		}

	}


