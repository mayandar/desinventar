package org.lared.desinventar.map;
//SAX
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.Attributes;
import org.xml.sax.Locator;

import java.sql.*;
import java.util.ArrayList;

import org.lared.desinventar.system.Sys;
import org.lared.desinventar.webobject.*;

public class WMSImporter extends DefaultHandler 
{

	String sSection="Layer";
	String sCurrentLayer="";
	String sCurrentField="";
	boolean bDebug=true;
	
	boolean inLayer=false;
	int nLay=0;
	
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

	
	public void setDebug(boolean bdeb)
	{
		bDebug=bdeb;
	}
		// debug logger
	    public void log(String msg)
	    {
			if (bDebug) 
				System.out.println(msg);
	    }


		public void startDocument() 
		{
		}

		
	    public void startElement(String uri, String localName, String qName, Attributes attributes) 
	    {
	    	    System.out.println(localName);
	    	    // a querable layer is of the form  <Layer queryable="1">
		    	if (localName.equalsIgnoreCase(sSection) && attributes.getValue("queryable") !=null)
		    	{
		    		// ready to start a layer
		    		inLayer=true;
	    			vLayerNames.add(nLay,"layername #"+nLay);
	    			vLayers.add(nLay,"layer #"+nLay);        		
		    		
		    		log("start processing LAYER SECTION ");		
		    	}
		    	if (localName.equalsIgnoreCase("Style"))
	    		{
		    		inLayer=false;
		    	}

	    		sCurrentField=localName;
	    }

	    
	    
	    public void endElement(String uri, String localName, String qName) 
	    {
		   	if (localName.equalsIgnoreCase(sSection))
		    	{
		    		inLayer=false;
		    		nLay++;
		    		log("FINISHED processing LAYER SECTION ");		
		    	}
	    	
	    }    	     

	    String sLastField="";
        String sLastValue="";	    
        /**
         * void characters(char[] ch,
                int start,
                int length)
                throws SAXExceptionReceive notification of character data. 
                
                The Parser will call this method to report *each chunk* of character data. 
                SAX parsers *may* return all contiguous character data in a single chunk, or they may split it into several chunks; 
                however, all of the characters in any single event must come from the same external entity so that the Locator provides useful information.
         */
        public void characters(char[] ch, int start, int length) 
	    {
        	if (inLayer)
        	{
	    		String sValue=new String(ch, start, length);
	    		//log("VALUE OF FIELD "+sCurrentField+" in Record:"+nCurrentRecord+ "  ["+sValue+"]");
	    		if (sLastField.equals(sCurrentField))
	    		{
	    			// this is the next of a set of split chunks!!!
	    			sLastValue+=sValue;
	    		}
	    		else
	    		{
	    			sLastValue=sValue;
	    			sLastField=sCurrentField;
	    		}

	    		if (sCurrentField.equalsIgnoreCase("Name"))
	    			vLayerNames.set(nLay,sLastValue.replace("\n", ""));
	    		else
		    		if (sCurrentField.equalsIgnoreCase("Title"))
		    			vLayers.set(nLay,sLastValue.replace("\n", ""));        		
        	}
	    			
	    	
	    }

	    

}






