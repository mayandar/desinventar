package org.lared.desinventar.util;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

public class FailedConnectionsByIP 
{
	public static int TimeWindow=-30;  // minutes

	public static ArrayList<IpConnectionAttempt> failures=new ArrayList<IpConnectionAttempt>(); 

	
	public static String getClientIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

	
	public static int newFailure(HttpServletRequest request)
	{
		String sIP=getClientIpAddr(request);
		return newFailure(sIP);
		
	}
	
	public static int newFailure(String sIP)
		{
			int ntries=0;
		if (sIP == null)
			return 0;
		// looks for idle connections. Max idle time=2 minutes...
		Calendar  dNow = Calendar.getInstance();
		// 30 minutes
		dNow.add(Calendar.MINUTE , TimeWindow);

		synchronized (failures)
		{
			int nEntries=failures.size();
			// this loop looks for the corresponding entry and also cleans the array of old entries 
			// to avoid unnecessary growth
			for (int j=nEntries-1; j>=0; j--)
			{
				IpConnectionAttempt failure =failures.get(j);
				if (sIP.equals(failure.sIPaddress))
				{
					if (dNow.before(failure.dAttemptTime))
					{
						// new failure in the same time window
						ntries=failure.nretries++;
					}
					else
					{
						// restart failure count in new time window
						ntries=failure.nretries=1;
					}
				failure.dAttemptTime= Calendar.getInstance();					
					
				}
				else
					if (dNow.after(failure.dAttemptTime))
					{
						failures.remove(j);
					}
			}
			if (ntries==0) // did not find the element
			{
				// start failure count in current time window
				IpConnectionAttempt failure =new IpConnectionAttempt(sIP);
				failures.add(failure);				
				ntries=1;
			}
		}
		return ntries;
	}
}
