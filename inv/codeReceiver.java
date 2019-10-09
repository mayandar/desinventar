/*
    A basic extension of the java.applet.Applet class
 */

import java.awt.*;
import java.applet.*;
import java.io.*;
import java.net.*;

public class codeReceiver extends Applet
{

    private String baseURL;
    private String palabra;
    private InputStream conn=null;
    private DataInputStream f_data=null;
    private URL urlActual=null;
    
    private int nCodes=0;                   // number of codes in the vector
    private String[] sCodes;                // vector of codes
    private String[] sNames;                // vector of codes

    private String sCountryCode="co";
    private String sGeoCode="05";
    private int nLevel=1;
    private int i,j;
    
    

 // -----------------------------------------------------
 // Public interface methods
 // ------------------------------------------------------


   // Pass the country code
   public int sSetCountryCode(String sCountry)
    {
        sCountryCode=sCountry;
        return 0;
    }

   // Pass the geographic code to get childrens of
   public int sSetLevelCode(String sCode)
    {
        sGeoCode=sCode;
        return 0;
    }

   // pass the level to query in
   public int sSetLevel(String sLevel)
    {
        nLevel=Integer.parseInt(sLevel);
        return nLevel;
    }

    // returns the codebase of the URL. to debug...
    public String sGetCodeBase()
    {
        return baseURL;
    }

    // returns the number of codes received
    public String sGetCodeNumber()
    {
        return Integer.toString(nCodes);
    }

    // returns the Nth code
    public String sGetCode(int n)
    {
        return sCodes[n];
    }

    // returns the Nth name
    public String sGetName(int n)
    {
        return sNames[n];
    }


    // returns the Nth name
    public int startTransfer()
    {
        // debugMessage("CALLING: "+baseURL+"GeocodeServer?country="+sCountryCode+"&code="+sGeoCode+"&level="+nLevel);
        if (open_file(baseURL+"GeocodeServer?country="+sCountryCode+
                                        "&code="+sGeoCode+"&level="+nLevel))
            {
        	// debugMessage("Opened URL, reading codes");
		read_codes();
      	}

        
        return 0;
    }
        
    // -----------------------------------------------------
    // utility method to remove returns ans linefeeds
    // ------------------------------------------------------
    private String strRemoveLfSp(String strPalabra)
    {
        while ((strPalabra.charAt(strPalabra.length()-1)=='\r') ||
               (strPalabra.charAt(strPalabra.length()-1)=='\n'))
            strPalabra=strPalabra.substring(1,strPalabra.length()-1);
        return strPalabra.trim();
    }


    // -----------------------------------
    // opens a remote URL file for reading
    // -----------------------------------
    private boolean open_file(String strSeedUrl)
    {
     boolean ok;

     ok=true;
     f_data=null;
     try
        {
            urlActual=new URL(strSeedUrl);
            // debugMessage("Connected to Host..."+strSeedUrl);
        }
        catch ( MalformedURLException ioe)
            {
                // lblStatus.setText("ERROR: [bad URL]"+ioe.getMessage());
                // debugMessage("ERROR: [bad URL]"+ioe.getMessage());
                ok=false;
            }

        if (ok)
           try
            {
                conn=urlActual.openStream();
                // debugMessage("opened stream..."+strSeedUrl);
            }
         catch (IOException ioe)
            {
            // lblStatus.setText("ERROR [OIS]:"+ioe.getMessage());
            // debugMessage("ERROR [OIS]:"+ioe.getMessage());
            ok=false;
            }

    if (ok)
        f_data=new DataInputStream(new BufferedInputStream(conn));
    return ok;
    }
    
    
    // -----------------------------------
    // reads the codes stream
    // -----------------------------------
    private void read_codes()
    {
        try
        {
            do
                {
                palabra=strRemoveLfSp(f_data.readLine());
                }
            while (!palabra.equals("<codes>"));
            
            // gets the total number of codes/names
            palabra=strRemoveLfSp(f_data.readLine());
            // debugMessage("DOCS: no. of docs="+palabra);
            nCodes=Integer.parseInt(palabra);
            // allocates the memory structures needed
            sCodes=new String[nCodes + 2];
            sNames=new String[nCodes + 2];
            // and loads the passwords array
            for (j=1; j<=nCodes; j++)
                {
                    sCodes[j]=strRemoveLfSp(f_data.readLine());
                    sNames[j]=sCodes[j].substring(sCodes[j].indexOf("@")+1);
                    sCodes[j]=sCodes[j].substring(0,sCodes[j].indexOf("@"));
                }
            f_data.close();
            
        }
         catch (IOException ioe)
            {
            // lblStatus.setText("Error reading: "+ioe.getMessage());
            }
    }



  public void init()
	{
	super.init();
	setLayout(null);
	addNotify();
	resize(4,4);
      // Get the calling URL
      baseURL=getCodeBase().toString();
      // removes everything after /english or /spanish
      int pos = baseURL.indexOf("english");
      if (pos<1)
	   pos = baseURL.indexOf("spanish");
	  baseURL=baseURL.substring(0,pos);
      }

}
