package org.lared.desinventar.webobject;

import java.io.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

import org.lared.desinventar.system.*;
import org.lared.desinventar.util.DICountry;
import org.lared.desinventar.util.DbAccess;
import org.lared.desinventar.util.DbImplementation;
import org.lared.desinventar.util.DbJDBC;
import org.lared.desinventar.util.DbMySql;
import org.lared.desinventar.util.DbOracle;
import org.lared.desinventar.util.DbPostgres;
import org.lared.desinventar.util.DbSqlServer;
import org.lared.desinventar.util.DbDerby;
import org.lared.desinventar.util.DbSQLite;
import org.lared.desinventar.util.EncodeUtil;
import org.lared.desinventar.util.dbutils;
import org.lared.desinventar.util.htmlServer;

abstract public class webObject  
	implements Serializable 
{
  // work variables
  private String sObjName;
  public transient Statement stmt; // SQL statement object
  public transient PreparedStatement pstmt;
  public transient ResultSet rset; // SQL resultset
  public String sSql; // SQL statement string
  public String lastError = ""; // miscelaneous error message buffer
  public HashMap<String, String> asFieldNames = new HashMap<String, String>();
  public HashMap fieldNullState = new HashMap();
  

  public static DbImplementation  dbHelper[]={new DbOracle(),new DbAccess(), new DbSqlServer(),new DbMySql(),new DbJDBC(),new DbPostgres(),new DbDerby(), new DbSQLite(), new DbJDBC(), new DbAccess()};
  
  public int nrows = 0;
  // this is needed in order to manage specifics of different platforms
  public int dbType=Sys.iDatabaseType;	
  
  // date manager
  public static java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd"); //("yyyy-MM-dd-HH:mm");
  public static java.text.SimpleDateFormat largeFormatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
  public static java.text.SimpleDateFormat timeFormatter = new java.text.SimpleDateFormat("HH:mm");

  //----------------------------------------------------------------
  // anonymous constructor
  //----------------------------------------------------------------
  public webObject()
  {
    sObjName = "anonymous  webObject";
  }

  //----------------------------------------------------------------
  // named constructor (recommended)
  //----------------------------------------------------------------
  public webObject(String strName)
  {
    sObjName = strName;
  }

  //----------------------------------------------------------------
  // returns obj id.
  //----------------------------------------------------------------
  public String toString()
  {
    return sObjName;
  }

  //--------------------------------------------------------------------------------
  //  SET OF ROUTINES COPIED FROM htmlServer FOR PERFORMANCE AND CODE SIMPLICITY

  //--------------------------------------------------------------------------------
  // generic routine to parse strings...
  //--------------------------------------------------------------------------------
  public static int extendedParseInt(String strNumber)
  {
    int j = 0;
    String strDigits;

    if (strNumber != null)
      {
    	strNumber=strNumber.trim();
        try
        	{
        	j=(int) Double.parseDouble(strNumber);
        	}
        catch (Exception e)
            {
            }
      }
    return j;
  }

  public static java.sql.Date extendedParseDate(String strNumber)
  {
    java.sql.Date dRet =null;

    try
    {
      if (strNumber != null)
      {	  // hopefully dates will come as yyyy-MM-dd, but may come in any other format. This will heuristically identify Y M D components
    	  strNumber=strNumber.replace('/','-');
    	  java.util.Date uDate=new java.util.Date();
    	  
    	  if (strNumber.length()<10)
    		  strNumber+="-0-0-0";
    	  int pos=strNumber.indexOf("-");
    	  String s1=strNumber.substring(0,pos);
    	  strNumber=strNumber.substring(pos+1);
    	  pos=strNumber.indexOf("-");
    	  String s2=strNumber.substring(0,pos);
    	  strNumber=strNumber.substring(pos+1);
    	  int n1=extendedParseInt(s1);
    	  int n2=extendedParseInt(s2);
    	  int n3=extendedParseInt(strNumber);
    	  int y=0,m=0,d=0;
    	  if (n1>31) // this is the year,assumes YMD
    	  {
    		  y=n1;
    		  if (n2>12) // this is the day
    		  {
    			  d=n2;
    			  m=n3;
    		  }
    		  else if (n3>12)
    		  {
    			  d=n3;    			  
    			  m=n2;
    		  }
    		  else // default Y M D.  TODO: Improve this to get the local setting
    		  {
    			  m=n2;
    			  d=n3;
    		  }
    	  }
    	  else if (n3>31) // case either DMY or MDY (n3 is the year)
          {
    		  y=n3;
    		  if (n1>12) // this is the day
    		  {
    			  d=n1;
    			  m=n2;
    		  }
    		  else if (n2>12)
    		  {
    			  d=n2;    			  
    			  m=n1;
    		  }
    		  else // assumes DMY, Canadian+LAC+European starndard. TODO: Improve this to get the local setting
    		  {
    			  d=n1;
    			  m=n2;
    		  }
        		  
          }
    	  else if (n2>31) // Strange case with the year in the middle
          {
    		  y=n2;
    		  if (n1>12) // this is the day
    		  {
    			  m=n3;
    			  d=n1;
    		  }
    		  else if (n3>12)
    		  {
    			  m=n1;
    			  d=n3;    			  
    		  }
    		  else // assumes M Y D
    		  {
    			  m=n1;
    			  d=n3;
    		  }
        		  
          }
    	  else // no number seems to be the year: Assummes MDY
    	  {
    		  if (n1>12) // this is the day
    		  {
    			  d=n1;
    			  m=n2;
    			  y=n3;
    		  }
    		  else if (n3>12)
    		  {
    			  d=n3;    			  
    			  m=n2;
    			  y=n1;
    		  }
    		  else // assumes M D Y
    		  {
    			  m=n1;
    			  d=n2;
    			  y=n3;
    		  }    		  
    	  }
    	  if (m==0)
    		  m=1;
    	  if (d==0)
    		  d=1;
          if (y<100)
        	  y+=1900;
          strNumber=y+"-"+(m<10?"0"+m:m)+"-"+(d<10?"0"+d:d);
          formatter.setLenient(true);
    	  uDate=formatter.parse(strNumber);
    	  Calendar cCal=Calendar.getInstance();
    	  cCal.setTime(uDate);
    	  dRet=new java.sql.Date(cCal.getTimeInMillis());
      }
    }
    catch (Exception e)
    {
    }
    return dRet;
  }

  public static double extendedParseDouble(String strNumber)
  {
    double dRet = 0;

    try
    {
      if (strNumber != null)
        dRet = Double.parseDouble(strNumber.trim());
    }
    catch (Exception e)
    {
    	//System.out.println("ParseDouble / exception: "+strNumber);
    }
    return dRet;
  }

  //returns a nicely formatted double number, ndecs decimals. If ndecs<0, removes all irrelevant decs.
  public static String formatDouble(double val, int ndecs)
    {
      boolean bRemove=false;
      if (ndecs<0){
    	  ndecs=-ndecs;
    	  bRemove=true;
      }
      DecimalFormat  form=new DecimalFormat();
      form.setGroupingUsed(false);
      form.setMaximumFractionDigits(ndecs);
      if (!bRemove)
    	  return form.format(val);
      String sRet=form.format(val);
      if (sRet.indexOf(".")>0)
    	  {
    	  int j=sRet.length()-1;
    	     while (sRet.charAt(j)=='0')
    	    	  j--; // must hit a dot or a number...
    	      if (sRet.charAt(j)=='.')
    	    	  j--; // was a dot...
    	      return sRet.substring(0,j+1);
    	   }
      return sRet;
    }

// returns a nicely formatted double number
public static String formatDouble(double val)
  {

    DecimalFormat  form=new DecimalFormat();
    form.setGroupingUsed(false);
    form.setMaximumFractionDigits(2);
    return form.format(val);
  }

//--------------------------------------------------------------------------------
// return a String with single quotes duplicated, to be used safely and correctly
// in SQL statements, even if the parameter is null..
//--------------------------------------------------------------------------------
  public static String check_quotes(String strParameter)
  {
    int pos;
    String sReturn;

    if (strParameter == null)
    {
      return "";
    }
    else
    {
      sReturn = new String(strParameter);
      pos = sReturn.indexOf("'");
      while (pos >= 0)
      {
        sReturn = sReturn.substring(0, pos) + "'" + sReturn.substring(pos);
        pos = sReturn.indexOf("'", pos + 2);
      }

      return sReturn;
    }
  }

  //--------------------------------------------------------------------------------
  // formats a number field, converting 0's to empty strings
  //--------------------------------------------------------------------------------
  public static String numToStr(int anyNumber)
  {
    String retStr;

    if (anyNumber == 0)
      retStr = "";
    else
      retStr = Integer.toString(anyNumber);
    return retStr;
  }

  
  //--------------------------------------------------------------------------------
  // tests if a string is numeric
  //--------------------------------------------------------------------------------
  public boolean isNumber(String strNumber)
  {
	double dRet = 0.0;
    try
    {
      if (strNumber != null)
        dRet = Double.parseDouble(strNumber.trim());
    }
    catch (Exception e)
    {
    	return false;
    }
    return true;
  }

  
  
  //--------------------------------------------------------------------------------
  // formats a double number with one decimal
  //--------------------------------------------------------------------------------
  public static String dblToStr(double anyNumber)
  {
    String myString;

    myString = NumberFormat.getInstance().format(anyNumber);

    return myString;
  }

  //--------------------------------------------------------------------------------
  // Returns true or false depending on the value
  //--------------------------------------------------------------------------------
  public static boolean strToBool(String strParameter)
  {
    boolean bRet=false;
    if (strParameter != null)
      return (strParameter.equalsIgnoreCase("Y") || 
      		strParameter.equalsIgnoreCase("1") || 
      		strParameter.equalsIgnoreCase("-1") || 
      		strParameter.equalsIgnoreCase("true") || 
			strParameter.equalsIgnoreCase("T"));
    return bRet;
  }

  public static boolean strToBool(int nParameter)
  {
      return (nParameter!=0);
  }


//--------------------------------------------------------------------------------
// return a String "Selected" to be used from HTML forms where a
// select list has hardcoded values. If both parameters are equal it returns
// selected, otherwise it returns an empty string
//--------------------------------------------------------------------------------
  public static String strSelected(String strParameter, String sRef)
  {
    int pos;
    String sReturn;

    if (strParameter.equalsIgnoreCase(sRef))
    {
      return " selected";
    }
    else
    {
      return "";
    }
  }

//--------------------------------------------------------------------------------
// Overloaded version. return a String "Selected" to be used from HTML forms where a
// select list has hardcoded values. If both parameters are equal it returns
// selected, otherwise it returns an empty string
//--------------------------------------------------------------------------------
  public static String strSelected(int nParameter, int nRef)
  {
    int pos;
    String sReturn;

    if (nParameter == nRef)
    {
      return " selected";
    }
    else
    {
      return "";
    }
  }

//--------------------------------------------------------------------------------
// Overloaded version. return a String "Selected" to be used from HTML forms where a
// select list has hardcoded values. If the parameter is true it returns
// selected, otherwise it returns an empty string
//--------------------------------------------------------------------------------
  public static String strSelected(boolean bSelected)
  {
    int pos;
    String sReturn;

    if (bSelected)
    {
      return " selected";
    }
    else
    {
      return "";
    }
  }



//--------------------------------------------------------------------------------
// return a String with the content of a CLOB field
// If the clob is null it returns an empty string
//--------------------------------------------------------------------------------
  public String getClobString(Clob theClob)
  {
    String sRet = "";
    if (theClob != null)
      try
      {
        int nClobLen = (int) theClob.length();
        sRet = theClob.getSubString(1, nClobLen);
      }
      catch (Exception eclob)
      {
      }
    return sRet;
  }

//--------------------------------------------------------------------------------
// return a String with "Checked" to be used safely and correctly
// from HTML forms where a checkbox is managed with a String variable.
// A value of 'Y' means checked, othewise it returns an empty string
//--------------------------------------------------------------------------------
  public static String strChecked(String strParameter)
  {
    int pos;
    String sReturn;

    if ("Y".equalsIgnoreCase(strParameter) || "1".equalsIgnoreCase(strParameter))
    {
      return "CHECKED";
    }
    else
    {
      return "";
    }
  }

//--------------------------------------------------------------------------------
// return a String with "Checked" to be used safely and correctly with RADIO butts
// from HTML forms where a checkbox is managed with a String variable.
// equal values of params means checked, othewise it returns an empty string
//--------------------------------------------------------------------------------
  public static String strChecked(String strParameter, String sRef)
  {
    int pos;
    String sReturn;

    if (strParameter.equalsIgnoreCase(sRef))
    {
      return " CHECKED";
    }
    else
    {
      return "";
    }
  }

//--------------------------------------------------------------------------------
// return a String with "Checked" to be used safely and correctly with RADIO butts
// from HTML forms where a checkbox is managed with a String variable.
// equal values of params means checked, othewise it returns an empty string
//--------------------------------------------------------------------------------
  public static String strChecked(int strParameter, int sRef)
  {
    int pos;
    String sReturn;

    if (strParameter==sRef)
    {
      return " CHECKED";
    }
    else
    {
      return "";
    }
  }

//--------------------------------------------------------------------------------
// return a String with "Checked" to be used safely and correctly with RADIO butts
// from HTML forms where a checkbox is managed with a String variable.
// equal values of params means checked, othewise it returns an empty string
//--------------------------------------------------------------------------------
  public static String strChecked(int strParameter)
  {
    int pos;
    String sReturn;

    if (strParameter!=0)
    {
      return " CHECKED";
    }
    else
    {
      return "";
    }
  }


//--------------------------------------------------------------------------------
// return a String with "Checked" to be used safely and correctly
// from HTML forms where a checkbox is managed with a boolean variable.
// A value of 'Y' means checked, othewise it returns an empty string
//--------------------------------------------------------------------------------
  public static String strChecked(boolean bParameter)
  {
    int pos;
    String sReturn;

    if (bParameter)
    {
      return " CHECKED";
    }
    else
    {
      return "";
    }
  }

//--------------------------------------------------------------------------------
//generic routine avoid null strings...
//--------------------------------------------------------------------------------
 public static String not_null(String strParameter)
 {
   return (strParameter == null)?"":strParameter;
 }

 
//--------------------------------------------------------------------------------
//generic routine avoid null strings and to also encode HTML entities if present...
//--------------------------------------------------------------------------------
public static String not_null_safe(String strParameter)
{
  return (strParameter == null)?"":EncodeUtil.htmlEncode(strParameter);
}

 
/**
 * Truncates a string so that it will not exceed max length
*/

  public String chkLength(String var, int len)
  {
   return var==null?var:var.length()<=len? var:var.substring(0,len);	  
  }

//--------------------------------------------------------------------------------
// function that breaks (with HTML <br>) a string so that it will appear in several lines. Useful
// to display long text in HTML <tables>
//--------------------------------------------------------------------------------

public static String strBreaker(String sToBreak, int nCols)
    {
      if (sToBreak.length()>nCols)
              {
             int nPos=sToBreak.substring(nCols-5).indexOf(" ");
             if (nPos<0)
               nPos=sToBreak.substring(nCols-5).indexOf(",");
             if (nPos<0)
               nPos=sToBreak.substring(nCols-5).indexOf(".");
             if (nPos<0)
                nPos=5;
             sToBreak=sToBreak.substring(0,nCols-4+nPos)+"<br>"+strBreaker(sToBreak.substring(nCols-4+nPos),nCols);
             }
    return sToBreak;
    }

//--------------------------------------------------------------------------------
// generic routine to parse and manage dates as strings...
//--------------------------------------------------------------------------------
  public static String strDate(String strParameter)
  {
    String sDateString = new String(strParameter);
    sDateString=sDateString.replace('/','-');
    if (sDateString.length() > 0)
    {
      formatter.setLenient(true);
      java.util.Date tmpDate = formatter.parse(sDateString, new ParsePosition(0));
      if (tmpDate != null)
        sDateString = formatter.format(tmpDate);
      else
        {
    	  StringTokenizer stk=new StringTokenizer(sDateString,"-");
    	  int nOrder=0;
    	  int nYear=0;
    	  int nDate=0;
    	  int nMonth=0;
    	  while (stk.hasMoreTokens()) {
    	         int nPiece=extendedParseInt(stk.nextToken());
    	         if (nPiece>100)
    	        	 nYear=nPiece;
    	         else if (nPiece>31)
        	        	 nYear=nPiece+1900;
        	     else if (nPiece>12)
    	        		 nDate=nPiece;
    	         else if (nMonth==0)
    	        		 nMonth=nPiece;
    	         else if (nDate==0)	
    	        	 	nDate=nPiece;
    	         else nYear=nPiece+2000;
    	     }     
    	  sDateString = strDate(nYear,nMonth,nDate);    	  
        }
    }
    return sDateString;
  }

  /**
   *  produces the String representation of a specific DesInventar date
   *  Note a DI-date may have month or day null.   a DI-date may be of the form 2003-00-00
   *  
   */
  public static String strDate(int fechano, int fechames, int fechadia)
  {
	  String sRet="'"+fechano+"-";
	  if (fechames<10)
		  sRet+="0";
	  sRet+=fechames+"-";
	  if (fechadia<10)
		  sRet+="0";
	  sRet+=fechadia+"'";  
	  return sRet;
  }

//--------------------------------------------------------------------------------
// generic routine to parse and manage dates as strings from a date object...
//--------------------------------------------------------------------------------
  public static String strDate(java.util.Date dParameter)
  {
    String sDate = "";

    if (dParameter != null)
      sDate = formatter.format(dParameter);

    return sDate;
  }


//--------------------------------------------------------------------------------
// generic routine to parse and manage DATE-TIME STAMPS as strings...
//--------------------------------------------------------------------------------
  public static String strDateTime(String strParameter)
  {
    String sDateString = new String(strParameter);
    sDateString=sDateString.replace('/','-');
    if (sDateString.length() > 0)
    {
      largeFormatter.setLenient(true);
      java.util.Date tmpDate = largeFormatter.parse(sDateString, new ParsePosition(0));
      if (tmpDate != null)
        sDateString = largeFormatter.format(tmpDate);
      else
        sDateString = "";
    }
    return sDateString;
  }

//--------------------------------------------------------------------------------
// generic routine to parse and manage  DATE-TIME STAMPS  as strings from a date object...
//--------------------------------------------------------------------------------
  public static String strDateTime(java.util.Date dParameter)
  {
    String sDate = "";

    if (dParameter != null)
      sDate = largeFormatter.format(dParameter);

    return sDate;
  }


  //--------------------------------------------------------------------------------
  // generic method to produce a SQL acceptable date string in default database
  //--------------------------------------------------------------------------------
  public String sqlDate(String strParameter)
  {
    return dbHelper[this.dbType].sqlDate(strParameter );
  }

  
  
  /**
   *  produces the SQL statement to generate a string representation of a DesInventar date
   *  Note a DI-date may have month or day null.   a DI-date may be of the form 2003-00-00
   *  
   */
  public String sqlDI_date()
  {
	    return dbHelper[this.dbType].sqlDI_date();	  
  }

  /**
   *  produces the constant to include in a SQL statement with a string representation of a DesInventar date
   *  Note a DI-date may have month or day null.   a DI-date may be of the form 20030000	    *  
   */
  public String sqlDI_date(String sYear,String sMonth, String sDay)
  {		   
	   String sRet=Integer.toString(webObject.extendedParseInt(sYear)*10000+webObject.extendedParseInt(sMonth)*100+webObject.extendedParseInt(sDay));		   
	   return sRet;
  }

  /**
   *  produces the constant to include in a SQL statement with a string representation of a DesInventar date
   *  Note a DI-date may have month or day null.   a DI-date may be of the form 20030000	    *  
   */
  public String sqlDI_date(int nYear,int nMonth, int nDay)
  {		   
	   String sRet=Integer.toString(nYear*10000+nMonth*100+nDay);		   
	   return sRet;
  }


  //--------------------------------------------------------------------------------
  // generic method to produce a SQL acceptable datetime stamp string in default database
  //--------------------------------------------------------------------------------
  public String sqlDateTime(String strParameter)
  {
    return dbHelper[this.dbType].sqlDateTime(strParameter);
  }


  //--------------------------------------------------------------------------------
  // generic method to produce a SQL acceptable number string in default database
  //--------------------------------------------------------------------------------
  public String sqlNumber(String strParameter)
  {
    return dbHelper[this.dbType].sqlNumber(strParameter);
  }

  
  //--------------------------------------------------------------------------------
  // generic method to produce a SQL acceptable  string from a date in any database
  //--------------------------------------------------------------------------------
  
  public String sqlCharDate(String strParameter)
  {
    return dbHelper[this.dbType].sqlCharDate(strParameter);
  }
  
  //--------------------------------------------------------------------------------
  // generic method to produce a SQL acceptable  string from a date in any database
  //--------------------------------------------------------------------------------
  
  public String sqlCharNumber(String strParameter)
  {
    return dbHelper[this.dbType].sqlCharNumber(strParameter);
  }


  //--------------------------------------------------------------------------------
  // generic methods to produce a SQL acceptable modulo column, default database
  //--------------------------------------------------------------------------------
  public String sqlMod(String strParameter, String strParameter1)
  {
    return dbHelper[this.dbType].sqlMod(strParameter, strParameter1);
  }

  public String sqlMod(int nParameter, int nParameter1)
  {
    return dbHelper[this.dbType].sqlMod(String.valueOf(nParameter), String.valueOf(nParameter1));
  }

  public String sqlMod(String sParameter, int nParameter1)
  {
    return dbHelper[this.dbType].sqlMod(sParameter, String.valueOf(nParameter1));
  }

  //----------------------------------------------------------------------------------------
  // generic method to produce a SQL acceptable NVL (as defined in Oracle) in any database
  //----------------------------------------------------------------------------------------
  public String sqlNvl(String strParameter, String strParameter1)
  {
    return dbHelper[this.dbType].sqlNvl(strParameter, strParameter1);
  }


  public String sqlNvl(String sParameter, int nParameter1)
  {
    return dbHelper[this.dbType].sqlNvl(sParameter, String.valueOf(nParameter1));
  }


  //--------------------------------------------------------------------------------
  // an SQL acceptable trunc function in default database
  //--------------------------------------------------------------------------------
  public String sqlTrunc()
  {
    return dbHelper[this.dbType].sqlTrunc();
  }

  
  //--------------------------------------------------------------------------------
  // an SQL acceptable XMIN and XMAX names function
  //--------------------------------------------------------------------------------
  public String sqlXmin()
  {
    return dbHelper[this.dbType].sqlXmin();
  }
  public String sqlXmax()
  {
    return dbHelper[this.dbType].sqlXmax();
  }

  
  //--------------------------------------------------------------------------------
  // an SQL acceptable  STD Deviation  function in default database
  //--------------------------------------------------------------------------------
  public String sqlStddev()
  {
    return dbHelper[this.dbType].sqlStddev();
  }

  

  //--------------------------------------------------------------------------------
  // an SQL acceptable  Variance  function in default database
  //--------------------------------------------------------------------------------
  public String sqlVariance()
  {
    return dbHelper[this.dbType].sqlVariance();
  }


  //--------------------------------------------------------------------------------
   // an SQL acceptable String Concat operator in any database
   //--------------------------------------------------------------------------------
   public String sqlConcat()
   {
     return dbHelper[this.dbType].sqlConcat();
   }

   // recommended
   public String sqlConcat(String strParameter, String strParameter1)
   {
     return dbHelper[this.dbType].sqlConcat(strParameter, strParameter1);
   }


   //--------------------------------------------------------------------------------
   // an SQL acceptable String Concat operator  in default database
   //--------------------------------------------------------------------------------
   public String sqlStringConstant()
   {
     return dbHelper[this.dbType].sqlStringConstant();
   }


   //----------------------------------------------------------------
   // gets a primary key from a sequence, in default database
   //----------------------------------------------------------------
   public int getSequence(String sSequence, Connection con)
   {
     return dbHelper[this.dbType].getSequence(sSequence, con);
   }

   //----------------------------------------------------------------
   // gets a primary key from a sequence, in any database
   //----------------------------------------------------------------
   public int getSequence(String sSequence, Connection con, int iDatabaseType)
   {
	     return dbHelper[iDatabaseType].getSequence(sSequence, con);
   }

   /** gets a (database specific) Large text object: FROM CLOB, try a getString, then getClob */
   public String getClob(ResultSet rset, String sField, int iDatabaseType)
   {
	     return dbHelper[iDatabaseType].getClob(rset, sField);
   }
  
   /** gets a (database specific) Large text object: FROM CLOB, try a getString, then getClob */
   public String getClob(ResultSet rset, String sField)
   {
	     return dbHelper[this.dbType].getClob(rset, sField);
   }
  

   

   /** constructs an update statement on Datacards (FICHAS) from a join FICHAS-Extension */
   public String updateDatacardJoin(String sSetStatements, String sWhereStatement)
   {
	   return dbHelper[this.dbType].updateDatacardJoin(sSetStatements, sWhereStatement);
   }

   /** constructs an update statement on EXTENSION from a join FICHAS-Extension */
   public String updateExtensionJoin(String sSetStatements, String sWhereStatement)
   {
	   return dbHelper[this.dbType].updateExtensionJoin(sSetStatements, sWhereStatement);   
   }

   /** constructs an update statement on two tables, with querynames t1 and t2, updating variables on the first! */
   public String updateFromJoin(String sTable1, String sTable2, String sJoinExpression, String sSetStatements, String sWhereStatement)
   {
	   return dbHelper[this.dbType].updateFromJoin(sTable1, sTable2, sJoinExpression, sSetStatements, sWhereStatement); 
   }

   /** creates a sequence or equivalent object */
   public String sCreateSequence(String sSequenceName)
   {
	   return dbHelper[this.dbType].sCreateSequence(sSequenceName);   
   }

   /** drops a sequence or equivalent object */
   public String sDropSequence(String sSequenceName)
   {
	   return dbHelper[this.dbType].sDropSequence(sSequenceName);   
   }

   
   /** returns an equivalent SQL Function. Reference is SQL Server function */
    public String sGetSQLFunction(String sFunctionName)
   {
	   return dbHelper[this.dbType].sGetSQLFunction(sFunctionName.toUpperCase());
   }

// END OF SET OF GENERIC ROUTINES
//--------------------------------------------------------------------------------

String sExtractValue(String sAttibute, String htmlLine, String htmlULine)
{
	String sRadioValue="";
    int pos = htmlULine.indexOf(sAttibute);
    if (pos>0)
    {
        pos+=sAttibute.length();  // advance to =
        while (htmlULine.charAt(pos)!='=' && pos<htmlULine.length())  // verify is an =
        		pos++;
        pos++;  // advance to quote
        while (htmlULine.charAt(pos)!='\'' && htmlULine.charAt(pos)!='"' && pos<htmlULine.length())  // verify is an =
    		pos++;
        char cQuote=htmlULine.charAt(pos);
        int posend=pos+1;
        while (htmlULine.charAt(posend)!=cQuote && posend<htmlULine.length())  // verify is the same quote symbol
    		posend++;
        
        sRadioValue = htmlLine.substring(pos + 1, posend);	
    }
	return sRadioValue;
}

public String generate_label(String variable)
{
String retLabel=variable.replace('_', ' ');
//common abbreviations in DIS extended variables
retLabel=retLabel.replace("DMGD", "DAMAGED");
retLabel=retLabel.replace("DSTR", "DESTROYED");
retLabel=retLabel.replace("AGRI", "AGRICULTURAL");
retLabel=retLabel.replace("AFCTD", "AFFECTED");
if (retLabel.startsWith("LOSS "))
	retLabel="LOSS FROM "+retLabel.substring(5);
retLabel=retLabel.substring(0,1)+retLabel.substring(1).toLowerCase();	
return retLabel;
}

/**--------------------------------------------------------------------------------
* HTML FORMS EXTENDED FIELDS EXTRACTOR. TO BE USED WITH NON-REPEATING FIELDS
* Will return <input> <textarea> <radio> <select> and <checkbox> fields
* that are not found in FICHAS nor in EXTENSION tables. Ignores Buttons
* -------------------------------------------------------------------------------*/
public ArrayList extractFieldsFromTemplate(String filename)
{
	int pos, posend;
	ArrayList<String> retArray=new ArrayList<String>();
	String htmlLine = "";
	String htmlULine = "";
	String fieldName = "";
	String fieldValue = "";
	String sRadioValue = "";
	int fieldType;
	fieldName = "";
	BufferedReader in = null;
	try
	{
		in = new BufferedReader(new FileReader(filename));
		int order=0;
		try
		{
			while ( (htmlLine = in.readLine()) != null)
			{
				// all comparisons in uppercase
				htmlULine = htmlLine.toUpperCase();
				// locates INPUT form fields
				if ( ((htmlULine.indexOf("<INPUT") >= 0) && (htmlULine.indexOf("BUTTON") < 0) )|| 
						(htmlULine.indexOf("<TEXTAREA") >= 0) || 
						(htmlULine.indexOf("<SELECT") >= 0))
				{
					fieldType = 0; //default hidden, file or text field..
					pos = htmlULine.indexOf("CHECKBOX");
					if (pos > 0)
						fieldType = 1;
					else
					{
						pos = htmlULine.indexOf("RADIO");
						if (pos > 0)
							fieldType = 2;
						else
						{
							pos = htmlULine.indexOf("SELECT");
							if (pos > 0)
								fieldType = 3;
							else
							{
								pos = htmlULine.indexOf("TEXTAREA");
								if (pos > 0)
									fieldType=4;
							}
						}
					}
					pos = htmlULine.indexOf("NAME");
					if (pos>0)  // not for OPTION lists
					{
						// extracts the name
						fieldName = sExtractValue("NAME",htmlLine, htmlULine);
						int fieldSize = this.extendedParseInt(sExtractValue("SIZE",htmlLine, htmlULine));
						int fieldMaxLen = this.extendedParseInt(sExtractValue("MAXLENGTH",htmlLine, htmlULine));
						// gets the value of the field with the original name
						if (asFieldNames.get(fieldName)==null)
						{
							if (!retArray.contains(fieldName))
								{
								String sLabel=generate_label(fieldName);
								String sSQLfieldType="VARCHAR("+fieldSize+")";
								int  nDictionaryType=0;
								if (fieldType==0)
								{
									if (fieldSize<=7)
										{
										sSQLfieldType="int";
										nDictionaryType=1;
										}
									else
										if (fieldSize<=15)
											{
											sSQLfieldType="double";
											nDictionaryType=2;
											}
								}
								else
									if (fieldType==4)
									{
										sSQLfieldType="CLOB";
										nDictionaryType=5;
									}
									else
										{
										sSQLfieldType="VARCHAR[15]";
										fieldSize=15;
										}
										
								order++;
								retArray.add(fieldName);
								//System.out.println("insert into diccionario (orden,nombre_campo,descripcion_campo,label_campo,label_campo_en,pos_x,pos_y,lon_x,lon_y,color,tabnumber,fieldtype) values ("
								//		+order+",'"+fieldName+"','" +sLabel+"','" +sLabel+"','" +sLabel+"',0,0,"+fieldSize+",0,0,null,"+nDictionaryType+");");
								//System.out.println("alter table extension add "+fieldName+" "+sSQLfieldType+";");
								}
						}
					}
				}
			}
		}
		catch (Exception e)
		{
			retArray = null;
			System.out.println("[DI9] ERROR: processing template [" + this.toString() + "] " + filename + "..." + e.toString() + " LINE=" + htmlLine);
		}
	}
	catch (Exception ex)
	{
		retArray = null;
		System.out.println("[DI9] ERROR: processing template ["+this.toString()+"] "+filename+"  "+ ex.toString()+" (not found) ...");
	}
	try{in.close();}catch (Exception e) {}

	return retArray;
}

  /**--------------------------------------------------------------------------------
  * STANDARD HTML FORMS PROCESSOR. TO BE USED WITH NON-REPEATING FIELDS
  * Will fill appropiate <input> <textarea> <radio> <select> and <checkbox> with values
  *--------------------------------------------------------------------------------*/
    public ArrayList processTemplate(String filename, JspWriter out, DICountry countrybean, Connection con)
    {
      int pos, posend;
      ArrayList<String> retArray=new ArrayList<String>();
      String htmlLine = "";
      String htmlULine = "";
      String fieldName = "";
      String fieldValue = "";
      String sRadioValue = "";
      int fieldType;
      int ROADS=357;
      int INFRASTRUCTURE=9;

      fieldName = "";
      BufferedReader in = null;
      try
      {
		in = new BufferedReader(new InputStreamReader(new FileInputStream(filename),"UTF-8"));
        try
        {
          while ( (htmlLine = in.readLine()) != null)
          {
            // all comparisons in uppercase
            htmlULine = htmlLine.toUpperCase();
            // locates INPUT form fields
            if ( (htmlULine.indexOf("<INPUT") >= 0) || 
          	   (htmlULine.indexOf("<TEXTAREA") >= 0) || 
          	   (htmlULine.indexOf("<SELECT") >= 0) ||
          	   (htmlULine.indexOf("<OPTION") >= 0))
            {
              fieldType = 0; //default hidden, file or text field..
              pos = htmlULine.indexOf("CHECKBOX");
              if (pos > 0)
                fieldType = 1;
              else
              {
                pos = htmlULine.indexOf("TEXTAREA");
                if (pos > 0)
                  fieldType = 2;
                else
                {
                  pos = htmlULine.indexOf("RADIO");
                  if (pos > 0)
                    fieldType = 3;
                  else
                  {
                    pos = htmlULine.indexOf("OPTION");
                    if (pos > 0)
                      fieldType = 4;
                    else
                    {
                        pos = htmlULine.indexOf("SELECT");
                        if (pos > 0)
                      	  fieldType=5;                 	  
                    }
                  }
                }
              }
              pos = htmlULine.indexOf("NAME");
              if (pos>0)  // not for OPTION lists
              {
              	// extracts the name
              	fieldName = sExtractValue("NAME",htmlLine, htmlULine);
              	// gets the value of the field with the original name
                fieldValue = this.assignValue(fieldName);
                retArray.add(fieldName.toUpperCase());
                htmlLine = htmlLine.substring(0, pos)+" id='"+fieldName+"' "+ htmlLine.substring(pos);
                if (htmlULine.indexOf("ONCHANGE=")<0)
                    htmlLine = htmlLine.substring(0, pos)+" onchange='autosave("+fieldName+")' "+ htmlLine.substring(pos);

                htmlULine = htmlLine.toUpperCase();                	
              }
              switch (fieldType)
              {
                case 0: // TEXT AND HIDDEN FIELDS
                // isolates the value of the field
              	//if (fieldValue.equals("0") || fieldValue.equals("0.0"))
              	//	fieldValue="";
                  pos = htmlULine.indexOf("VALUE");
                  if (pos > 0)
                    htmlLine = htmlLine.substring(0, pos + 7) + fieldValue + htmlLine.substring(pos + 7);
                  else
                  { // if there is no Value attribute...
                    pos = htmlULine.indexOf("NAME");
                    htmlLine = htmlLine.substring(0, pos) + " VALUE=\"" + fieldValue + "\" " + htmlLine.substring(pos);
                  }
                  break;
                case 1: // CHECKBOXES
                  // isolate the value then compare...
                  pos = htmlULine.indexOf("VALUE");
                  if (pos<0)
                  	pos=htmlULine.indexOf("TYPE");
                  sRadioValue = sExtractValue("VALUE",htmlLine, htmlULine);
                  if (fieldValue.equalsIgnoreCase(sRadioValue))
                    htmlLine = htmlLine.substring(0, pos) + " CHECKED " + htmlLine.substring(pos);
                  break;
                case 2: // TEXTAREAS
                  // isolates the end > of the tag
                  pos = htmlULine.indexOf("</TEXTAREA");
                  htmlLine = htmlLine.substring(0, pos) + fieldValue + htmlLine.substring(pos);
                  break;
                case 3: // RADIO
                  pos = htmlULine.indexOf("VALUE");
                  sRadioValue = sExtractValue("VALUE",htmlLine, htmlULine);
                  if (fieldValue.length() > 0)
                    if (sRadioValue.equalsIgnoreCase(fieldValue))
                      htmlLine = htmlLine.substring(0, pos) + "CHECKED " + htmlLine.substring(pos);
                  break;
                case 4: // OPTION
                    pos = htmlULine.indexOf("VALUE");
                    sRadioValue = sExtractValue("VALUE",htmlLine, htmlULine);
                    if (fieldValue.length() > 0)
                      if (sRadioValue.equalsIgnoreCase(fieldValue))
                        htmlLine = htmlLine.substring(0, pos) + "SELECTED " + htmlLine.substring(pos);
                    break;
              }
              // System.out.println("[DI9] debug:  Input field detected: "+htmlLine);
            }
            out.println(htmlLine); // outputs the html line
            
            if (htmlLine.indexOf("<!--@@@-Sendai:") >= 0)   // example: <!--@@@-Sendai:C-2C -->)
            {
                //System.out.println("[DI9] debug:  Metadata expansion detected: "+htmlLine);
            	// process a disaggregation box
            	// isolate the indicator code
            	String sIndCode=htmlLine.substring(15);
            	pos=sIndCode.indexOf(" ");
            	if (pos<=0)
            		pos=sIndCode.indexOf("-->");
            	sIndCode=sIndCode.substring(0,pos);
            	stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            	

            	int indicator_key=1;
            	// find what indicator is to be disaggregated
            	rset=stmt.executeQuery("Select * from metadata_indicator where indicator_code='"+sIndCode+"'");
            	if (rset.next())
            		indicator_key=rset.getInt("indicator_key");
            	rset.close();
            	
            	if (indicator_key==INFRASTRUCTURE)
        		{
        		// force the existance of item 357 - Roads!!
        		rset=stmt.executeQuery("Select * from metadata_element where metadata_country='"+countrybean.countrycode+"' and metadata_element_key=357");
        		boolean bKmVias=rset.next();
        		rset.close();
        		if (!bKmVias)
            		{
        			dbutils.generateMetadataEntry(indicator_key, ROADS, countrybean, con);	            			
            		}
            	}

            	// find the disaggregations for that indicator in this country
            	rset=stmt.executeQuery("Select * from metadata_element e, metadata_element_indicator ei where e.metadata_country='"+countrybean.countrycode+
            			               "' and e.metadata_element_key=ei.metadata_element_key and  ei.metadata_country=e.metadata_country and ei.indicator_key="+indicator_key+"  order by e.metadata_element_key");
            	MetadataElement metaElement=new MetadataElement();
            	int i=0;
            	while (rset.next())
            	{
            		metaElement.loadWebObject(rset);
            		// generate the header if there are elements only
            		if (i==0)
            			{
						out.println("<div class='container vertical-divider bss'>");
						out.println("<div class='column four-sixth'>");
						out.println("<fieldset>");
						out.println("<legend>"+countrybean.getTranslation("Disaggregation:")+"</legend>");
						out.println("<table name='SENDAI_TABLE_"+indicator_key+"' id='SENDAI_TABLE_"+indicator_key+"' width='100%' border='0' cellpadding='1' cellspacing='0' rules='rows' class='bss'>");
            			}
            		i++;
					out.println("<tr>");	
            		int k=metaElement.metadata_element_key; // just to have something short
            		fieldName="LOSS_"+k;
                    fieldValue = this.assignValue(fieldName);
                    retArray.add(fieldName.toUpperCase());
					out.println("<td width='25%' valign='middle'>");
					out.println(metaElement.metadata_element_sector); 
					out.println("</td><td width='25%' valign='bottom'>");
					out.println(countrybean.getTranslation("Economic loss")+":<br />"); 					
					out.println("<input type='text' name='"+fieldName+"' id='"+fieldName+"' onchange='autosave("+fieldName+")' value='"+fieldValue+"' size='15' placeholder='Number'>");
					out.println("</td><td width='25%' valign='bottom'>");
            		if (k==ROADS)
            			fieldName="kmvias";
            		else
            			fieldName="TOTAL_"+k;
                    fieldValue = this.assignValue(fieldName);
                    retArray.add(fieldName.toUpperCase());
                    String sUnits=countrybean.getTranslation("Units");
                    if (metaElement.metadata_element_measurement.equalsIgnoreCase("ha") || metaElement.metadata_element_measurement.equalsIgnoreCase("M"))
                    	sUnits=metaElement.metadata_element_measurement;
					out.println(countrybean.getTranslation("Total Affected")+" ("+metaElement.metadata_element_unit+") ["+sUnits+"]: <br />");
					out.println("<input type='text' name='"+fieldName+"' id='"+fieldName+"' onchange='autosave("+fieldName+")' value='"+fieldValue+"' size='15' placeholder='Number'>");
					out.println("<input type='button' NAME='ADD_TLD"+k+"' value='&Sigma;' onclick='addLoss("+fieldName+",DAMAGED_"+k+", DESTRYD_"+k+", null)' />"); 
					out.println("</td><td width='25%' valign='bottom'>");
            		fieldName="DAMAGED_"+k;
                    fieldValue = this.assignValue(fieldName);
                    retArray.add(fieldName.toUpperCase());
					out.println(countrybean.getTranslation("Damaged")+" ("+metaElement.metadata_element_unit+") ["+sUnits+"]: <br />");
					out.println("<input type='text' name='"+fieldName+"' id='"+fieldName+"' onchange='autosave("+fieldName+")' value='"+fieldValue+"' size='15' placeholder='Number'>");
					out.println("</td><td valign='bottom'>");
            		fieldName="DESTRYD_"+k;
                    fieldValue = this.assignValue(fieldName);
                    retArray.add(fieldName.toUpperCase());
					out.println(countrybean.getTranslation("Destroyed")+" ("+metaElement.metadata_element_unit+") ["+sUnits+"]: <br />");
					out.println("<input type='text' name='"+fieldName+"' id='"+fieldName+"' onchange='autosave("+fieldName+")' value='"+fieldValue+"' size='15' placeholder='Number'>");
					out.println("</td>");            		
            		out.println("</tr>");
            	}
            	rset.close();
            	stmt.close();
            	if (i>0)
					{
    				out.println("</table>");
    				out.println("</fieldset>");    
    				out.println("</div>    ");
    				out.println("</div>");
					}
            	else {
					out.println("<div class='container vertical-divider bss'>");
					out.println("<div class='column four-sixth' id='FOR_SENDAI_TABLE_"+indicator_key+"'>");
    				out.println("</div>    ");
    				out.println("</div>");
            	}
            }
          }
        }
        catch (Exception e)
        {
          retArray = null;
          System.out.println("[DI9] SYSTEM ERROR: processing template [" + this.toString() + "] " + filename + "..." + e.toString() + " LINE=" + htmlLine);
        }
      }
      catch (Exception ex)
      {
        retArray = null;
        System.out.println("[DI9] SYSTEM ERROR: processing template ["+this.toString()+"] "+filename+"  "+ ex.toString()+" (not found) ...");
      }
      try{in.close();}catch (Exception e) {}

      return retArray;
    }

  
 
//--------------------------------------------------------------------------------
// Overloaded processTemplate. TO BE USED WITH language specific datasets.
// Will replace <input> <textarea> <radio> and <checkbox> tags with display values
// uses a language code and requires a webObject to return the appropriate value
//--------------------------------------------------------------------------------
  public int processTemplate(String filename, int languageCode, JspWriter out)
  {
    int c;
    int pos;
    int retCode;
    StringBuffer htmlBuffer;
    String htmlLine;
    String htmlULine;
    String fieldName;
    String repeatingFieldName;
    String fieldValue;
    int fieldType;

    retCode = 0; // assumes no error
    fieldName = "";
    try
    {
      BufferedReader in = new BufferedReader(new FileReader(Sys.strFilePrefix + filename));
      try
      {
        while ( (htmlLine = in.readLine()) != null)
        {
          // locates INPUT, CHECKBOX, TEXTAREA
          htmlULine = htmlLine.toUpperCase();
          if ( (htmlULine.indexOf("<INPUT") >= 0) || (htmlULine.indexOf("<TEXTAREA") >= 0))
          {
            fieldType = 0; //default hidden, file or text field..
            pos = htmlULine.indexOf("CHECKBOX");
            if (pos > 0)
            {
              fieldType = 1;
            }
            else
            {
              pos = htmlULine.indexOf("TEXTAREA");
              if (pos > 0)
                fieldType = 2;
              else
              {
                pos = htmlULine.indexOf("RADIO");
                if (pos > 0)
                  fieldType = 3;
              }

            }
            pos = htmlULine.indexOf("NAME");
            fieldName = htmlLine.substring(pos + 6);
            fieldName = fieldName.substring(0, fieldName.indexOf("\""));
            // gets the value of the field with the original name
            fieldValue = this.assignValue(fieldName);

            // re-generates the name (for repeating objects)
            repeatingFieldName = this.assignName(fieldName);
            htmlLine = htmlLine.substring(0, pos + 6) + repeatingFieldName + htmlLine.substring(pos + 6 + fieldName.length());
            htmlULine = htmlLine.toUpperCase();
            switch (fieldType)
            {
              case 0: // TEXT AND HIDDEN FIELDS

                // isolates the name of the field
                pos = htmlULine.indexOf("VALUE");
                if (htmlULine.indexOf("HIDDEN") >= 0)
                  htmlLine = htmlLine.substring(0, pos + 7) + fieldValue + htmlLine.substring(pos + 7);
                else
                {
                  htmlLine = fieldValue;
                  // produces the HOT spots
                  if (htmlLine.length() > 0)
                    if (htmlULine.indexOf("WWW") >= 0)
                    {
                      if (!htmlLine.startsWith("http://"))
                        htmlLine = "http://" + htmlLine;
                      htmlLine = "<A HREF='" + htmlLine + "'>" + htmlLine + "</a>";
                    }
                    else
                    if (htmlULine.indexOf("EMAIL") >= 0)
                    {
                      htmlLine = "<A HREF='mailto:" + htmlLine + "'>" + htmlLine + "</a>";
                    }
                }
                break;
              case 1: // CHECKBOXES

                // isolates the end > of the tag
                pos = htmlLine.indexOf(">");
                if (fieldValue.equalsIgnoreCase("Y"))
                  htmlLine = htmlLine.substring(0, pos) + " Checked" + htmlLine.substring(pos);
                break;
              case 2: // TEXTAREAS
                htmlLine = fieldValue;
                break;
              case 3: // RADIO
                pos = htmlULine.indexOf("VALUE");
                String sRadioValue = htmlLine.substring(pos + 7, fieldValue.length() + pos + 7);
                if (sRadioValue.equals(fieldValue))
                  htmlLine = htmlLine.substring(0, pos) + "checked " + htmlLine.substring(pos);
                break;
            }
          }

          // identifies select tag and gets the name of the field. The line will not be output
          if (htmlULine.indexOf("<SELECT") >= 0)
          {
            // isolates the name of the field
            pos = htmlULine.indexOf("NAME");
            fieldName = htmlLine.substring(pos + 6);
            fieldName = fieldName.substring(0, fieldName.indexOf("\""));
            // re-generates the name (for repeating objects)
            repeatingFieldName = this.assignName(fieldName);
            htmlLine = htmlLine.substring(0, pos + 6) + repeatingFieldName + htmlLine.substring(pos + 6 + fieldName.length());
          }

          // do NOT output lines with <select> tags
          if ( (htmlULine.indexOf("<SELECT") < 0) && (htmlULine.indexOf("</SELECT") < 0))
            out.println(htmlLine); // outputs the html line

            // now, output the value of SELECT
          if (htmlULine.indexOf("<SELECT") >= 0)
          {
            // and generates the corresponding list of options
            this.assignSelect(fieldName, out);
          }
        }
        in.close();
      }
      catch (IOException e)
      {
        retCode = -1;
        out.println("SYSTEM ERROR: processing template [" + this.toString() + "] " + filename + "...");
      }
    }
    catch (Exception ex)
    {
      retCode = -1;
      //    out.println("SYSTEM ERROR: processing template ["+this.toString()+"] "+filename+"  "+ ex.toString()+" (not found) ...");
    }

    return retCode;
  }

  //----------------------------------------------------------------
  // Operational methods any webObject must have. Abstract class
  // provides templates and default behaviour (return error)
  //----------------------------------------------------------------

  //--------------------------------------------------------------------------------
  // return a string corresponding to am HTML field (used while processing INPUT's)
  //--------------------------------------------------------------------------------
  public String assignValue(String fieldName)
  {
    String retValue = (String) asFieldNames.get(fieldName);
    if (retValue == null)
      {
    	//System.out.println("[DI9]  Field name not found! "+fieldName);
    	return "";
      }
    else
      {
		int pos=retValue.indexOf(".");
		if (pos>0 && (retValue.length()-pos>5)) // must be posgres introducing lots of decimals ob float4 numbers
			{
				double numPostgres=extendedParseDouble(retValue);
				retValue=webObject.formatDouble(numPostgres,2);
			}
    	if (retValue.equals("0.0") || retValue.equals("0"))
    	      return "";
    	if (retValue.endsWith(".0") || retValue.endsWith(".00"))
    		retValue=retValue.substring(0,retValue.lastIndexOf("."));
    	return retValue;
      }
  }

  //--------------------------------------------------------------------------------
  // returns a unique HTML fieldname. Special for repeating webObjects in a form..
  //--------------------------------------------------------------------------------
  public String assignName(String fieldName)
  {
    return fieldName;
  }

  //--------------------------------------------------------------------------------
  // processes SELECT statements. produces the pick list with a selected value
  //--------------------------------------------------------------------------------
  public void assignSelect(String fieldName, JspWriter out)
  {
    try
    {
      out.print("<OPTION VALUE=\"" + fieldName + "\">No values for " + fieldName + "</OPTION>");
    }
    catch (Exception e)
    {
    }
  }


  //----------------------------------------------------------------
  // creates HTML to display the object, based on a template
  //----------------------------------------------------------------
  public int toScreen(String templateFile, JspWriter out)
  {
    try
    {
      out.println("<br>No toScreen(templateFile) method has been provided for this object: "
                  + toString() + "<br>");
    }
    catch (Exception e)
    {
    }

    return -1;
  }

  //----------------------------------------------------------------
  // creates HTML with a form to enter object info, based on a template
  //----------------------------------------------------------------
  public int toForm(String templateFile, JspWriter out)
  {
    try
    {
      out.println("<br>No toForm() method has been provided for this object: "
                  + toString() + "<br>");
    }
    catch (Exception e)
    {
    }
    return -1;
  }

  //----------------------------------------------------------------
  // creates HTML with a form to enter object info
  //----------------------------------------------------------------
  public int toBlankForm(String templateFile, JspWriter out)
  {
    try
    {
      out.println("<br>No toBlankForm() method has been provided for this object: "
                  + toString() + "<br>");
    }
    catch (Exception e)
    {
    }
    return -1;
  }

  //----------------------------------------------------------------
  // gets with a form to enter object info
  //----------------------------------------------------------------
  public int getForm(HttpServletRequest request,
                     HttpServletResponse response,
                     Connection con)
  {
    return -1;
  }


  //-----------------------------------------------------------------------------------------
  // gets the number of references of a value from a column on a
  // table. Used especially to check for referential integrity constraints
  //-----------------------------------------------------------------------------------------
  public int getReferenceCount(String sColumn, String sValue, String sTable, Connection con)
  {
    ResultSet rset; // SQL resultset
    String sSql; // SQL statement string
    int nRecs = 0;
    
	PreparedStatement pstmt=null;
    try
    {
      sSql = "select count(*) as nrecs from " + sTable.toLowerCase()+ " where "+sColumn+"=?";   // +sValue+"'";
      pstmt = con.prepareStatement(sSql);
	  pstmt.setString(1, sValue);
      rset = pstmt.executeQuery();
      if (rset.next())
        nRecs = rset.getInt("nrecs");
      rset.close();
      pstmt.close();
    }
    catch (SQLException e)
    {
      lastError = "<!--getReferenceCount" + e.toString() + "-->";
    }
    return nRecs;
  }

  //----------------------------------------------------------------
  // gets the maximum value from a column on a table. Used especially
  // to generate display_orders...
  //----------------------------------------------------------------
  public int getMaximum(String sColumn, String sTable, Connection con)
  {
    return getMaximum(sColumn, sTable, "", con);
  }


  //----------------------------------------------------------------
  // gets the maximum value from a column on a table. Used especially
  // to generate display_orders...
  //----------------------------------------------------------------
  public int getMaximum(String sColumn, String sTable, String sWhere, Connection con)
  {
    Statement stmt; // SQL statement object
    ResultSet rset; // SQL resultset
    String sSql; // SQL statement string
    int key_id;

    key_id = 0;
    try
    {
      sSql = "select max(" + sColumn + ") as maxval from " + sTable.toLowerCase();
      if (sWhere.length() > 0)
        sSql += " where " + sWhere;
      stmt = con.createStatement ();
      rset = stmt.executeQuery(sSql);
      if (rset.next())
        key_id = rset.getInt("maxval");
      rset.close();
      stmt.close();
    }
    catch (SQLException e)
    {
      lastError = "<!--getMaximum" + e.toString() + "-->";
    }
    return key_id;
  }


  //----------------------------------------------------------------
  // reads an object from the database
  //----------------------------------------------------------------
  public int getWebObject(Connection con)
  {
    return -1;
  }


  //----------------------------------------------------------------
  // adds a new object to the database
  //----------------------------------------------------------------
  public int addWebObject(Connection con)
  {
    return -1;
  }

  //----------------------------------------------------------------
  // updates an existing object in the database
  //----------------------------------------------------------------
  public int updateWebObject(Connection con)
  {
    return -1;
  }

  //----------------------------------------------------------------
  // deletes an existing object in the database
  //----------------------------------------------------------------
  public int deleteWebObject(Connection con)
  {
    return -1;
  }
  
  public void init()
  {	  
  }
  
  public void updateMembersFromHashTable() 
  {
  }

  
}