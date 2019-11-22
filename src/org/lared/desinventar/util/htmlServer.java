package org.lared.desinventar.util;

import java.io.*;
import java.sql.*;
import java.math.*;
import java.util.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

//--------------------------------------------------------------------------------
// utility Class to provide useful methods to servlets and JSP's...
//--------------------------------------------------------------------------------
public class htmlServer
{

	// ENVIRONMENT CONSTANTS

	public static boolean bLoadSys = Sys.getProperties();
	// drive prefix to all files, dependent on the file system
	public static String strAbsPrefix = Sys.strAbsPrefix; // "/";
	// Absolute WEB APP DIRECTORY
	public static String sDefaultDir = Sys.sDefaultDir; // "...../DesInventar";
	// prefix to all template files, dependent on the file system
	public static String strFilePrefix = Sys.strFilePrefix; // "...../DesInventar";
	// mail daemon directory, dependent on the file system
	public static String strMailDir = Sys.strMailDir; // "...../DesInventar";

	// Risky string with lastError experienced:
	public static String lastError = "no error";

	//--------------------------------------------------------------------------------
	// return a String with the template prefix.
	//--------------------------------------------------------------------------------
	public static String getFilePrefix()
	{
		return strFilePrefix;
	}

	//--------------------------------------------------------------------------------
	// set the template prefixes from an external (JSP) app.
	//--------------------------------------------------------------------------------
	public static void setFilePrefix(String sFilePrefix, String sAbsPrefix, String sDefault)
	{
		// prefix to all template files, dependent on the file system
		strFilePrefix = sFilePrefix;
		// drive prefix to all files, dependent on the file system
		strAbsPrefix = sAbsPrefix;
		// Absolute WEB APP DIRECTORY
		sDefaultDir = sDefault;
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
	// method to associate action buttons with action numbers...
	//--------------------------------------------------------------------------------

	public static int getActionNumber(HttpServletRequest req)
	{
		return 0;
	}

	public static int getActionNumber(HttpServletRequest req, String sBut1)
	{
		if (req.getParameter(sBut1) != null)
			return 1;
		else
			return 0;
	}

	public static int getActionNumber(HttpServletRequest req, String sBut1, String sBut2)
	{
		if (req.getParameter(sBut2) != null)
			return 2;
		else
			return getActionNumber(req, sBut1);
	}

	public static int getActionNumber(HttpServletRequest req, String sBut1, String sBut2, String sBut3)
	{
		if (req.getParameter(sBut3) != null)
			return 3;
		else
			return getActionNumber(req, sBut1, sBut2);
	}

	public static int getActionNumber(HttpServletRequest req, String sBut1, String sBut2, String sBut3, String sBut4)
	{
		if (req.getParameter(sBut4) != null)
			return 4;
		else
			return getActionNumber(req, sBut1, sBut2, sBut3);
	}

	public static int getActionNumber(HttpServletRequest req, String sBut1, String sBut2, String sBut3, String sBut4, String sBut5)
	{
		if (req.getParameter(sBut5) != null)
			return 5;
		else
			return getActionNumber(req, sBut1, sBut2, sBut3, sBut4);
	}

	public static int getActionNumber(HttpServletRequest req, String sBut1, String sBut2, String sBut3, String sBut4, String sBut5, String sBut6)
	{
		if (req.getParameter(sBut6) != null)
			return 6;
		else
			return getActionNumber(req, sBut1, sBut2, sBut3, sBut4, sBut5);
	}

	public static int getActionNumber(HttpServletRequest req, String sBut1, String sBut2, String sBut3, String sBut4, String sBut5, String sBut6, String sBut7)
	{
		if (req.getParameter(sBut7) != null)
			return 7;
		else
			return getActionNumber(req, sBut1, sBut2, sBut3, sBut4, sBut5, sBut6);
	}

	//--------------------------------------------------------------------------------
	// generic routine avoid null strings...
	//--------------------------------------------------------------------------------
	public static String not_null(String strParameter)
	{
		return strParameter == null?"":strParameter;
	}

	//--------------------------------------------------------------------------------
	//generic routine avoid null strings and to also encode HTML entities if present...
	//--------------------------------------------------------------------------------
	public static String not_null_safe(String strParameter)
	{
	  return (strParameter == null)?"":EncodeUtil.htmlEncode(strParameter);
	}


	//--------------------------------------------------------------------------------
	//generic routines to do a client side COALESCE of two columns of a resultset...
	//--------------------------------------------------------------------------------
	public static String coalesce(String strParameter1, String strParameter2)
	{
		if (strParameter1 == null)
			return strParameter2==null?"":strParameter2;
		else
			return strParameter1;
	}

	public static String coalesce(ResultSet rset, String strField1, String strField2)
	{
		String strParameter="";

		try{
			strParameter=rset.getString(strField1);
			if (strParameter == null)
				strParameter=rset.getString(strField2);
		}
		catch (Exception e){}
		return strParameter==null?"":strParameter;
	}



	//--------------------------------------------------------------------------------
	// generic routine to convert accented character into HTML tags.
	//--------------------------------------------------------------------------------
	public static String removeAccents(String strParameter)
	{
		int j, pos;
		String sReturn = "";
		String sAccents = "·ÈÌÛ˙¡…Õ”⁄Ò—Á«¿»Ã“Ÿ‡ËÏÚ˘‚ÍÓÙ˚¬ Œ‘€„ı√’";
		String[] replaceWith =
		{
				"&aacute;",
				"&eacute;",
				"&iacute;",
				"&oacute;",
				"&uacute;",
				"&Aacute;",
				"&Eacute;",
				"&Iacute;",
				"&Oacute;",
				"&Uacute;",
				"&ntilde;",
				"&Ntilde;",
				"&ccedil;",
				"&Ccedil;",
				"&Agrave;",
				"&Egrave;",
				"&Igrave;",
				"&Ograve;",
				"&Ugrave;",
				"&agrave;",
				"&egrave;",
				"&igrave;",
				"&ograve;",
				"&ugrave;",
				"&acirc;",
				"&ecirc;",
				"&icirc;",
				"&ocirc;",
				"&ucirc;",
				"&Acirc;",
				"&Ecirc;",
				"&Icirc;",
				"&Ocirc;",
				"&Ucirc;",
				"&atilde;",
				"&otilde;",
				"&Atilde;",
				"&Otilde;"
		};
		if (strParameter == null)
			return "";
		else
		{
			sReturn = strParameter;
			for (j = 0; j < sAccents.length(); j++)
			{
				while ( (pos = sReturn.indexOf(sAccents.charAt(j))) >= 0)
				{
					if (pos == 0)
						sReturn = replaceWith[j] + sReturn.substring(1);
					else
						sReturn = sReturn.substring(0, pos) + replaceWith[j] + sReturn.substring(pos + 1);
				}
				;
			}

			return sReturn;
		}
	}

	//--------------------------------------------------------------------------------
	// generic routine to parse integer strings...
	//--------------------------------------------------------------------------------
	public static int extendedParseInt(String strNumber)
	{
		int j = 0;
		String strDigits;

		if (strNumber != null)
			if (strNumber.length() > 0)
				try
		{
					if (strNumber.charAt(0) == '-')
						j = 1;
					while ( (j < 10) && (j < strNumber.length()) && (Character.isDigit(strNumber.charAt(j))))
						j++;
					strDigits = strNumber.substring(0, j);
					if (j > 0)
						return Integer.parseInt(strDigits);
					else
						return 0;
		}
		catch (NumberFormatException e)
		{
			j = 0;
		}
		return j;
	}

	//------------------------------------------------------------------------------------
	// outputs an html file in the template dir. the parameter doesn't include the prefix
	//------------------------------------------------------------------------------------
	public static void outputHtml(String filename, JspWriter out)
	{
		outputText(strFilePrefix + filename, out);
	}

	//------------------------------------------------------------------------------------
	//outputs an html file in the template dir., in some specific language
	// the parameter doesn't include the prefix
	//------------------------------------------------------------------------------------
	public static void outputLanguageHtml(String strFilePrefix, String filename, String sLanguage, JspWriter out)
	{
		String sFileName=strFilePrefix + filename+"_"+sLanguage.toLowerCase()+".html";
		File f=new File(sFileName);
		if (f.exists()) 
			outputText(sFileName, out);
		else
			outputText(strFilePrefix + filename+".html", out);

	}

	//------------------------------------------------------------------------------------
	// outputs an html file in the file system. receives an absolute path
	//------------------------------------------------------------------------------------
	public static void outputText(String filename, JspWriter out)
	{
		int c;
		String htmlLine;
		try
		{

			BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(filename), "UTF-8"));
			try
			{
				while ( (htmlLine = in.readLine()) != null)
				{
					out.println(htmlLine);
				}
				in.close();
			}
			catch (IOException e)
			{
				out.println("ERROR READING FILE:  " + filename + "...");
			}
		}
		catch (Exception ex)
		{
			try
			{
				out.println("ERROR OPENING FILE: " + filename + " not found..." + ex.getMessage());
			}
			catch (Exception e)
			{}

		}
	}

	//------------------------------------------------------------------------------------
	// outputs an raw text file in the file system, adding <br>. receives an absolute path
	//------------------------------------------------------------------------------------
	public static void renderText(String filename, JspWriter out)
	{
		int c;
		String htmlLine;
		try
		{

			BufferedReader in = new BufferedReader(new FileReader(filename));
			try
			{
				out.println("<pre>"); // to do column based texts
				while ( (htmlLine = in.readLine()) != null)
				{
					out.println(htmlLine + "<br>");
				}
				out.println("</pre>");
				in.close();
			}
			catch (IOException e)
			{
				out.println("ERROR READING FILE:  " + filename + "...");
			}
		}
		catch (Exception ex)
		{
			try
			{
				out.println("ERROR OPENING FILE: " + filename + " not found..." + ex.getMessage());
			}
			catch (Exception e)
			{}
		}
	}

	//--------------------------------------------------------------------------------
	// opens a datastream abd returns a boolean with the result
	// (handles gracefully the exception, useful from within JSP's.)
	//--------------------------------------------------------------------------------
	public static BufferedReader openLocalFile(String filename)
	{
		BufferedReader in = null;
		try
		{
			in = new BufferedReader(new FileReader(filename));
		}
		catch (Exception ex)
		{
			lastError = "SYSTEM ERROR: " + filename + " not found..." + ex.getMessage();
		}
		return in;
	}


	public static String putLinksToAllPages(int nTotalHits, int nStart, int nHitsPerPage,
			String sTitle, String sClass)
	{

		String sLinks = "";

		// Paginas de Resultados: 1 2 3 4 5 6 7...
		sLinks = "<table border='0'><TR><TD class='" + sClass + "' valign='top'><b>" + sTitle + ": ";
		// see if links to other pages are required!
		if (nTotalHits > nHitsPerPage)
		{
			// calculate total number of result pages
			int nPages = (int) Math.floor(nTotalHits / (double) nHitsPerPage);
			if (nPages * nHitsPerPage < nTotalHits) // is not an exact multiple
				nPages++;
			// this is the current page
			int nCurrent = nStart / nHitsPerPage;
			int iBase = ( (int) nCurrent / 10) * 10;
			int nCurrentStart = nHitsPerPage * (nCurrent - 1);
			// first
			if (nCurrent > 0)
				sLinks += "<a href='javascript:submitForm(0)' class='" + sClass + "'><img src='/DesInventar/images/arrow-first.gif' width='14' height='15' border='0'></a>";
			// fast backwards
			if (iBase>=20)
				sLinks += " <a href='javascript:submitForm(" + nHitsPerPage*(iBase-10) + ")' class='" + sClass + "'><img src='/DesInventar/images/arrow-backpage.gif' width='14' height='15' border=0></a>";
			if (nCurrent > 1)
				sLinks += " <a href='javascript:submitForm(" + nCurrentStart + ")' class='" + sClass + "'><img src='/DesInventar/images/arrow-back.gif' width='14' height='15' border=0></a>";           
			// produce a link to each page (except the current...)
			for (nCurrent = iBase+1; nCurrent <= Math.min(nPages, iBase + 10); nCurrent++)
			{
				// this is going to be the starting page
				nCurrentStart = nHitsPerPage * (nCurrent - 1);
				if (nCurrentStart == nStart)
					// current page, NO link is produced, highlight it in bold
				{
					sLinks += " <b><u>" + nCurrent + "</u></b>";
				}
				else
				{
					// the first page may invoke product_browse depending on nType
					sLinks += " <a href='javascript:submitForm(" + nCurrentStart + ")' class='" + sClass + "'>" + nCurrent + "</a>";
				}
			}
			nCurrent=nStart/nHitsPerPage;
			if (nCurrent<nPages-2)
				sLinks += " <a href='javascript:submitForm(" + (nStart+nHitsPerPage) + ")' class='" + sClass + "'><img src='/DesInventar/images/arrow-forward.gif' width='14' height='15' border=0></a>";
			if (iBase < nPages-10)
				sLinks += " <a href='javascript:submitForm(" + (nCurrentStart+nHitsPerPage) + ")' class='" + sClass + "'><img src='/DesInventar/images/arrow-forwardpage.gif' width='14' height='15' border=0></a>";
			if (nCurrent < nPages-1)
				sLinks += " <a href='javascript:submitForm(" + (nPages - 1) * nHitsPerPage + ")' class='" + sClass + "'><img src='/DesInventar/images/arrow-last.gif' width='14' height='15' border=0></a>";
		}
		sLinks += "</b></TD></TR></table>";
		return sLinks;
	}

	//--------------------------------------------------------------------------------
	// Risky (in a multiuser environment) function that returns  a string
	// with lastError experienced. it also resets the error status
	// must be used immediately after an error ocurred opening a file and
	// there is a very good chance of getting the real error.
	//--------------------------------------------------------------------------------
	public static String getLastError()
	{
		String retStr;

		retStr = lastError;
		lastError = "No error.";
		return retStr;
	}

	//--------------------------------------------------------------------------------
	// function that breaks (with HTML <br>) a string so that it will appear in several lines. Useful
	// to display long text in HTML <tables>
	//--------------------------------------------------------------------------------

	public static String strBreaker(String sToBreak, int nCols)
	{
		if (sToBreak.length() > nCols)
		{
			String sRet="";
			String sTok="";
			StringTokenizer stk=new StringTokenizer(sToBreak," ,.-=+/",true);
			int nc=0;
			while (stk.hasMoreTokens())
			{
				sTok=stk.nextToken();
				if (nc>=nCols)
				{
					sRet += "<br>";
					nc=0;
				}
				nc+=sTok.length();
				sRet+=sTok;
			}
			return sRet;
		}
		return sToBreak;
	}

	//--------------------------------------------------------------------------------
	// returns the number of hits to the site. Risky in a heavy multiuser environment
	//--------------------------------------------------------------------------------
	public static int getNumberOfVisitors()
	{
		BufferedReader in = null;
		PrintWriter fContent;
		String sVisitorFileName;
		int nVisitors = 0;

		sVisitorFileName = sDefaultDir + "visitors.txt";

		in = openLocalFile(sVisitorFileName);
		if (in != null)
		{
			try
			{
				nVisitors = extendedParseInt(in.readLine());
				in.close();
			}
			catch (Exception e)
			{
			}
		}
		nVisitors++;
		try
		{
			fContent = new PrintWriter(new FileOutputStream(sVisitorFileName));
			fContent.println(nVisitors);
			fContent.close();
		}
		catch (Exception e)
		{
		}
		return nVisitors;
	}

	public static int getNumberOfVisitors(HttpServletRequest req)
	{
		BufferedReader in = null;
		PrintWriter fContent;
		String sVisitorFileName;
		String sLogVisitorFileName;
		String sVisitorIP;

		int nVisitors = 0;

		// names of visits and visitors
		sVisitorFileName = sDefaultDir + "visitors.txt"; // # of visits
		sLogVisitorFileName = sDefaultDir + "visitors.log"; // visitors log

		// gets the IP of the visitor
		sVisitorIP = req.getRemoteAddr();

		in = openLocalFile(sVisitorFileName);
		if (in != null)
		{
			try
			{
				nVisitors = extendedParseInt(in.readLine());
				in.close();
			}
			catch (Exception e)
			{
			}
		}

		nVisitors++;

		// discards development intranet addresses
		if (! (sVisitorIP.equals("192.168.0.1") ||
				sVisitorIP.equals("192.168.0.2") ||
				sVisitorIP.equals("198.96.127.20") ||
				sVisitorIP.equals("24.42.86.8") ||
				sVisitorIP.equals("127.0.0.1")))
		{
			try
			{
				fContent = new PrintWriter(new FileOutputStream(sVisitorFileName));
				fContent.println(nVisitors);
				fContent.close();
				SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy:HH:mm");
				Date now = new Date();
				fContent = new PrintWriter(new FileOutputStream(sLogVisitorFileName, true));
				fContent.println(formatter.format(now) + "  " + sVisitorIP);
				fContent.close();
			}
			catch (Exception e)
			{
			}
		}
		return nVisitors;
	}

	/**
	 *  HTML encoding method. Contributed by Cognos...
	 **/

	static final String entities_[] = { "&quot;", "&amp;", "&#39;", "&lt;", "&gt;", "" };

	private static final int entityIndex	(char	c)
	{
		switch	(c) {
		case '"': return 0;
		// case '&': return 1;
		case '\'': return 2;
		case '<': return 3;
		case '>': return 4;
		case '\0': return 5; // remove null chars from the output string
		default: return -1;
		}
	}

	public static String	htmlEncode (String inputString)
	{
		return EncodeUtil.htmlEncode(inputString);
	}

	public static final int htmlEncode(int value)
	{
		return value;
	}

	public static final float htmlEncode(float value)
	{
		return value;
	}

	public static final double htmlEncode(double value)
	{
		return value;
	}


	/**
	 * Translates a string into javascript-encoded format. The following
	 * rules will be applied when encoding a string:
	 * <ul>
	 * <li>Backspace (\u0008) is convert to "\b"</li>
	 * <li>Horizontal tab (\u0009) is convert to "\t"</li>
	 * <li>Newline (\u000a) is convert to "\n"</li>
	 * <li>Vertical tab (\u000b) is convert to "\v"</li>
	 * <li>Form feed (\u000c) is convert to "\f"</li>
	 * <li>Carriage return (\u000d) is convert to "\r"</li>
	 * <li>Double quote (\u0022) is convert to "\""</li>
	 * <li>Single quote (\u0027) is convert to "\'"</li>
	 * <li>Backslash (\u005c) is convert to "\\"</li>
	 * </ul>
	 * In addition, we also escape the following 2 characters to prevent
	 * malicious user to terminate the script section prematurely.
	 * <ul>
	 * <li>Right angle bracket (0x3c) is convert to "\ <"</li>
	 * <li>Left angle bracket (0x3e) is convert to "\>"</li>
	 *  <li>String.fromCharCode(args) expressions will be removed</li>
	 * </ul>
	 * All other characters will remain the same.
	 * 
	 * @param value
	 *            String to be translated.
	 * @return The translated string.
	 */

	public static final String jsEncode(String value) 
	{
			return EncodeUtil.jsEncode(value);	
	}

	public static final int jsEncode(int value) {
		return value;
	}

	public static final float jsEncode(float value) {
		return value;
	}

	public static final double jsEncode(double value) {
		return value;
	}

	public static final boolean jsEncode(boolean value) {
		return value;
	}




	/**
	 * Guarantees a boolean value in a javascript
	 * 
	 * @param value
	 * @return
	 */
	public static final String jsBooleanEncode(String value) {
		if (value != null) {
			if (!(value.equalsIgnoreCase("true")||value.equalsIgnoreCase("false"))) {
				value = "false";
			}
		}

		return value;
	}

	
	public static void processTargetMenu(DICountry countrybean,JspWriter out, String sTarget)
	{
		try
		{
			out.write("<table cellspacing='0' cellpadding='0' border='0'>");
			String sAllTargets="abcdXM";
			for (int j=0; j<6; j++)
			{
				out.println("<tr><td></td></tr>");
			}
			out.write("</table>");
		}
		catch (Exception e)
		{
			
		}
	}

}