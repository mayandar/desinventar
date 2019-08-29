package org.lared.desinventar.webobject;

import java.io.*;
import java.util.*;
import java.sql.*;
import java.math.*;
import java.text.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

/**
 * <p>Title: DesInventar WEB Version 6.1.2</p>
 * <p>Description: This class extends the functionality of users maintaining a vector of
 * allowed countries. This is needed as there's a problem with the user being able to switch to another
 * region using DesConsultar, or another user open window.</p>
 * <p>Copyright: Copyright (c) 2002  La  Red.</p>
 * <p>Company: La Red -  La Red de Estudios Sociales en Prevención de Desastres en América Latina</p>
 * @author Julio Serje
 * @version 1.0
 */

public class xuser extends users
{
  public ArrayList<String> hCountries=new ArrayList<String>();
  public ArrayList<String>[] aLevel0=new ArrayList[3];

  public int nFailedCount=0;
  public int nMaxLevel=3;   

  

  public boolean bHasAccess(String sCountryCode)
  {
  boolean bAccess=false;
  bAccess=hCountries.contains(sCountryCode) || (iusertype==99);
  return bAccess;
  }
  

  public void setCountries(Connection con)
  {
    Statement stmt=null;
    ResultSet rset=null;
    String sSql = "";

    hCountries=new ArrayList<String>();
    // allocate up to 3 levels of permissions
    for (int j=0; j<nMaxLevel; j++)
  	  aLevel0[j]=new ArrayList<String>();

    try
    {
      stmt = con.createStatement ();
      // not using a nested query due to MySql limitations...
      sSql="Select * from user_permissions where userid='"+suserid+"'";
      rset = stmt.executeQuery(sSql);
      while (rset.next())
      {
        hCountries.add(rset.getString("country"));
      }

      sSql="Select * from user_subpermissions where userid='"+suserid+"'";
      rset = stmt.executeQuery(sSql);
      while (rset.next())
      	{
    	  aLevel0[rset.getInt("region_level")].add(rset.getString("country")+":"+rset.getString("region_code"));
      	}
    }
    catch (Exception ioe)
    {
      lastError="<!--Error in XUser: " + ioe+"-->";
    }
    try{rset.close();} catch (Exception e){}
    try{stmt.close();} catch (Exception e){}
  }
}
