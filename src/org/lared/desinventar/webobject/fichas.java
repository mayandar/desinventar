package org.lared.desinventar.webobject;

import java.io.*;
import java.util.*;
import java.sql.*;
import java.math.*;
import java.text.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;
import org.lared.desinventar.tag.*;

// Author: Julio Serje, 1999

public class fichas
    extends fichas_base
{
  private String token;
  private Hashtable hWords;
  private int state;
  public int datacard_model_revision=0;
  
  // 0-> DesInventar 5,6
  // 1-> DesInventar 6.3
  // 2-> DesInventar Server 9.2.11
  

  public void initIndexer()
  {
    token = "";
    hWords = new Hashtable();
    state = 0;
  }

  // the number of occurrences per word
  private void addToIndex(String token)
  { // only words, no numbers...
    if (Character.isLetter(token.charAt(0)))
    	{
    	Integer iOccurrences = (Integer) hWords.get(token);
        if (iOccurrences == null)
            iOccurrences = new Integer(1);
          else
            iOccurrences = new Integer(iOccurrences.intValue() + 1);
          hWords.put(token, iOccurrences);
    	}
  }

  public Hashtable parseString(String sAllStrings)
  {
    // single quote not in NOT delimiters.
  	StringTokenizer stTokSource = new StringTokenizer(sAllStrings," '-.;<>:/\\!][{}()*&^%$#@!,\"|+=?~`ø°≤≥§ÄºΩæëí¥¨¶");
    while (stTokSource.hasMoreTokens())
    {
      String sTok = stTokSource.nextToken();
      if (sTok.length()>1)
          addToIndex(sTok);
    }
    return hWords;
  }

  
  public boolean deindexThis(Connection con)
  {
    boolean retCode = true;

    try
    {
        stmt = con.createStatement();    	
	    try
	    {
	      sSql = "delete from wordsdocs where docId=" + this.clave;
	      stmt.executeUpdate(sSql);
	    }
	    catch (Exception e2)
	    {
	      System.out.println(e2.toString() + " : " + sSql);
	      retCode = false;
	    }
		stmt.close();
    }
    catch (Exception e2)
    {
    	
    }  	
  	return retCode;
  }
  
  public boolean indexThis(Connection con)
  {
    String sSql = "";
    int nRows = 0;
    int nWordId = 0;
    boolean retCode = true;

    try
    {
      hWords = new Hashtable();
      state = 0;
      String sAllStrings = getFullTextString();
      parseString(sAllStrings);
      PreparedStatement wstmt = con.prepareStatement("select wordid from words  where word=?");
      PreparedStatement iwstmt = con.prepareStatement("insert into words (wordid,word,Occurrences) values(?,?,0)");
      PreparedStatement iwdstmt = con.prepareStatement("insert into wordsdocs (docid,wordid,Occurrences) values(?,?,?)");
      for (Enumeration e = hWords.keys(); e.hasMoreElements(); )
      {
        try
        {
          token = (String) e.nextElement();
          if (token.length()>30)
          	token=token.substring(0,30);
          Integer iOccurrences = (Integer) hWords.get(token);
          // just to allow postgres, a very simple and less efficient approach:
          wstmt.setString(1,token);
          rset = wstmt.executeQuery();
          if (rset.next()) // is an existing new word!!
          {
            nWordId=rset.getInt("wordid");
            rset.close();
          }
          else
          {
            nWordId = getSequence("words_seq", con);
            iwstmt.setInt(1,nWordId);
            iwstmt.setString(2,token);
            nRows = iwstmt.executeUpdate();
          }
          iwdstmt.setInt(1,clave);
          iwdstmt.setInt(2,nWordId);
          iwdstmt.setInt(3,iOccurrences.intValue());
          iwdstmt.executeUpdate();
        }
        catch (Exception e4)
        {
          //System.out.println(e4.toString() + " : " + sSql);
          retCode = false;
        }
        finally
        {
        	try{wstmt.close();} catch (Exception ex){}
        	try{iwstmt.close();} catch (Exception ex){}
        	try{iwdstmt.close();} catch (Exception ex){}
        }
      }

    }
    catch (Exception e5)
    {
      System.out.println(e5.toString() + " : " + sSql);
      retCode = false;
    }
    return retCode;
  }


  // there is a copy of this in dbUtils.java !!!
  public void checkObserva()
  {
	  
  	if (muertos!=0) hay_muertos=-1;
  	if (desaparece!=0) hay_deasparece=-1;
  	if (heridos!=0) hay_heridos=-1;
  	if (damnificados!=0) hay_damnificados=-1;
  	if (afectados!=0) hay_afectados=-1;
  	if (vivdest!=0) hay_vivdest=-1;
  	if (vivafec!=0) hay_vivafec=-1;
  	if (evacuados!=0) hay_evacuados=-1;
  	if (reubicados!=0) hay_reubicados=-1;

  	// the following are now exclusively checked client side.  IN SENDAI MODE THESE BECAME NUMBER OF INTERRUPTIONS
  	//if (nhectareas!=0) agropecuario=-1;
  	//if (cabezas!=0) agropecuario=-1;
  	//if (nescuelas!=0) educacion=-1;
  	//if (nhospitales!=0) salud=-1;
   	//if (kmvias!=0) transporte=-1;
	  

   	updateHashTable();

  }
  
  

  
  //--------------------------------------------------------------------------------
  // retrieves object info from HTML form fields, splits the Observa fields
  //--------------------------------------------------------------------------------
 
  public int getForm(HttpServletRequest req,
                     HttpServletResponse resp,
                     Connection con)
  {
	  int nRet=super.getForm(req, resp, con);
	    
      return nRet;	  
  }
  
//--------------------------------------------------------------------------------
//method to convert accented character into unaccented chars.
//--------------------------------------------------------------------------------
 public static String removeAccents(String strParameter)
 {
   int j, pos;
   String sReturn = "";
   String sAccents =   "¡…Õ”⁄¿»Ã“Ÿ¬ Œ‘€√’ƒÀœ÷‹";
   String replaceWith ="AEIOUAEIOUAEIOUAOAEIOU";
       
   if (strParameter == null)
     return "";
   else
   {
     sReturn = strParameter;
     boolean bWithAccents=false;
     for (j = 0; j < sReturn.length(); j++)
     	if (sReturn.charAt(j)>'z') bWithAccents=true;
     
     if (bWithAccents)
     	for (j = 0; j < sReturn.length(); j++)
     	{
   			if ( (pos = sAccents.indexOf(sReturn.charAt(j))) >= 0)
   				sReturn=sReturn.replace(sAccents.charAt(pos),replaceWith.charAt(pos));
     	}
     return sReturn;
   }
 }


  
  public String getFullTextString()
  {
    // relevant text fields in datacard
  	String sAllStrings =  serial;
    sAllStrings += " " +  level0;
    sAllStrings += " " +  level1;
    sAllStrings += " " +  level2;
    sAllStrings += " " +  name0;
    sAllStrings += " " +  name1;
    sAllStrings += " " +  name2;
    sAllStrings += " " +  evento;
    sAllStrings += " " +  lugar;
    sAllStrings += " " +  fechano;
    sAllStrings += " " +  fechano;
    sAllStrings += "-" +  fechames;
    sAllStrings += "-" +  fechadia;
    sAllStrings += " " +  otros;
    sAllStrings += " " +  di_comments;
    sAllStrings += " " +  fuentes;
    sAllStrings += " " +  fechapor;
    sAllStrings += " " +  fechafec;
    sAllStrings += " " +  causa;
    sAllStrings += " " +  descausa;
    sAllStrings += " " +  magnitud2;
    sAllStrings += " " +  glide;

    return removeAccents(sAllStrings.toUpperCase());
  }

  //------------------------------------------------------------------------------------
  // adds a new object to the database
  // note that this method has been customized to handle the autonumber
  // feature of Access/MS SQL/Postgres, and needs to safely read the
  // new key that has been generated.  Oracle implements the autonumber with a trigger 
  //------------------------------------------------------------------------------------
  public int addWebObject(Connection con)
  {

    checkObserva();  
  	int nRet=super.addWebObject(con);
    // now index this new datacard
    if (nRet>0)
    	indexThis(con);
  	return nRet;      
  }

  public int updateWebObject(Connection con)
  {
	checkObserva();  
	int nRet=super.updateWebObject(con);
    // removes old version from the index...
    deindexThis(con);
    // now index this version!!
    indexThis(con);
  	return nRet;
  }
  
  public int deleteWebObject(Connection con)
  {
   // removes old version from the index...
    deindexThis(con);

    try
    {
        stmt = con.createStatement();    	
	    try
	    {
	        sSql = "delete from media_file where iclave=" + this.clave;
	        stmt.executeUpdate(sSql);
	    }
	    catch (Exception e2)
	    {
	      System.out.println("[DI9]: removing media "+e2.toString() + " : " + sSql);
	    }
		stmt.close();
    }
    catch (Exception e2)
    {
    	
    }  	


    int nRet=super.deleteWebObject(con);
  	return nRet;
  }

  public int getWebObject(Connection con)
  {
  	int nRet=super.getWebObject(con);
  	return nRet;
  }

  public void loadWebObject(ResultSet rset)
  {
  	super.loadWebObject(rset);
  }

  public void addExtensionHashMap(extension ext)
  {
	    asFieldNames.put("clave_ext", String.valueOf(ext.clave_ext));
	    for (int j = 0; j < ext.vFields.size(); j++)
	      asFieldNames.put( ( (Dictionary) ext.vFields.get(j)).nombre_campo,
	                       ( (Dictionary) ext.vFields.get(j)).sValue);

  }

  public void init()
  {
	  super.init();
	  Calendar today=Calendar.getInstance();
	  fechano=today.get(Calendar.YEAR);
	  fechames=today.get(Calendar.MONTH)+1;
	  fechadia=today.get(Calendar.DAY_OF_MONTH);
	  java.sql.Date jsdDate=new java.sql.Date(today.getTimeInMillis()); 
	  fechafec=jsdDate.toString();  // always in format yyyy-mm-dd
	  // GENERATES THE GLOBAL UNIVERSAL UNIQUE ID
	  UUID uuid = UUID.randomUUID(); 
	  uu_id = uuid.toString(); 

  }
}