/**
 * 
 */
package org.lared.desinventar.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.*;

import org.lared.desinventar.system.Sys;
import org.lared.desinventar.webobject.*;
import org.lared.desinventar.util.*;

/**
 * @author Julio Serje
 *
 */
public class VietnamImport 
{
	Connection con=null;
	Connection dana=null;
	public int dbType=Sys.iMsSqlDb;
	private boolean bDebug=true;

    ResultSet rset=null;
    Statement stmt=null;
    Statement ustmt=null;
	String sError="";
	int nRows=0;
	
	HashMap<String,String> hmEvents=new HashMap<String,String>();
	HashMap<String,Integer> hmTabs=new HashMap<String,Integer>();
	
	public void setConnection(Connection cn, Connection in, int type)
	{
	con=cn;
	dana=in;
	dbType=type;
	try{
		ustmt=con.createStatement();
	 }
	 catch (Exception e)
	 {
			System.out.println(e.toString());
     }
	try{
		ustmt.executeUpdate("delete from extensiontabs");
		ustmt.executeUpdate("drop table extension");
		ustmt.executeUpdate("CREATE TABLE extension (clave_ext int NOT NULL)");
		ustmt.executeUpdate("ALTER TABLE extension ADD CONSTRAINT PK_extension PRIMARY KEY (clave_ext)");   
		ustmt.executeUpdate("ALTER TABLE extension ADD CONSTRAINT FK_extension_fichas FOREIGN KEY (clave_ext) REFERENCES fichas (clave) ON UPDATE CASCADE"); 
		ustmt.executeUpdate("delete from wordsdocs");
		ustmt.executeUpdate("delete from words");
		ustmt.executeUpdate("delete from fichas");
		ustmt.executeUpdate("delete from diccionario");
		ustmt.executeUpdate("delete from regiones");
		ustmt.executeUpdate("delete from lev2");
		ustmt.executeUpdate("delete from lev1");
		ustmt.executeUpdate("delete from lev0");
		ustmt.executeUpdate("delete from eventos");
		} 
	catch (Exception e)	
		{  
		System.out.println(e.toString());		
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

    public void importEvents()
    {
 		// -----------------------------------------------------------------------------
    	// create table of events
    	eventos ev=new eventos();
    	ev.dbType=dbType;
    	try{
    		// note this goes against DANA!
    		stmt=dana.createStatement();
    		
        	rset=stmt.executeQuery("select * from disasterType");
        	while (rset.next())
        		{
        		ev.nombre=rset.getString("name");
        		ev.nombre_en=rset.getString("name_en");
        		ev.descripcion=rset.getString("code");
        		ev.serial=rset.getInt("disastertypeid");
        		nRows=ev.addWebObject(con);
        		hmEvents.put(ev.descripcion, ev.nombre);
        		}    		
    	}
    	catch (Exception e)
    	{
    		sError="Importing EVENTS"+e.toString();
    		System.out.println(sError);
    	}
    		    	
    }

    public void importGroups()
    {
 		// -----------------------------------------------------------------------------
    	// create table of events
    	extensiontabs ev=new extensiontabs();
    	ev.dbType=dbType;
    	try{
    		// note this goes against DANA!
    		stmt=dana.createStatement();
    		
        	rset=stmt.executeQuery("select * from indicatorgroup where grouporder is not null  order by grouporder");
        	int i=1;
        	while (rset.next())
        		{
        		ev.svalue=rset.getString("name_vn");
        		ev.svalue_en=rset.getString("name_en");
        		ev.ntab=rset.getInt("grouporder");
        		ev.nsort=ev.ntab;
        		nRows=ev.addWebObject(con);
        		hmTabs.put(rset.getString("code"),new Integer(ev.nsort));
        		}    		
    	}
    	catch (Exception e)
    	{
    		sError="Importing EXTENSION TABS "+e.toString();
    		System.out.println(sError);
    	}
    		    	
    }

    public void importGeography()
    {
 		// -----------------------------------------------------------------------------
 		// level 1
    	try{
    		lev0 l0=new lev0();
    		l0.dbType=dbType;
        	rset=stmt.executeQuery("select * from area");
        	while (rset.next())
        		{
        		l0.lev0_cod=rset.getString("code");
        		l0.lev0_name=rset.getString("name_vn");
        		l0.lev0_name_en=rset.getString("name_en");
        		if (null==l0.lev0_name_en || l0.lev0_name_en.length()==0)
        			l0.lev0_name_en=l0.lev0_name;
        		nRows=l0.addWebObject(con);
        		}    		
    	}
    	catch (Exception e)
    	{
    		sError="Importing LEVELS"+e.toString();
    		System.out.println(sError);
    	}
    	 
    	
    }

    public void importDict()
    {
 		// -----------------------------------------------------------------------------
 		// create diccionary, extension, tabs
    	/*
			CREATE TABLE Indicator(
				id int IDENTITY(1,1) NOT NULL,
				code nvarchar(50) NOT NULL,
				name_en nvarchar(255) NULL,
				name_vn nvarchar(255) NOT NULL,
				guid nvarchar(50) NULL,
				unit_vn nvarchar(255) NULL,
				unit_en nvarchar(255) NULL,
				parentcode nvarchar(50) NULL,
				info nvarchar(255) NULL,
				extendable bit NULL	CONSTRAINT DF_Indicator_extenable  DEFAULT (0),
    	 */
    	try{
    		diccionario dict=new diccionario(); 
    		dict.dbType=dbType;
        	rset=stmt.executeQuery("select * from Indicator, indicatorindicatorgroup where code=icode");
        	String sUnit="";
        	// TODO: generate here a hashmap of units from VN to english
        	while (rset.next())
        		{
        		dict.nombre_campo=rset.getString("code").toUpperCase();
        		dict.descripcion_campo=rset.getString("name_vn");
        		
        		sUnit=dict.not_null(rset.getString("unit_vn"));
        		dict.label_campo=dict.descripcion_campo.substring(0,Math.min(57-sUnit.length(), dict.descripcion_campo.length()));
        		if (sUnit.length()>0)
        			dict.label_campo+=" ("+sUnit+")";

        		sUnit=dict.not_null(rset.getString("unit_en"));
        		dict.label_campo_en=dict.not_null(rset.getString("name_en"));
        		dict.label_campo_en=dict.label_campo_en.substring(0,Math.min(57-sUnit.length(), dict.label_campo_en.length()));
        		if (sUnit.length()>0)
        			dict.label_campo_en+=" ("+sUnit+")";
        		
        		dict.fieldtype=extension.FLOATINGPOINT;
        		String scode=dict.not_null(rset.getString("gcode"));
    			if (hmTabs.get(scode)!=null)
    				dict.tabnumber=hmTabs.get(scode);
    			else
        			if (hmTabs.get(scode.substring(0,2))!=null)
        				dict.tabnumber=hmTabs.get(scode.substring(0,2));

        		try{
        			ustmt.executeUpdate("alter table extension add "+dict.nombre_campo+" float");
            		nRows=dict.addWebObject(con);
        			}
        		catch (Exception extenex)
        			{
        			System.out.println("Error creating extension field:"+extenex.toString());
        			}
        		}    		
    	}
    	catch (Exception e)
    	{
    		sError="Importing DICTIONARY/EXTENSION"+e.toString();
    		System.out.println(sError);
    	}
    	
    }
    

	 public void loadBasicDatacard()
	 {
		 String sLoadSql=" update F set "+ 
							 "vivafec=NH02,	"+
							 "vivdest=NH01,"+
							 "nescuelas=GD01,"+
							 "desaparece=NG02,"+
							 "heridos=NG03,"+
							 "afectados=NG05,"+
							 "nhospitales=YTb01,"+
					
							 "muertos=NG01"+
							 " FROM  Fichas F INNER JOIN Extension e ON f.clave=e.clave_ext";
		 
		 //  update F set vivafec=NH02,vivdest=NH01,nescuelas=GD01,desaparece=NG02,afectados=NG05,nhospitales=YTb01,
		 //  muertos=NG01 FROM  Fichas F INNER JOIN Extension e ON f.clave=e.clave_ext;

		try {
			ustmt.executeUpdate(sLoadSql);
		}
		catch (Exception e)
		{
			System.out.println("Error updating datacards from extension:"+e.toString());			
		}

	 }
	 

    /** Using Calendar - THE CORRECT WAY**/
    //assert: startDate must be before endDate
    public int daysBetween(Calendar startDate, Calendar endDate) 
    {
      Calendar date = (Calendar) startDate.clone();
      int daysBetween = 0;
      while (date.before(endDate)) 
      {
        date.add(Calendar.DAY_OF_MONTH, 1);
        daysBetween++;
      }
      return daysBetween;
    }
    
    public void importDisasters()
    {
 		// -----------------------------------------------------------------------------
 		// create the fichas/extension tables
    	try{
    		
        	rset=stmt.executeQuery("select disaster.*,areacode, area.name_vn as lev0name from disaster, " +
        							"(select distinct disastercode_vn, areacode from aggreationData) ag," +
        							" area where disaster.code_vn=ag.disastercode_vn and areacode=area.code " +
        							"order by disaster.code_vn, areacode");
    		fichas datacard=new fichas(); 
    		extension e=new extension();
    		datacard.dbType=dbType;
    		e.dbType=dbType;
    		e.loadExtension(con, new DICountry());
        	while (rset.next())
        		{
        		datacard.serial=rset.getString("code_vn");
        		//datacard.clave=datacard.extendedParseInt(rset.getString("code_vn"));
        		datacard.evento=rset.getString("code_en");
        		datacard.evento=hmEvents.get(datacard.evento);
        		// TODO: refine causes
        		
        		java.sql.Date disdate=rset.getDate("fromdate");
        		Calendar cal=Calendar.getInstance();
        		cal.setTime(disdate);
        		datacard.fechano=cal.get(Calendar.YEAR);
        		datacard.fechames=cal.get(Calendar.MONTH)+1;
        		datacard.fechadia=cal.get(Calendar.DATE);
        		
        		datacard.fuentes="CCFSC";
        		
        		java.sql.Date todate=rset.getDate("todate");
        		Calendar tocal=Calendar.getInstance();
        		tocal.setTime(disdate);
       		
        		datacard.duracion=daysBetween(cal, tocal); 
        		
        		datacard.descausa=datacard.not_null(rset.getString("info"))+" / "+datacard.not_null(rset.getString("summary_en"));
        		
        		datacard.level0=rset.getString("areacode");
        		datacard.name0=rset.getString("lev0name");
        		datacard.di_comments=datacard.not_null(rset.getString("name_vn"))+" / "+datacard.not_null(rset.getString("name_en"));
        		// datacard.lugar=rset.getString("");
        		datacard.approved=0;
        		
        		datacard.addWebObject(con);
        		
        		importExtension(datacard, e);
        		}    		
    	}
    	catch (Exception e)
    	{
    		sError="Importing FICHAS"+e.toString();
    		System.out.println(sError);
    	}
    	
    }
    
    public void importExtension(fichas datacard, extension e)
    {
 		// -----------------------------------------------------------------------------
 		// create the extension tables
    	try{
    		// these are required not to disturb the globally declared ones used by the calling method. close them at the end
    		Statement stmt=dana.createStatement();
    		e.init();
        	ResultSet rset=stmt.executeQuery("select * from aggreationData where disastercode_vn='"+datacard.serial+"' and areacode='"+datacard.level0+"'");
        	while (rset.next())
        		{
        		String sField=rset.getString("indicatorcode");
        		String dValue=rset.getString("totalquantity");
        		e.asFieldNames.put(sField.toUpperCase(),dValue);  		
        		}
        	rset.close();
        	stmt.close();
        	e.updateMembersFromHashTable();
        	e.clave_ext=datacard.clave;
        	e.addWebObject(con);
    	}
    	catch (Exception ex)
    	{
    		sError="Importing EXTENSION"+ex.toString();
    		System.out.println(sError);
    	}    	
    }
    
     public void doImport()
     {
    	 importGroups();
    	 importEvents();
    	 importGeography();
    	 importDict();
    	 importDisasters();
    	 loadBasicDatacard();
     }
	/**
	 * Imports the DANA database into desinventar structure.
	 * @param args
	 */
	public static void main(String[] args) 
	{
		// obtain connections to database
		//*
		String sDbDriverName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		pooledConnection pc=new pooledConnection(sDbDriverName, "jdbc:sqlserver://localhost:1433;DatabaseName=vietnam","sa","c98");				
		/*/
  	    com.inzoom.adojni.DllInit.runRoyaltyFree(643225952);
		String sDbDriverName = "com.inzoom.jdbcado.Driver";
		pooledConnection pc=new pooledConnection(sDbDriverName, "jdbc:izmado:Provider=Microsoft.Jet.OleDB.4.0;data source=c:\\bases_6\\vietnam_access\\inventVn2.mdb;", null, null);				
		//*/
		pc.getConnection();
		Connection con=pc.connection;

		sDbDriverName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		pooledConnection pcin=new pooledConnection(sDbDriverName, "jdbc:sqlserver://localhost:1433;DatabaseName=DANA","sa","c0l0mbia98");				
		pcin.getConnection();
		Connection dana=pcin.connection;

		VietnamImport vin=new VietnamImport();
		vin.setConnection(con, dana, Sys.iMsSqlDb);
		
		vin.doImport();
		
		try{ 
			con.close();
			dana.close();
		}
		catch(Exception e)
		{
		}
		
		

	}

}
