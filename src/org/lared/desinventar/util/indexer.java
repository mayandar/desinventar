package org.lared.desinventar.util;

import java.io.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.webobject.*;
import org.lared.desinventar.system.*;

/**
 * <p>Title: DesInventar Core Java Classes</p>
 * <p>Description: This class does a massive Full-Text reindexing of the glide database</p>
 * <p>Copyright: Copyright (c) 2002 LA RED</p>
 * <p>Company: </p>
 * @author Julio Serje, La Red
 * @version 1.0
 */

public class indexer extends webObject
{

	
	  private String token;
	  private HashMap hWords= new HashMap();
	  private int state=0;
      int nWords=0;
  	  PreparedStatement insertstmt=null;
  	  PreparedStatement inswordstmt=null;
	  PreparedStatement updatestmt=null;
    	

      
	  public void initIndexer()
	  {
	    token = "";
	    hWords = new HashMap();
	    state = 0;
	  }

	  // the number of occurrences per word
	  private int addToIndex(String token, int clave, Connection con)
	  { // only words, no numbers...
	  	Integer iKey=null; 
    	iKey = (Integer) hWords.get(token);
        if (iKey == null)
            {
        	iKey = getSequence("words_seq",con);
        	hWords.put(token, iKey);
            }
        try
             {
          		// String sSql = "insert into wordsdocs (docid,wordid,Occurrences) values(" +clave + "," + iKey.intValue() + ",1)";
          		// ix_stmt.executeUpdate(sSql);
          		insertstmt.setInt(1,clave);
          		insertstmt.setInt(2,iKey.intValue());
          		insertstmt.executeUpdate();   
             }
         catch (Exception e)
          	{
	        try
             	{
          		//String sSql = "update wordsdocs set occurrences=occurrences+ 1 where docid="+clave + " and wordid=" + iKey.intValue();
          		//ix_stmt.executeUpdate(sSql);
	        	updatestmt.setInt(1,clave);
	        	updatestmt.setInt(2,iKey.intValue());
	        	updatestmt.executeUpdate();   
             	}
	        catch (Exception e2)
	          	{
	          	System.out.println("two phase failure values(" +clave + "," + iKey.intValue() + ",1)");
	          	}	          	
	         }	    	
	  	return iKey.intValue();
	  }

	  public void parseString(String sAllStrings, int clave, Connection con)
	  {
	    // single quote not in NOT delimiters.
	  	StringTokenizer stTokSource = new StringTokenizer(sAllStrings," -.;:/\\!][{}()*&^%$#@!,\"|+?~`");
	    while (stTokSource.hasMoreTokens())
	    {
	      String sTok = stTokSource.nextToken();
	      if (sTok.length()>1)
		  	if (Character.isLetter(sTok.charAt(0)) || Character.isDigit(sTok.charAt(0)))
	          addToIndex(sTok, clave, con);
	    }
	  }

	  
	  
	  public boolean indexThis(fichas datacard, Connection con)
	  {
	    String sSql = "";
	    int nRows = 0;
	    int nWordId = 0;
	    boolean retCode = true;

	    try
	    {
	      state = 0;
	      String sAllStrings = datacard.getFullTextString();
	      parseString(sAllStrings, datacard.clave, con );
	    }
	    catch (Exception e5)
	    {
	      System.out.println("Indexer: "+e5.toString() + " : " + sSql);
	      retCode = false;
	    }
	    return retCode;
	  }

 public void checkIndexes(Connection con)
 {
	  //Database Connection Objects
	  int nSqlRet = 0; // return from update SQL
	  String sSql; // string holding SQL statement
	  Statement stmt; // SQL statement object
	  ResultSet rset = null; // SQL resultset
	  try
	  {
	  	stmt=con.createStatement();
	  	// determines if the indexes exist..
		try
			{
		      rset=stmt.executeQuery("select * from words where wordid=-1");
			}
	  	catch (Exception e)
	  		{
	  		try
	  			{
		  		// index doesn't exist. create it:  (this can ONLY happen with Access Databases. SQL is ACCESS -dependant
		  		// other DB platfoms haver ensured the database is properly created with all tables and fields
		  		stmt.executeUpdate("create table words (wordid integer, word text(32), occurrences integer)");
		  		stmt.executeUpdate("create table wordsdocs (docid integer, wordid integer, occurrences integer)");
		  		stmt.executeUpdate("create table words_seq (nextval autoincrement, dum integer)");
		  		stmt.executeUpdate("alter table words add constraint WORDPK primary key (word)");
		  		stmt.executeUpdate("alter table wordsdocs add constraint WORDOCSSPK primary key (docid,wordid)");
		  		stmt.executeUpdate("create index wordsdocs_byword on wordsdocs(wordid)");
		  		// index tables are created, now reindex datacards, ACCESS mode
		        // this is to be done from another page... reIndex(con,1);
	  			}
	        catch (Exception e2)
	        	{
	        	System.out.println("Error creating[2] index tables: " + e2.toString());
	        	}
	  		}
	  	stmt.close();
	  }
      catch (Exception e)
      {
        System.out.println("Error creating index tables: " + e.toString());
      }
 }
	
 public void reIndex(Connection con, int dbType, JspWriter out)
  {
  boolean bSysOK = Sys.getProperties();
  //Database Connection Objects
  int nSqlRet = 0; // return from update SQL
  String sSql; // string holding SQL statement
  Statement stmt; // SQL statement object
  ResultSet rset = null; // SQL resultset
  String strErrors; // validation errors
  fichas Disaster = new fichas();
  int nWordId=0;
  this.dbType=dbType;

  if (con != null)
    {

      sSql = "select * from fichas";
	  try
      {
        stmt = con.createStatement();
        stmt.executeUpdate("delete from wordsdocs");
        stmt.executeUpdate("delete from words");
        
        stmt.executeUpdate(this.sDropSequence("words_seq"));
        stmt.executeUpdate(this.sCreateSequence("words_seq"));

        // TODO:  restart sequence depending on DB PLATFORM.
        // for now, it;s assumed the sequence is fresh to start with 1.
        // and platform is access
        rset = stmt.executeQuery(sSql);
        System.out.println("Starting full re-index...");
        int nRecs=0;

      	insertstmt=con.prepareStatement("insert into wordsdocs (docid,wordid,Occurrences) values(?,?,1)") ;
      	updatestmt=con.prepareStatement("update wordsdocs set occurrences=occurrences+ 1 where docid=? and wordid=?");

        while (rset.next())
        {
          Disaster.loadWebObject(rset);
          indexThis(Disaster,con);
          nRecs++;
          if (nRecs % 1000 ==0 && out!=null)
          	try
          		{
          		out.println("Indexing: "+nRecs+ " records indexed. Serial="+Disaster.serial+"<br>");
          		}
          catch (Exception oute){}
        }
        rset.close();
      	inswordstmt=con.prepareStatement("insert into words (wordid,word,Occurrences) values(?,?,1)") ;
        for (Iterator e = hWords.keySet().iterator(); e.hasNext(); )
	      {
	        try
	        {
	          token = (String) e.next();
	          if (token.length()>30)
	          	token=token.substring(0,30);
	          Integer iKey = (Integer) hWords.get(token);
	          nWordId = iKey.intValue();
	          // sSql = "insert into words (wordid,word,Occurrences) values(" +nWordId + ",'" + Disaster.check_quotes(token) + "',0)";
	          // stmt.executeUpdate(sSql);
		      inswordstmt.setInt(1,nWordId);
	          inswordstmt.setString(2,token);
	          inswordstmt.executeUpdate();
	        }
	        catch (Exception e4)
	        {
	          System.out.println("Indexer/reindex: "+e4.toString() + " : " + sSql);
	        }
	      }

    	stmt.close();
    	insertstmt.close();
    	updatestmt.close();
    	inswordstmt.close();
        // System.out.println("Finished processing...");

      }
      catch (Exception e)
      {
        System.out.println("Error processing: " + e.toString() + " SQL=" + sSql);
      }
    }
    else
    {
      System.out.println("Error connecting to DB: ");
    }

  }

  public indexer()
  {
  }


  
  
  public void reIndex(String arg)
{
  // Load the country object from the DesInventar (default) database
	dbConnection dbDefaultCon; 
	Connection dcon; 
	Statement dstmt; 
	ResultSet drset; 
	boolean bdConnectionOK=false; 
	// opens the Default database 
    Sys.getProperties();
	dbDefaultCon=new dbConnection();
	bdConnectionOK = dbDefaultCon.dbGetConnectionStatus();
	if (bdConnectionOK)
	{
	dcon=dbDefaultCon.dbGetConnection();
	
	// now it should read the names of the levels. 
	// It is done in the bean, so it can be reused as properties...
    country Region=new country();
    Region.scountryid=arg.toLowerCase();
	Region.getWebObject(dcon);
	// MUST return this connection!
	dbDefaultCon.close();
	// Declaration of default Dabatase variables available to the page 
	dbConnection dbCon=null;
	// this is just a shortcut, easier to remember
	int dbType=Region.ndbtype; 
	Connection con=null; 
	Statement stmt=null; 
	ResultSet rset=null; 
	boolean bConnectionOK=false; 
	// opens the database 
	dbCon=new dbConnection(Region.sdriver,Region.sdatabasename,Region.susername,Region.spassword);
	bConnectionOK = dbCon.dbGetConnectionStatus();
	if (bConnectionOK)
		{	
	    con = dbCon.dbGetConnection();
	    reIndex(con,Region.ndbtype,null);
		dbCon.close();
	  }
	else
		{
		System.out.println("Error opening Region database...");
		}
	}  // opening dB!!
	else
	{
		System.out.println("Error opening DesInventar default database...");  
	}
  }
  
  public static void main(String[] args)
  {
    indexer Indexer = new indexer();
    Indexer.reIndex(args[0]);
  }
}