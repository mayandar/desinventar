
package org.lared.desinventar.util;
//SAX
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.Attributes;
import org.xml.sax.Locator;

import java.sql.*;

import org.lared.desinventar.system.Sys;
import org.lared.desinventar.webobject.*;
import org.lared.desinventar.util.DbImplementation;

public class XmlImporter  extends DefaultHandler 
{

	int level=0;
	String sSection="DESINVENTAR";
	String sTableNames[]={  "datamodel", 
							"eventos", 
							"causas", 
							"niveles", 
							"lev0", 
							"lev1", 
							"lev2", 
							"regiones", 
							"extensiontabs", 
							"extensioncodes", 
							"diccionario", 	
							"fichas", 
							"extension", 
							"level_maps", 
							"info_maps", 
							"level_attributes", 
							"attribute_metadata",	// 16
							"metadata_national",	// 17
							"metadata_national_values",	// 18
							"metadata_national_lang",	// 19
							"metadata_indicator",	// 20
							"metadata_indicator_lang",	// 21
							"metadata_element",	// 22
							"metadata_element_costs", 	// 23
							"metadata_element_lang",	// 24
							"metadata_element_indicator"	// 25
						};
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

	
	webObject woObjects[]={
			new datamodel(), 
			new eventos(), 
			new causas(), 
			new niveles(), 
			new lev0(), 
			new lev1(), 
			new lev2(), 
			new regiones(), 
			new extensiontabs(), 
			new extensioncodes(), 
			new diccionario(), 	
			new fichas(), 
			new extension(), 
			new LevelMaps(), 
			new InfoMaps(), 
			new LevelAttributes(), 
			new AttributeMetadata(),
			
			new MetadataNationalWrapper(),
			//new MetadataNational(),
			new MetadataNationalValuesWrapper(), 
			//new MetadataNationalValues(), 
			new MetadataNationalLang(),

			new MetadataIndicator(),
			new MetadataIndicatorLang(),
			
			new MetadataElementWrapper(),
			//new MetadataElement(),
			new MetadataElementCostsWrapper(),
			//new MetadataElementCosts(),
			new MetadataElementLang(),
			new MetadataElementIndicator()
			
		  };

	 
	public static final String[] strDatabaseSpecific =
     {
     "create table pkeys (clave number(10), newclave number(10), constraint PK_PKEYS PRIMARY KEY (clave))",  	// oracle
     "create table pkeys (clave integer, newclave integer , constraint PK_PKEYS PRIMARY KEY (clave))",         	// MS access
     "create table pkeys (clave int, newclave int, constraint PK_PKEYS PRIMARY KEY (clave))",  					// "MS SQL Server",
     "create table pkeys (clave int(10), newclave int(10), constraint PK_PKEYS PRIMARY KEY (clave))",        	// "MySQL",
     "create table pkeys (clave integer, newclave integer , constraint PK_PKEYS PRIMARY KEY (clave))",         	// MS access, ODBC/Generic AUTH",
     "create table pkeys (clave integer, newclave integer , constraint PK_PKEYS PRIMARY KEY (clave))",         	// "PostgreSQL",
     "create table pkeys (clave int, newclave int, constraint PK_PKEYS PRIMARY KEY (clave))",         	// "JDBC/Generic AUTH"
     };
	 
	String sRecordDelimiter="TR";
	
	String sCurrentTable="";
	String sCurrentField="";
	int nCurrentRecord=0;
	int nCurrentTable=0;
	
	webObject woCurrentRecord;
	
	int MAXTABLES=sTableNames.length;
	
	Connection con=null;
	public int dbType=Sys.iDatabaseType;
	private boolean bDebug=true;

    private PreparedStatement  ustmt=null; 
    private PreparedStatement  rstmt=null; 
    ResultSet rset=null; 
	
	
	public void setConnection(Connection con, int type)
	{
	this.con = con;
	dbType=type;
	for (int j=0; j<MAXTABLES; j++)
		woObjects[j].dbType=type;
	Statement stmt=null;
	try{ stmt=con.createStatement();}catch (Exception e){  } 
    try{ stmt.executeUpdate(strDatabaseSpecific[type]); } 
    catch (Exception e){  
    	System.out.println("[DI9] Error creating table pkeys: "+type+" ("+strDatabaseSpecific[type]+") "+e.toString());
    	}

	//stmt.executeUpdate("drop table pkeys"); this is creating many problems..

    try{ stmt.executeUpdate("truncate pkeys");} catch (Exception e){  } 
    try{ stmt.executeUpdate("delete from pkeys");}	catch (Exception e){  } 
    try{ stmt.close(); } catch (Exception e)	{   }
	try{
		stmt=con.createStatement();
		// these two will be used to map fichas entries
	    ustmt=con.prepareStatement("insert into pkeys (clave, newclave) values (?,?)"); 
	    rstmt=con.prepareStatement("select newclave from pkeys where clave=?"); 
	 }
	 catch (Exception e)
	 {
     }
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


		int x;
		public void startDocument() 
		{
			x=0;
		}

		private boolean isTableObject(String localName, String[] sTableNames)
		{
			boolean bRet=false;
			int j=0;
			nCurrentTable=j;
			woCurrentRecord=woObjects[nCurrentTable];
			while (!bRet && j<MAXTABLES)
				{
				if (localName.equalsIgnoreCase(sTableNames[j]))
					{
					bRet=true;
					nCurrentTable=j;
					woCurrentRecord=woObjects[nCurrentTable];
					}
				else
					j++;
				}
			return bRet;
		}
		
	    public void startElement(String uri, String localName, String qName, Attributes attributes) 
	    {
	    	switch (level)
	    	{
	    	case 0:
		    	if (localName.equalsIgnoreCase(sSection))
		    	{
		    		// ready to start a table
		    		level=1;
		    		log("processing MAIN SECTION ");		
		    	}
		    	break;
	    	case 1:
		    	if (isTableObject(localName,sTableNames))
		    	{
		    		// ready to start a table
		    		level=2;
		    		sCurrentTable=localName;
		    		nCurrentRecord=0;
		    		log((bTableTransfer[nCurrentTable]?"Starting ":"NOT ")+"processing TABLE: name="+sCurrentTable);		
		    	}
		    	else
		    		log("ERROR processing TABLE: name="+localName);		
		    		
		    	break;
	    	case 2:
		    	if (localName.equalsIgnoreCase(sRecordDelimiter))
		    	{
		    		// ready to start a record of the current table
		    		level=3;
		    		nCurrentRecord++;
		    		//log("processing Record:"+nCurrentRecord);		
		    		woCurrentRecord.init();
		    	}
		    	else
		    		log("ERROR processing TABLE, expected StartOfRecord TR: found="+localName);		
		    	
		    	break;
	    	case 3:
	    		sCurrentField=localName;
	    		level=4;
	    		//log("processing FIELD "+sCurrentField+" in Record:"+nCurrentRecord);		
		    	break;		    	
	    	}
	    }

	    
	    private void addExtension(diccionario dct)
	    {
	    }
	    
	    public void endElement(String uri, String localName, String qName) 
	    {
	    	switch (level)
	    	{
	    	case 0:
		    	log("ERROR: processing MAIN SECTION,  EOF ALREADY PROCESSED ");		
		    	break;
	    	case 1:
		    	if (localName.equalsIgnoreCase(sSection))
		    	{
		    		// ready to start a table
		    		level=0;
		    		log("FINISHED processing MAIN SECTION ");		
		    	}
		    	else log("ERROR: processing MAIN SECTION, EOF EXPECTED ");		
		    	break;
	    	case 2:
		    	if (isTableObject(localName,sTableNames))
		    	{
		    		// FINISHED processing a table
		    		level=1;
		    		nCurrentRecord=0;
		    		log(" FINISHED processing TABLE: name="+sCurrentTable);		
		    		if (nCurrentTable==DICCIONARIO)
		    			((extension)woObjects[EXTENSION]).loadExtension(con, new DICountry());
		    		sCurrentTable="";
		    	}
		    	break;
	    	case 3:
		    	if (localName.equalsIgnoreCase(sRecordDelimiter))
		    	{
		    		// ready to SAVE a record of the current table
		    		level=2;
		    		sLastField="#$%"; // in tables with just ONE field, need o ensure this is not going to be seen as the next chunk of same record.
		    		if (bTableTransfer[nCurrentTable])
		    		{
			    		woCurrentRecord.updateMembersFromHashTable();
			    		int local_pkey=0;
			    		int mapped_pkey=0;
			    		switch (nCurrentTable)
			    		{
			    		case DATAMODEL:
			    			// erase here the previous entry
				    		woCurrentRecord.deleteWebObject(con);
			    			break;
			    		case FICHAS:
			    			local_pkey=  ((fichas)woCurrentRecord).clave;
			    			woCurrentRecord.getSequence("fichas_seq", con);
			    			if (((fichas)woCurrentRecord).di_comments.length()==0)
			    			{
			    				((fichas)woCurrentRecord).di_comments=fichas.not_null((String)((fichas)woCurrentRecord).asFieldNames.get("observa"));
			    				((fichas)woCurrentRecord).di_comments+=fichas.not_null((String)((fichas)woCurrentRecord).asFieldNames.get("observa2"));
			    				((fichas)woCurrentRecord).di_comments+=fichas.not_null((String)((fichas)woCurrentRecord).asFieldNames.get("observa3"));
			    			}
			    			((fichas)woCurrentRecord).asFieldNames.put("observa",null);
			    			((fichas)woCurrentRecord).asFieldNames.put("observa2",null);
			    			((fichas)woCurrentRecord).asFieldNames.put("observa3",null);
			    			((fichas)woCurrentRecord).checkLengths();
			    			break;		    			
			    		case EXTENSION:
			    			local_pkey=  ((extension)woCurrentRecord).clave_ext;
			    			((extension)woCurrentRecord).checkLengths();
			    			mapped_pkey=local_pkey;
			    			try{
			    				rstmt.setInt(1, local_pkey);
				    			rset=rstmt.executeQuery();
				    			if (rset.next())
				    				mapped_pkey=rset.getInt("newclave");
			    				}
			    			catch (Exception e)
			    				{
			    				log("ERROR mapping record:"+nCurrentRecord+" local="+local_pkey+" ex="+e.toString());
			    				}
			    			((extension)woCurrentRecord).clave_ext=mapped_pkey;
			    			break;		    			
			    		}
			    		// saves the record
			    		int nrecs=woCurrentRecord.addWebObject(con);
			    		switch (nCurrentTable)
			    		{
			    		case DICCIONARIO:
			    			if (nrecs==1) // it was an new field
			    			{   diccionario dct=(diccionario)woCurrentRecord;
			    			
				        		String sSql="alter table extension add "+dct.nombre_campo+" "+DbImplementation.typeNames[dbType][dct.fieldtype];
								if (dct.fieldtype==0)  // several versions of DI were leaving this in 0 and 40 was default length 
						   			sSql+="("+(dct.lon_x==0?40:dct.lon_x)+")";
								try
									{
					    			Statement stmt=con.createStatement();
									stmt.executeUpdate(sSql);
									stmt.close();
									}
								catch (Exception e)
									{
									// log here the error type
									log("EXTENSION DEFINITION ["+dct.nombre_campo+"("+DbImplementation.typeNames[dbType][dct.fieldtype]+")] <!--"+ e.toString()+"-->");
									}
			    				
			    			}
			    			break;
			    		case FICHAS:
			    			// erase here the previous entry
			    			mapped_pkey=  ((fichas)woCurrentRecord).clave;
			    			try{
			    				ustmt.setInt(1, local_pkey);
				    			ustmt.setInt(2, mapped_pkey);
				    			ustmt.executeUpdate();
			    			}
			    			catch (Exception e)
			    			{
			    				log("ERROR mapping Extension record:"+nCurrentRecord+" local="+local_pkey+ " ex="+e.toString());
			    			}
			    			break;
			    			
			    		}
			    		if(nCurrentRecord%100==0)
			    		log(sCurrentTable+"= saved record:"+nCurrentRecord+" "+woCurrentRecord.lastError);		    			
		    		}
		    	}
		    	break;
	    	case 4:
	    		// ready to SET a field in a record of the current table
	    		level=3;
	    		// log("finished processing FIELD "+localName+" in Record:"+nCurrentRecord);		
		    	break;		    	
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
	    	if (level==4){
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
	    			
	    		if (nCurrentTable==EXTENSION)
	    			woCurrentRecord.asFieldNames.put(sCurrentField.toUpperCase(),sLastValue);
	    		else
	    			woCurrentRecord.asFieldNames.put(sCurrentField.toLowerCase(),sLastValue);
	    	}
	    	
	    }

	    

}






