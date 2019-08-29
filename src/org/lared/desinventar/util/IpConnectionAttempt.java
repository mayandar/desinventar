package org.lared.desinventar.util;

import java.util.Calendar;

public class IpConnectionAttempt 
{
	  public java.util.Calendar  dAttemptTime = Calendar.getInstance();
	  public String sIPaddress="";
	  public int nretries=1;
	  
	  
	  public IpConnectionAttempt(String sIP)
	  {
		  sIPaddress=sIP;
	  }

}
