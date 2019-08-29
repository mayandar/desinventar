package org.lared.desinventar.tag;

import java.sql.*;
import java.util.ArrayList;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import org.lared.desinventar.util.dbConnection;
import org.lared.desinventar.util.htmlServer;
import org.lared.desinventar.webobject.UserSubpermissions;
import org.lared.desinventar.webobject.country;

/** JSP tag that expands a list of options
 * with all the geography level 0 elements.
 */

public class selectLevelX    extends TagSupport
{
  private Connection con;
  private String sUserId="";
  private int nLevel=0;
  private boolean bOnlySelected=false;
  private String sWhere="";
  
  
  public void setConnection(Connection con)
  {
    this.con = con;
  }

  public void setUser(String sSelectedCode)
  {
    this.sUserId = sSelectedCode;
  }

  public void setLevel(int nSelectedLevel)
  {
    this.nLevel = nSelectedLevel;
  }

  public void setLevel(String sSelectedLevel)
  {
    this.nLevel = Integer.valueOf(sSelectedLevel);
  }

  public void setOnly_selected(String sOnlySelected)
  {
    this.bOnlySelected= sOnlySelected.equalsIgnoreCase("y");
  }

  public void setWhere(String sWhereClause)
  {
    sWhere=sWhereClause;
  }


  public int doStartTag()
  {
    Statement stmt;
    ResultSet rset;
    String sCode = "";
    ArrayList<String> vAllCountries = new ArrayList<String>();
    ArrayList<String> vSelectedCountries = new ArrayList<String>();
    ArrayList<String> vSelectedCodes = new ArrayList<String>();
    ArrayList<Integer> vSelectedLevels = new ArrayList<Integer>();
    

    try
    {
      JspWriter out = pageContext.getOut();
      HttpSession session =  pageContext.getSession();
      org.lared.desinventar.util.DICountry countrybean = null;
      synchronized (session) {
        countrybean = (org.lared.desinventar.util.DICountry) pageContext.getAttribute("countrybean", PageContext.SESSION_SCOPE);
        if (countrybean == null){
          countrybean = new org.lared.desinventar.util.DICountry();
        }
      }

      stmt = con.createStatement ();      
 	  rset=stmt.executeQuery("select userid, country " +
                 " from user_permissions " +
                 " where userid='"+sUserId+"' order by country");
	  while (rset.next())
		{ 
		  vAllCountries.add(rset.getString("country"));
		}
      
 	  rset=stmt.executeQuery("select userid, country, region_code, region_level " +
 	  		                 " from user_subpermissions " +
 	  		                 " where userid='"+sUserId+"' order by country");
	  UserSubpermissions subperm=new UserSubpermissions();
	  while (rset.next())
			{ 
				subperm.loadWebObject(rset);
				vSelectedCountries.add(subperm.country);
				vSelectedCodes.add(subperm.region_code);
				vSelectedLevels.add(subperm.region_level);
			}
 

	  for (int i=0; i<vAllCountries.size(); i++)
	  {
	      country co=new country();
	      co.scountryid=vAllCountries.get(i);
	      co.getWebObject(con);
	      
	      // Declaration of default Dabatase variables available to the page 
	      dbConnection dbCon=null;
	      // this is just a shortcut, easier to remember
	      int dbType=countrybean.country.ndbtype; 
	      Connection connection=null; 
	      boolean bConnectionOK=false; 
	      // opens the database 
	      dbCon=new dbConnection(co.sdriver,co.sdatabasename,co.susername,co.spassword);
	      bConnectionOK = dbCon.dbGetConnectionStatus();
	      if (bConnectionOK)
	      	{	
	    	  connection=dbCon.dbGetConnection();
	    	  Statement st=connection.createStatement();
	    	  String sSql="Select * from lev"+nLevel+" where lev"+nLevel+"_cod"+(bOnlySelected?"":" not") ;
	    	  sSql+=" in ('!@'";
    		  for (int j=0; j<vSelectedCodes.size(); j++)
    			if (vSelectedCountries.get(j).equals(co.scountryid) && vSelectedLevels.get(j).intValue()==nLevel)  
    			  sSql+=",'"+vSelectedCodes.get(j)+"'";
    		  sSql+=")";
    		  if (nLevel>0)
    		  {
    	    	  sSql+="and lev"+nLevel+"_lev"+(nLevel-1)+" in ('!@'";
        		  for (int j=0; j<vSelectedCodes.size(); j++)
        			if (vSelectedCountries.get(j).equals(co.scountryid) && vSelectedLevels.get(j).intValue()==nLevel-1)  
        			  sSql+=",'"+vSelectedCodes.get(j)+"'";
        		  sSql+=")";
    			  
    		  }
 	    	  if (sWhere.length()>0)
	    		  sSql+=" and ("+sWhere+")";
	    	  sSql+=" order by "+(nLevel>0?"lev1_lev0,":"")+"lev"+nLevel+"_name";	    	  
		      ResultSet rs = st.executeQuery(sSql);
		      while (rs.next())
		      {
		        sCode = rs.getString("lev"+nLevel+"_cod");
		        out.print("<option value='" +co.scountryid+"@"+ htmlServer.htmlEncode(sCode) + "'>");		         
		        out.println(htmlServer.htmlEncode(co.scountryname+" : "+(nLevel==1?(rs.getString("lev1_lev0")+" - "):"")+countrybean.getLocalOrEnglish(rs,"lev"+nLevel+"_name","lev"+nLevel+"_name_en")));
		      }
		      rs.close();
		      st.close();
	      	}
	      dbCon.close();		  
	  }
    }
    catch (Exception ioe)
    {
      System.out.println("Error in TagLib  [setLevel0Code]: " + ioe);
    }
    return (SKIP_BODY);
  }
}