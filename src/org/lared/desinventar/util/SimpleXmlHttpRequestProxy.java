package org.lared.desinventar.util;
import javax.servlet.*;
import javax.servlet.http.*;

import sun.security.provider.Sun;

import java.io.*;
import java.net.*;
import java.util.*;

public class SimpleXmlHttpRequestProxy {

	boolean ok=true;
	URL urlActual=null;
	DataInputStream f_data;

	
	public String getUrl(HttpServletRequest request)
	{
		String sContent="";
		
//		 see if there is a  default request, and put all parameters
		String sParSep="?";
		String sProxyParams="";
		String sUrl="";
		URL urlActual=null;
		InputStream conn = null;
		InputStream f_data = null;

		
		for (Enumeration e=request.getParameterNames(); e.hasMoreElements(); )
			{
			String param= (String) e.nextElement();
			if ("url".equals(param))
			   sUrl=request.getParameter(param);
			else
				{
				String[] values= request.getParameterValues(param);
				for (int j=0; j<values.length; j++)
				  	{
				  	sProxyParams+= sParSep+param+"="+URLEncoder.encode(values[j]);
					sParSep="&";
					//System.out.println("<br>Parameter: "+param+" ,value="+values[j]); 
					}
				}	
			}
		// URL encode the parameters
		
		// we have a URL string and a parameter string
		// check protocol is there
		if (!sUrl.startsWith("http"))
		    sUrl="http://"+sUrl;
		// assemble full URL:
		sUrl+=sProxyParams;

	   sContent=openURL(sUrl);

       return sContent;
	}
	
	public void dumpSystemProps()
	{
		Properties prop=System.getProperties();
		
		String sp="";
		for (Enumeration e=prop.keys(); e.hasMoreElements(); )
		{
		String param= (String) e.nextElement();
		String value= (String) prop.getProperty(param);
		System.out.println( param+"="+value);
		}
		
		
	}
	
	private String openURL(String sUrl) 
	{
		String sContent="";
		
		//System.setProperty("sun.net.spi.nameservice.provider.0", "dns,sun");
		//System.setProperty("sun.net.spi.nameservice.nameservers", "80.10.246.130,81.253.149.10");
			
        
		try { 
			System.out.println("Connecting to Host..." + sUrl);
		      urlActual = new URL(sUrl);
		    }
		    catch (MalformedURLException ioe)
		    {
		    	System.out.println("ERROR: [bad URL]" + ioe.getMessage());
		      ok = false;
		    }


		    if (ok)
		      try
		      {
		        StringBuffer o_data=new StringBuffer();
		        
		        BufferedReader in = new BufferedReader(new InputStreamReader(urlActual.openStream()));

		        String inputLine;

		        try
		        	{
		        	while ((inputLine = in.readLine()) != null)
		        		o_data.append(inputLine);		        
		        	in.close();
		        	}
		        catch (IOException e)
		        	{
		        	System.out.println("TRANSFER ERROR: reading URL...");
		        	}
		        sContent=o_data.toString();

		      }
		      catch (IOException ioe)
		      {
		    	  // System.out.println("ERROR [OpenStream]:" + ioe.getMessage() + " | " +ioe.toString());
		    	  sContent= "ERROR [OpenStream]:" + ioe.getMessage() + " | " +ioe.toString();
		        ok = false;
		      }
		  return sContent;
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		SimpleXmlHttpRequestProxy proxy=new SimpleXmlHttpRequestProxy();
		proxy.openURL("https://www.desinventar.net/DesInventar/country_profile.jsp?countrycode=co");

	}

}
