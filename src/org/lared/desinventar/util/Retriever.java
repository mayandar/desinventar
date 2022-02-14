package org.lared.desinventar.util;

/**
 * @author Julio Serje
 *
 */
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class Retriever
{
  private int nRetrieverID=0;	
  private boolean bBusy = false;
  private int nFileSize = 0;

  private InputStream f_data = null;
  private FileOutputStream o_data = null;
  private URL urlActual = null;
  HttpURLConnection ucConnection=null;


  int nMaximumSize=200000000;    // two hundred megabytes!
  
  
  int nCurrentDebugLevel=0;
  
// constructor of the retriever. Gets a handle to its parent
// in order to be able to send a finished message.


  public boolean isBusy()
  {
    return bBusy;
  }

  public void setBusy()
  {
    bBusy=true;
  }

  public void setDebugLevel(int newLevel)
  {
	  nCurrentDebugLevel=newLevel;
  }
  
  public void debugMessage (int level, String sMessage)
  {
	  if (level<=nCurrentDebugLevel)
		  System.out.println(sMessage);
  }
  

  /**
   opens a remote URL file for reading
   */
private boolean open_file_remote(String sRemoteURL)
  {
    boolean ok;
    String strSeedUrl = new String(sRemoteURL.replace(" ", "%20"));

    ok = true;
    f_data = null;
    String sMimeType="text";

    if (ok)
      try
      {
    	  // CookieHandler.setDefault(SystemCookieHandler);
    	  urlActual = new URL(strSeedUrl);
    	  ucConnection=(HttpURLConnection) urlActual.openConnection();
    	  ucConnection.setInstanceFollowRedirects(false);
    	  ucConnection.setConnectTimeout(30000);  // thirty seconds to respond...
    	  int responseCode=ucConnection.getResponseCode();
    	  if (responseCode==200)
    	  {
        	  sMimeType=ucConnection.getContentType();
              f_data = ucConnection.getInputStream();    		    		  
    	  }	  
    	  else ok=false;
    	  
    	
        // f_data = urlActual.openStream();
        debugMessage(3, "[UPDATER] Retriever "+nRetrieverID+" opened stream..." + strSeedUrl+"  of mimeType "+sMimeType);
      }
      catch (Exception ioe)
      { // not logging this as an error - as it is a problem of the page or remote server
        debugMessage(0, "Retriever "+nRetrieverID+" ERROR [OpenStream]:" + ioe.getMessage() + " | " + ioe.toString());
        ok = false;
      }

    return ok;
  }

  /**
    opens a local file for writing
   */
  private boolean open_file_local(String strFileName)
  {
    boolean ok;

    ok = true;
    o_data = null;

    try
    {
      o_data = new FileOutputStream(strFileName);
      debugMessage(3, "Retriever "+nRetrieverID+" opened output stream..." + strFileName);
    }
    catch (Exception ioe)
    {
        ok = false;
    	debugMessage(0, "Retriever "+nRetrieverID+" ERROR[LOC]:" + ioe.getMessage());
    }

    return ok;
  }


  /**
   * reads and outputs a binary file (such as a PDF) that resides anywhere in the internet.
   * o_data is the output file, f_data is the remote url file
   */
  
  public boolean file2cache()
  {
    nFileSize=0;
    boolean ok=true;
    
    try
    {    	
    	byte[] buffer = new byte[4096];
    	int n=0;
    	while ((n = f_data.read(buffer))>0) // && nFileSize<nMaximumSize) 
    	{
    		o_data.write(buffer, 0, n);
    		nFileSize+=n;
    	}    	
    }
    catch (IOException e)
    {
    	ok=false;      
    	debugMessage(0, "Retriever "+nRetrieverID+" TRANSFER ERROR: reading input...");
    }
    catch (Exception ex)
    {
    	ok=false;      
    	debugMessage(0, "Retriever "+nRetrieverID+" TRANSFER EXCEPTION: writing cache output...");        	
    }
    catch (Error e)
    {
    	ok=false;      
    	debugMessage(0, "Retriever "+nRetrieverID+" TRANSFER CRITICAL ERROR: writing cache output...");        	
    }

    finally
    {
        try{ o_data.close(); } catch (Exception e1){}
        try{ f_data.close(); } catch (Exception e2){}

    }
    return ok;
  }

  
  
  
  /**
    Download update to temporary file in the cache from the internet. If there is an error, returns false, otherwise true.
    note: The cache directory is declared in parameters with the rest of platform dependent stuff
   */

  public boolean bCacheFileOK(String sURL, String sTempFile)
  {
    boolean retCode = false;
    if (retCode = open_file_remote(sURL))
        if (retCode = open_file_local(sTempFile))
        {
          debugMessage(3, "Retriever "+nRetrieverID+" transfering "+sURL+" to "+sTempFile);
          retCode=file2cache();
        }
    return retCode;
  }


	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		// TODO Auto-generated method stub
		
		Retriever  retriever=new Retriever();
		// downloads the html page that forces the re-generation of the ZIP file
		retriever.bCacheFileOK("https://www.desinventar.net/DesInventar/download_base.jsp?countrycode=tza", "/databases/tanzania/DI_export_page.html");

		// downloads the ZIP file itself
		retriever.bCacheFileOK("https://www.desinventar.net/DesInventar/download/DI_export_tza.zip", "/databases/tanzania/DI_export_tza.zip");

		
	}

}
