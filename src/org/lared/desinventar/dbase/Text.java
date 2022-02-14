package org.lared.desinventar.dbase;

import java.util.*;
import java.io.*;

public class Text
{
	/**
	* Replace all occurences of a with b.
	*
	* @param s original string.
	*
	* @param a string to change.
	*
	* @param b replacement string.
	*
	* @return string with replacements.
	*/
	static public String replace(String s, String a, String b)
	{
		// If both parts of the replacement are just 1 char
		// use the String method.
		if (a.length() == 1 && b.length() == 1)
		{
			return s.replace(a.charAt(0), b.charAt(0));
		}

		// Otherwise do it the long way.

		int idx;
		int span = a.length();
		int lidx = 0;
		StringBuffer sb = new StringBuffer();

		while ((idx = s.indexOf(a, lidx)) >= 0)
		{
			// Copy where we started to this point.
			sb.append(s.substring(lidx, idx));
			sb.append(b);
			lidx = idx + span;
		}

		if (lidx == 0)	// Optimization - most strings won't need replacement.
			return s;

		sb.append(s.substring(lidx));

		return sb.toString();
	}

	/**
	* Split a line into an array based on white space.
	*
	* @param s  String to split
	*
	* @return array of strings.
	*/
	static public String [] split(String s)
	{
		return split(s, " \t\n\r");
	}

	/**
	* Split a line into an array based on the delimiter.
	*
	* @param s  String to split
	* @param delim  list of delimiters
	* @return array of strings.
	*/
	static public String [] split(String s, String delim)
	{
		StringTokenizer st = new StringTokenizer(s, delim);
		int count = st.countTokens();

		String r[] = new String[count];

		for (int i = 0; st.hasMoreTokens(); i++)
		{
			r[i] = st.nextToken();
		}

		return r;
	}

	// Hex conversion.

	/**
	* Convert a byte buffer to a hex string.
	*
	* @param buf Byte array.
	* @return Hexadecimal representation.
	*/
	public static String toHexString(byte buf[])
	{
		final char hex[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
		StringBuffer sb = new StringBuffer();
		int buflen = buf.length;
		for (int i = 0; i < buflen; i++)
		{
			sb.append(hex[(buf[i] >>> 4) & 0xf]).append(hex[buf[i] & 0xf]);
		}
		return sb.toString();
	}

	/**
	* Dump out the current call stack to stdout.
	*/
	public static void dumpStack()
	{
		java.io.CharArrayWriter ca = new java.io.CharArrayWriter();
		java.io.PrintWriter pwca = new java.io.PrintWriter(ca);

		(new Throwable()).printStackTrace(pwca);

		System.out.println(ca.toString() + "\n");
	}

	/**
	* Format a number to the given width, right justfied, blank filled.
	*
	* @param n Number to format.
	* @param width Width of spaces + number.
	* @return formatted number.
	*/
	public static String format(int n, int width)
	{
		StringBuffer num = new StringBuffer(Integer.toString(n));

		int spaces = width - num.length();
		for (int i = 0; i < spaces; i++)
			num.insert(0, ' ');

		return num.toString();
	}

	/**
	* Dump the binary contents of a byte array.
	*
	* @param buf Byte array.
	* @param start Start position.
	* @param length Length to dump from start position.
	*
	* @return string with hex / char dump.
	*/
	public static String dump(byte buf[], int start, int length)
	{
		return new ByteIterator(buf, false).dump(start, length);
	}

	// Telnet EOL stuff.
	private static final char CRc = (char)0x0d;
	private static final char LFc = (char)0x0a;
	private static final char EOLc[] = { CRc, LFc};
	private static final String CR = "" + CRc;
	private static final String LF = "" + LFc;
	private static final String EOL = new String(EOLc);	// Telnet EOL.
	/**
	* Fix random \n's and \r's that appear in lines of text so they strictly
	* follow the Telnet EOL sequence and formatting isn't messed up either.
	*
	* @param text Incoming text.
	* @return corrected text.
	*/
	public static String fixEOL(String text)
	{
		final int CRi = 1;	// CR
		final int LFi = 2;	// LF
		final int NNi = 0;	// Neither CR nor LF.

		// Adust the text so that \r's, \n's and any combination make sense
		// in the Telnet EOL protocol.
		StringTokenizer st = new StringTokenizer(text, "\r\n", true);

		StringBuffer sb = new StringBuffer();
		int state = NNi;
		int lastState = NNi;

		String tok = "";
		while (st.hasMoreTokens())
		{
			tok = st.nextToken();

			if (tok.equals(LF))
				state = LFi;
			else if (tok.equals(CR))
				state = CRi;
			else
				state = NNi;

			if (lastState == CRi)
			{
				// Is it CR NN?
				if (state == NNi)
					sb.append(EOL).append(tok);
				// Is it CR CR?
				if (state == CRi)
					sb.append(EOL);
				// Is it CR LF?
				if (state == LFi)
				{
					// Treat a CRLF as an EOL and it's all complete.
					sb.append(EOL);
					lastState = NNi;
					continue;
				}
			} else if (lastState == LFi)
			{
				// Is it  LF NN?
				if (state == NNi)
					sb.append(EOL).append(tok);
				// Is it LF CR?
				if (state == CRi)
				{
					// Treat a CRLF as an EOL and it's all complete.
					sb.append(EOL);
					lastState = NNi;
					continue;
				}
				// Is it LF LF?
				if (state == LFi)
					sb.append(EOL);
			} else if (lastState == NNi)
			{
				// Is it  NN NN?
				if (state == NNi)
					sb.append(tok);
				// Is it NN CR?
				if (state == CRi)
						// Do nothing.
				// Is it NN LF?
				if (state == LFi)
					;	// Do nothing.
			}
			lastState = state;
		}

		sb.append(EOL);

		return sb.toString();
	}

	/**
	* Is this an ISBN number?
	* https://www.ee.unb.ca/tervo/ee4243/isbn4243.htm
	*
	* @param str String containing the ISBN number including any dashes, etc.
	*/
	public static boolean isISBN(String str)
	{
		int i;
		int digits = 0;
		final int zero = Character.getNumericValue('0');
		
		// ISBN numbers is the total = 0 mod 11.
		// Each digit has it's multiplier.
		if (digits != 10)
			return false;
		
		int m = 10;
		int sum = 0;
		for (i = 0; i < str.length(); i++)
		{
			char c = str.charAt(i);
			if (Character.isDigit(c))
			{
				int cval = Character.getNumericValue(c) - zero;
				sum += cval * m--;
				digits++;
			} else if (c == 'X' || c == 'x') {	// As it turns out we can never read the 'X'
				sum += 10;
				digits++;
			}
		}
		
		if (digits != 10)
			return false;	// Not enough digits to be an ISBN number.

		return (sum % 11 == 0);
	}
	
	/**
	* Decode an octal string.
	* @param octal Octal string in the form: "\001\004\000\006\r "
	* @return byte array.
	* @throws NumberFormatException if there is a problem parsing the string.
	*/
	public static byte [] decodeOctal(String octal) throws NumberFormatException
	{
		ByteArrayOutputStream bais = new ByteArrayOutputStream();

		int octalLen = octal.length();
		String s;
		for (int i = 0; i < octalLen; i++)
		{
			char c = octal.charAt(i);
//System.out.println("CharAt(" + i + ")=[" + c + "]");
			if (c == '\\')
			{
				c = octal.charAt(++i);
				// Looking at an octal or escape value
				switch(c) {
					case '0':
					case '1':
					case '2':
					case '3':
					case '4':
					case '5':
					case '6':
					case '7':
						s = octal.substring(i, i + 3);
//System.out.println("  Parsing [" + s + "]");
						bais.write(Integer.parseInt(s, 8) & 0xff);
						i += 2;
						break;
					case 'b':
						bais.write(8);
						break;
					case 't':
						bais.write(10);
						break;
					case 'n':
						bais.write(10);
						break;
					case 'f':
						bais.write(12);
						break;
					case 'r':
						bais.write(13);
						break;
					default:
						throw new NumberFormatException("Unexpected character [" + c + "]");
					}
			} else {
				// Get the value of the character.
				bais.write((int)c);
			}
		}

		try {
			bais.flush();
		} catch (IOException ioe) {
			throw (NumberFormatException) new NumberFormatException().initCause(ioe);
		}
		return bais.toByteArray();
	}
	
	/**
	* Turn a time in milliseconds into a more pleasant display of hours, minutes, and seconds
	* as appropriate.
	*
	* @param millis Milliseconds of elapsed time.
	* @return String representing more readable time.
	*/
	private static String getTimeString(long millis)
	{
		// build the format string backwards.
		long milliPart;
		long secondPart;
		long minutePart;
		long hourPart;
		long dayPart;

		milliPart = millis % 1000;
		millis /= 1000;
		secondPart = millis % 60;
		millis /= 60;
		minutePart = millis % 60;
		millis /= 60;
		hourPart = millis % 60;
		millis /= 60;
		dayPart = millis;

		String disp = "";

		if (dayPart > 0)
			disp += dayPart + "d ";
		if (dayPart > 0 || hourPart > 0)
		{
			if (hourPart < 10)
				disp += "0";
			disp += hourPart + ":";
		}
		if (dayPart > 0 || hourPart > 0 || minutePart > 0)
		{
			if (minutePart < 10)
				disp += "0";
			disp += minutePart + ":";
		}
		if (secondPart < 10)
			disp += "0";
		disp += secondPart + ".";
		if (milliPart < 100)
			disp += "0";
		if (milliPart < 10)
			disp += "0";
		disp += milliPart;

		return disp;
	}
}

