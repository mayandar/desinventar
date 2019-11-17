package org.lared.desinventar.util;

import java.util.HashMap;

public class EncodeUtil {

	/**
	 * Which ascii characters may be sent in HTML without escaping
	 */
	public static String htmlEncode_simple(String src) {
		StringBuffer result = new StringBuffer();

		int length = (src == null) ? 0 : src.length();
		for (int i = 0; i < length; i++) {
			int ch = src.charAt(i);

			// '"' is dec 34. '&' is dec 38. '<' os dec 60. '>' is dec 62.
			//if ((ch == 34) || (ch == 38) || (ch == 60) || (ch == 62)) {
			//    result.append("&#" + ch + ";");
			if (ch == '\'')
				result.append("&#" + ch + ";");

			//if (ch == '&') {
			//   result.append("&amp");
			/*} else*/

			if (ch == '<') {
				result.append("&lt;");
			} else if (ch == '>') {
				result.append("&gt;");
			} else if (ch == '"') {
				result.append("&quot;");
				//} else if (ch == ' ') {
				//  result.append("&nbsp;");
			} else {
				result.append((char) ch);
			}
		}
		return result.toString();
	}

	public static String  htmlDecode(String src)    {
		StringBuffer result = new StringBuffer();
		int length = 0;
		if (src != null) {
			length = src.length();
		} else {
			return src;
		}
		for (int i = 0; i < length; i++) {
			int ch = src.charAt(i);
			if (ch != '&') {
				result.append((char) ch);
			} else if (i < length-1) {
				i++;
				ch = src.charAt(i);
				if ((ch == '#') && (i < length-1)) {
					i++;
					ch = src.charAt(i);
					StringBuffer encodedChar = new StringBuffer();
					while ((i<length-1) && (ch != ';')) {
						encodedChar.append((char) ch);
						i++;
						ch = src.charAt(i);
					}
					try {
						int cInt = Integer.valueOf(encodedChar.toString()).intValue();
						//same as encode
						if ((cInt == 34) || (cInt == 38) || (cInt == 60) || (cInt == 62)) {
							result.append((char) cInt);
						} else {
							result.append('&');
							result.append(encodedChar.toString());
						}
					} catch (NumberFormatException e) {
						result.append('&');
						result.append(encodedChar.toString());
					}
				} else {
					result.append('&');
					result.append((char) ch);
				}
			}
		}
		return result.toString();
	}

	/**
	 * remove quotes for a very light HTML encoding
	 */
	public static String htmlLightEncode(String src) {

		if (src==null)
			return "";
		if (src.indexOf("\"")<0)
			return src;

		StringBuffer result = new StringBuffer();

		int length = src.length();
		for (int i = 0; i < length; i++) {
			int ch = src.charAt(i);
			if (ch == '"') 
				result.append("&quot;");
			else 
				result.append((char) ch);
		}
		return result.toString();
	}

	/**
	 * remove ALL HTML tags and convert double quotes for a very light HTML encoding
	 */

	public static String htmlRemoveEncode(String src) {

		if (src==null)
			return "";
		if (src.indexOf("<")<0)
			return src;

		StringBuffer result = new StringBuffer();

		int length = src.length();
		boolean inTag=false;          
		for (int i = 0; i < length; i++) {
			int ch = src.charAt(i);

			if (inTag){
				if (ch == '>')
					inTag=false;
			}
			else {
				if (ch == '<'){
					inTag=true;  
				} else 
					if (ch == '"') 
						result.append("&quot;");
					else 
						result.append((char) ch);
			}
		}
		return result.toString();
	}



	public static String xmlEncode(String inData)
	{
		//TODO: Use the fast version of this.

		//return null, if null is passed as argument
		if(inData == null)
			return null;

		//if no special characters, just return
		//(for optimization. Though may be an overhead, but for most of the
		//strings, this will save time)
		if((inData.indexOf('&') == -1)
				&& (inData.indexOf('<') == -1)
				&& (inData.indexOf('>') == -1)
				&& (inData.indexOf('\'') == -1)
				&& (inData.indexOf('\"') == -1))
		{
			return inData;
		}

		//get the length of input String
		int length = inData.length();
		//create a StringBuffer of double the size (size is just for guidance
		//so as to reduce increase-capacity operations. The actual size of
		//the resulting string may be even greater than we specified, but is
		//extremely rare)
		StringBuffer buffer = new StringBuffer(2 * length);

		char charToCompare;
		//iterate over the input String
		for(int i=0; i < length; i++)
		{
			charToCompare = inData.charAt(i);
			//if the ith character is special character, replace by code
			if(charToCompare == '&')
			{
				buffer.append("&amp;");
			}
			else if(charToCompare == '<')
			{
				buffer.append("&lt;");
			}
			else if(charToCompare == '>')
			{
				buffer.append("&gt;");
			}
			else if(charToCompare == '\"')
			{
				buffer.append("&quot;");
			}
			else if(charToCompare == '\'')
			{
				buffer.append("&apos;");
			}
			else
			{
				buffer.append(charToCompare);
			}
		}

		//return the encoded string
		return buffer.toString();
	}

	public static String xmlDecode(String inData)
	{
		//return null, if null is passed as argument
		if(inData == null)
			return null;

		//if no special characters, just return
		//(for optimization. Though may be an overhead, but for most of the
		//strings, this will save time)
		if((inData.indexOf("&amp;") == -1)
				&& (inData.indexOf("&lt;") == -1)
				&& (inData.indexOf("&gt;") == -1)
				&& (inData.indexOf("&quot;") == -1)
				&& (inData.indexOf("&apos;") == -1))
		{
			return inData;
		}

		//get the length of input String
		int length = inData.length();
		//create a StringBuffer
		StringBuffer buffer = new StringBuffer(length);

		char charToCompare;
		//iterate over the input String
		for(int i=0; i < length; i++)
		{
			charToCompare = inData.charAt(i);
			//if the ith character is special character, check for code
			if (charToCompare == '&') {
				if((length > i+4) && inData.substring(i,i+5).equals("&amp;"))
				{
					buffer.append('&');
					i += 4;
				}
				else if ((length > i+3) && inData.substring(i,i+4).equals("&lt;"))
				{
					buffer.append('<');
					i += 3;
				}
				else if ((length > i+3) && inData.substring(i,i+4).equals("&gt;"))
				{
					buffer.append('>');
					i += 3;
				}
				else if ((length > i+5) && inData.substring(i,i+6).equals("&quot;"))
				{
					buffer.append('"');
					i += 5;
				}
				else if ((length > i+5) && inData.substring(i,i+6).equals("&apos;"))
				{
					buffer.append('\'');
					i += 5;
				}

				else
				{
					buffer.append(charToCompare);
				}
			} else {
				buffer.append(charToCompare);
			}

		}

		//return the encoded string
		return buffer.toString();
	}

	public static final String jsEncode(String value) {
		if (value == null) 
			return "";

		// makes sure hidden injection code is removed first
		value =jsNoQuotesEncode( value);

		// roughly estimate the size...
		// assuming half of the characters need to be encoded.
		int rsize = value.length() * 2;
		StringBuffer sbuf = new StringBuffer(rsize);

		for (int i = 0; i < value.length(); i++) {
			char x = value.charAt(i);
			switch (x) {
			case 0x0008 : // backspace
				sbuf.append("\\b");
				break;
			case 0x0009 : // horizontal tab
				sbuf.append("\\t");
				break;
			case 0x000a : // newline
				sbuf.append("\\n");
				break;
			case 0x000b : // vertical tab
				sbuf.append("\\v");
				break;
			case 0x000c : // form feed
				sbuf.append("\\f");
				break;
			case 0x000d : // carriage return
				sbuf.append("\\r");
				break;
			case 0x0022 : // double quote
				sbuf.append("\\\"");
				break;
			case 0x0027 : // single quote
				sbuf.append("\\\'");
				break;
			case 0x005c : // backslash
				sbuf.append("\\\\");
				break;
			case 0x003c : // left angle bracket
				sbuf.append("\\<");
				break;
			case 0x003e : // right angle bracket
				sbuf.append("\\>");
				break;
			default :
				sbuf.append(x);
				break;
			}
		}
		return sbuf.toString();
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
	 * Validates a string not to contain XSS injection code.
	 * rules will be applied when validating a string:
	 * <ul>
	 * <li>commas (statement terminator) will be removed</li>
	 * <li>String.fromCharCode(args) expressions will be removed "\t"</li>
	 * All other characters will remains the same.
	 *
	 * @param value
	 *            String to be validated.
	 * @return The translated string.
	 */

	public static final String jsNoQuotesEncode(String value) {
		int pos=-1;

		if (value != null) {
			if ((pos = value.indexOf("String.fromCharCode"))>0) {
				value = value.substring(0,pos);
			}
		}

		return value;
	}

	public static final String jsNoQuotesEncode(StringBuffer value) {
		if (value != null) {
			return jsNoQuotesEncode(value.toString());
		} else {
			return null;
		}
	}

	public static final int jsNoQuotesEncode(int value) {
		return value;
	}

	public static final float jsNoQuotesEncode(float value) {
		return value;
	}

	public static final double jsNoQuotesEncode(double value) {
		return value;
	}

	public static final boolean jsNoQuotesEncode(boolean value) {
		return value;
	}



	private static final HashMap<Character, String> htmlEncodeChars = new HashMap<Character, String>();

	static
	{

		// Special characters for HTML
		htmlEncodeChars.put('\u0026', "&amp;");
		htmlEncodeChars.put('\u003C', "&lt;");
		htmlEncodeChars.put('\u003E', "&gt;");
		htmlEncodeChars.put('\u0022', "&quot;");

		htmlEncodeChars.put('\u0152', "&OElig;");
		htmlEncodeChars.put('\u0153', "&oelig;");
		htmlEncodeChars.put('\u0160', "&Scaron;");
		htmlEncodeChars.put('\u0161', "&scaron;");
		htmlEncodeChars.put('\u0178', "&Yuml;");
		htmlEncodeChars.put('\u02C6', "&circ;");
		htmlEncodeChars.put('\u02DC', "&tilde;");
		htmlEncodeChars.put('\u2002', "&ensp;");
		htmlEncodeChars.put('\u2003', "&emsp;");
		htmlEncodeChars.put('\u2009', "&thinsp;");
		htmlEncodeChars.put('\u200C', "&zwnj;");
		htmlEncodeChars.put('\u200D', "&zwj;");
		htmlEncodeChars.put('\u200E', "&lrm;");
		htmlEncodeChars.put('\u200F', "&rlm;");
		htmlEncodeChars.put('\u2013', "&ndash;");
		htmlEncodeChars.put('\u2014', "&mdash;");
		htmlEncodeChars.put('\u2018', "&lsquo;");
		htmlEncodeChars.put('\u2019', "&rsquo;");
		htmlEncodeChars.put('\u201A', "&sbquo;");
		htmlEncodeChars.put('\u201C', "&ldquo;");
		htmlEncodeChars.put('\u201D', "&rdquo;");
		htmlEncodeChars.put('\u201E', "&bdquo;");
		htmlEncodeChars.put('\u2020', "&dagger;");
		htmlEncodeChars.put('\u2021', "&Dagger;");
		htmlEncodeChars.put('\u2030', "&permil;");
		htmlEncodeChars.put('\u2039', "&lsaquo;");
		htmlEncodeChars.put('\u203A', "&rsaquo;");
		htmlEncodeChars.put('\u20AC', "&euro;");

		// Character entity references for ISO 8859-1 characters
		htmlEncodeChars.put('\u00A0', "&nbsp;");
		htmlEncodeChars.put('\u00A1', "&iexcl;");
		htmlEncodeChars.put('\u00A2', "&cent;");
		htmlEncodeChars.put('\u00A3', "&pound;");
		htmlEncodeChars.put('\u00A4', "&curren;");
		htmlEncodeChars.put('\u00A5', "&yen;");
		htmlEncodeChars.put('\u00A6', "&brvbar;");
		htmlEncodeChars.put('\u00A7', "&sect;");
		htmlEncodeChars.put('\u00A8', "&uml;");
		htmlEncodeChars.put('\u00A9', "&copy;");
		htmlEncodeChars.put('\u00AA', "&ordf;");
		htmlEncodeChars.put('\u00AB', "&laquo;");
		htmlEncodeChars.put('\u00AC', "&not;");
		htmlEncodeChars.put('\u00AD', "&shy;");
		htmlEncodeChars.put('\u00AE', "&reg;");
		htmlEncodeChars.put('\u00AF', "&macr;");
		htmlEncodeChars.put('\u00B0', "&deg;");
		htmlEncodeChars.put('\u00B1', "&plusmn;");
		htmlEncodeChars.put('\u00B2', "&sup2;");
		htmlEncodeChars.put('\u00B3', "&sup3;");
		htmlEncodeChars.put('\u00B4', "&acute;");
		htmlEncodeChars.put('\u00B5', "&micro;");
		htmlEncodeChars.put('\u00B6', "&para;");
		htmlEncodeChars.put('\u00B7', "&middot;");
		htmlEncodeChars.put('\u00B8', "&cedil;");
		htmlEncodeChars.put('\u00B9', "&sup1;");
		htmlEncodeChars.put('\u00BA', "&ordm;");
		htmlEncodeChars.put('\u00BB', "&raquo;");
		htmlEncodeChars.put('\u00BC', "&frac14;");
		htmlEncodeChars.put('\u00BD', "&frac12;");
		htmlEncodeChars.put('\u00BE', "&frac34;");
		htmlEncodeChars.put('\u00BF', "&iquest;");
		htmlEncodeChars.put('\u00C0', "&Agrave;");
		htmlEncodeChars.put('\u00C1', "&Aacute;");
		htmlEncodeChars.put('\u00C2', "&Acirc;");
		htmlEncodeChars.put('\u00C3', "&Atilde;");
		htmlEncodeChars.put('\u00C4', "&Auml;");
		htmlEncodeChars.put('\u00C5', "&Aring;");
		htmlEncodeChars.put('\u00C6', "&AElig;");
		htmlEncodeChars.put('\u00C7', "&Ccedil;");
		htmlEncodeChars.put('\u00C8', "&Egrave;");
		htmlEncodeChars.put('\u00C9', "&Eacute;");
		htmlEncodeChars.put('\u00CA', "&Ecirc;");
		htmlEncodeChars.put('\u00CB', "&Euml;");
		htmlEncodeChars.put('\u00CC', "&Igrave;");
		htmlEncodeChars.put('\u00CD', "&Iacute;");
		htmlEncodeChars.put('\u00CE', "&Icirc;");
		htmlEncodeChars.put('\u00CF', "&Iuml;");
		htmlEncodeChars.put('\u00D0', "&ETH;");
		htmlEncodeChars.put('\u00D1', "&Ntilde;");
		htmlEncodeChars.put('\u00D2', "&Ograve;");
		htmlEncodeChars.put('\u00D3', "&Oacute;");
		htmlEncodeChars.put('\u00D4', "&Ocirc;");
		htmlEncodeChars.put('\u00D5', "&Otilde;");
		htmlEncodeChars.put('\u00D6', "&Ouml;");
		htmlEncodeChars.put('\u00D7', "&times;");
		htmlEncodeChars.put('\u00D8', "&Oslash;");
		htmlEncodeChars.put('\u00D9', "&Ugrave;");
		htmlEncodeChars.put('\u00DA', "&Uacute;");
		htmlEncodeChars.put('\u00DB', "&Ucirc;");
		htmlEncodeChars.put('\u00DC', "&Uuml;");
		htmlEncodeChars.put('\u00DD', "&Yacute;");
		htmlEncodeChars.put('\u00DE', "&THORN;");
		htmlEncodeChars.put('\u00DF', "&szlig;");
		htmlEncodeChars.put('\u00E0', "&agrave;");
		htmlEncodeChars.put('\u00E1', "&aacute;");
		htmlEncodeChars.put('\u00E2', "&acirc;");
		htmlEncodeChars.put('\u00E3', "&atilde;");
		htmlEncodeChars.put('\u00E4', "&auml;");
		htmlEncodeChars.put('\u00E5', "&aring;");
		htmlEncodeChars.put('\u00E6', "&aelig;");
		htmlEncodeChars.put('\u00E7', "&ccedil;");
		htmlEncodeChars.put('\u00E8', "&egrave;");
		htmlEncodeChars.put('\u00E9', "&eacute;");
		htmlEncodeChars.put('\u00EA', "&ecirc;");
		htmlEncodeChars.put('\u00EB', "&euml;");
		htmlEncodeChars.put('\u00EC', "&igrave;");
		htmlEncodeChars.put('\u00ED', "&iacute;");
		htmlEncodeChars.put('\u00EE', "&icirc;");
		htmlEncodeChars.put('\u00EF', "&iuml;");
		htmlEncodeChars.put('\u00F0', "&eth;");
		htmlEncodeChars.put('\u00F1', "&ntilde;");
		htmlEncodeChars.put('\u00F2', "&ograve;");
		htmlEncodeChars.put('\u00F3', "&oacute;");
		htmlEncodeChars.put('\u00F4', "&ocirc;");
		htmlEncodeChars.put('\u00F5', "&otilde;");
		htmlEncodeChars.put('\u00F6', "&ouml;");
		htmlEncodeChars.put('\u00F7', "&divide;");
		htmlEncodeChars.put('\u00F8', "&oslash;");
		htmlEncodeChars.put('\u00F9', "&ugrave;");
		htmlEncodeChars.put('\u00FA', "&uacute;");
		htmlEncodeChars.put('\u00FB', "&ucirc;");
		htmlEncodeChars.put('\u00FC', "&uuml;");
		htmlEncodeChars.put('\u00FD', "&yacute;");
		htmlEncodeChars.put('\u00FE', "&thorn;");
		htmlEncodeChars.put('\u00FF', "&yuml;");

		// Mathematical, Greek and Symbolic characters for HTML
		htmlEncodeChars.put('\u0192', "&fnof;");
		htmlEncodeChars.put('\u0391', "&Alpha;");
		htmlEncodeChars.put('\u0392', "&Beta;");
		htmlEncodeChars.put('\u0393', "&Gamma;");
		htmlEncodeChars.put('\u0394', "&Delta;");
		htmlEncodeChars.put('\u0395', "&Epsilon;");
		htmlEncodeChars.put('\u0396', "&Zeta;");
		htmlEncodeChars.put('\u0397', "&Eta;");
		htmlEncodeChars.put('\u0398', "&Theta;");
		htmlEncodeChars.put('\u0399', "&Iota;");
		htmlEncodeChars.put('\u039A', "&Kappa;");
		htmlEncodeChars.put('\u039B', "&Lambda;");
		htmlEncodeChars.put('\u039C', "&Mu;");
		htmlEncodeChars.put('\u039D', "&Nu;");
		htmlEncodeChars.put('\u039E', "&Xi;");
		htmlEncodeChars.put('\u039F', "&Omicron;");
		htmlEncodeChars.put('\u03A0', "&Pi;");
		htmlEncodeChars.put('\u03A1', "&Rho;");
		htmlEncodeChars.put('\u03A3', "&Sigma;");
		htmlEncodeChars.put('\u03A4', "&Tau;");
		htmlEncodeChars.put('\u03A5', "&Upsilon;");
		htmlEncodeChars.put('\u03A6', "&Phi;");
		htmlEncodeChars.put('\u03A7', "&Chi;");
		htmlEncodeChars.put('\u03A8', "&Psi;");
		htmlEncodeChars.put('\u03A9', "&Omega;");
		htmlEncodeChars.put('\u03B1', "&alpha;");
		htmlEncodeChars.put('\u03B2', "&beta;");
		htmlEncodeChars.put('\u03B3', "&gamma;");
		htmlEncodeChars.put('\u03B4', "&delta;");
		htmlEncodeChars.put('\u03B5', "&epsilon;");
		htmlEncodeChars.put('\u03B6', "&zeta;");
		htmlEncodeChars.put('\u03B7', "&eta;");
		htmlEncodeChars.put('\u03B8', "&theta;");
		htmlEncodeChars.put('\u03B9', "&iota;");
		htmlEncodeChars.put('\u03BA', "&kappa;");
		htmlEncodeChars.put('\u03BB', "&lambda;");
		htmlEncodeChars.put('\u03BC', "&mu;");
		htmlEncodeChars.put('\u03BD', "&nu;");
		htmlEncodeChars.put('\u03BE', "&xi;");
		htmlEncodeChars.put('\u03BF', "&omicron;");
		htmlEncodeChars.put('\u03C0', "&pi;");
		htmlEncodeChars.put('\u03C1', "&rho;");
		htmlEncodeChars.put('\u03C2', "&sigmaf;");
		htmlEncodeChars.put('\u03C3', "&sigma;");
		htmlEncodeChars.put('\u03C4', "&tau;");
		htmlEncodeChars.put('\u03C5', "&upsilon;");
		htmlEncodeChars.put('\u03C6', "&phi;");
		htmlEncodeChars.put('\u03C7', "&chi;");
		htmlEncodeChars.put('\u03C8', "&psi;");
		htmlEncodeChars.put('\u03C9', "&omega;");
		htmlEncodeChars.put('\u03D1', "&thetasym;");
		htmlEncodeChars.put('\u03D2', "&upsih;");
		htmlEncodeChars.put('\u03D6', "&piv;");
		htmlEncodeChars.put('\u2022', "&bull;");
		htmlEncodeChars.put('\u2026', "&hellip;");
		htmlEncodeChars.put('\u2032', "&prime;");
		htmlEncodeChars.put('\u2033', "&Prime;");
		htmlEncodeChars.put('\u203E', "&oline;");
		htmlEncodeChars.put('\u2044', "&frasl;");
		htmlEncodeChars.put('\u2118', "&weierp;");
		htmlEncodeChars.put('\u2111', "&image;");
		htmlEncodeChars.put('\u211C', "&real;");
		htmlEncodeChars.put('\u2122', "&trade;");
		htmlEncodeChars.put('\u2135', "&alefsym;");
		htmlEncodeChars.put('\u2190', "&larr;");
		htmlEncodeChars.put('\u2191', "&uarr;");
		htmlEncodeChars.put('\u2192', "&rarr;");
		htmlEncodeChars.put('\u2193', "&darr;");
		htmlEncodeChars.put('\u2194', "&harr;");
		htmlEncodeChars.put('\u21B5', "&crarr;");
		htmlEncodeChars.put('\u21D0', "&lArr;");
		htmlEncodeChars.put('\u21D1', "&uArr;");
		htmlEncodeChars.put('\u21D2', "&rArr;");
		htmlEncodeChars.put('\u21D3', "&dArr;");
		htmlEncodeChars.put('\u21D4', "&hArr;");
		htmlEncodeChars.put('\u2200', "&forall;");
		htmlEncodeChars.put('\u2202', "&part;");
		htmlEncodeChars.put('\u2203', "&exist;");
		htmlEncodeChars.put('\u2205', "&empty;");
		htmlEncodeChars.put('\u2207', "&nabla;");
		htmlEncodeChars.put('\u2208', "&isin;");
		htmlEncodeChars.put('\u2209', "&notin;");
		htmlEncodeChars.put('\u220B', "&ni;");
		htmlEncodeChars.put('\u220F', "&prod;");
		htmlEncodeChars.put('\u2211', "&sum;");
		htmlEncodeChars.put('\u2212', "&minus;");
		htmlEncodeChars.put('\u2217', "&lowast;");
		htmlEncodeChars.put('\u221A', "&radic;");
		htmlEncodeChars.put('\u221D', "&prop;");
		htmlEncodeChars.put('\u221E', "&infin;");
		htmlEncodeChars.put('\u2220', "&ang;");
		htmlEncodeChars.put('\u2227', "&and;");
		htmlEncodeChars.put('\u2228', "&or;");
		htmlEncodeChars.put('\u2229', "&cap;");
		htmlEncodeChars.put('\u222A', "&cup;");
		htmlEncodeChars.put('\u222B', "&int;");
		htmlEncodeChars.put('\u2234', "&there4;");
		htmlEncodeChars.put('\u223C', "&sim;");
		htmlEncodeChars.put('\u2245', "&cong;");
		htmlEncodeChars.put('\u2248', "&asymp;");
		htmlEncodeChars.put('\u2260', "&ne;");
		htmlEncodeChars.put('\u2261', "&equiv;");
		htmlEncodeChars.put('\u2264', "&le;");
		htmlEncodeChars.put('\u2265', "&ge;");
		htmlEncodeChars.put('\u2282', "&sub;");
		htmlEncodeChars.put('\u2283', "&sup;");
		htmlEncodeChars.put('\u2284', "&nsub;");
		htmlEncodeChars.put('\u2286', "&sube;");
		htmlEncodeChars.put('\u2287', "&supe;");
		htmlEncodeChars.put('\u2295', "&oplus;");
		htmlEncodeChars.put('\u2297', "&otimes;");
		htmlEncodeChars.put('\u22A5', "&perp;");
		htmlEncodeChars.put('\u22C5', "&sdot;");
		htmlEncodeChars.put('\u2308', "&lceil;");
		htmlEncodeChars.put('\u2309', "&rceil;");
		htmlEncodeChars.put('\u230A', "&lfloor;");
		htmlEncodeChars.put('\u230B', "&rfloor;");
		htmlEncodeChars.put('\u2329', "&lang;");
		htmlEncodeChars.put('\u232A', "&rang;");
		htmlEncodeChars.put('\u25CA', "&loz;");
		htmlEncodeChars.put('\u2660', "&spades;");
		htmlEncodeChars.put('\u2663', "&clubs;");
		htmlEncodeChars.put('\u2665', "&hearts;");
		htmlEncodeChars.put('\u2666', "&diams;");
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

	public static String htmlEncode(String source)
	{
		return encode(source, htmlEncodeChars);
	}


	private static String encode(String source, HashMap<Character, String> encodingTable)
	{
		if (null == source)
		{
			return null;
		}

		if (null == encodingTable)
		{
			return source;
		}

		StringBuffer    encoded_string = null;
		char[]          string_to_encode_array = source.toCharArray();
		int             last_match = -1;
		int             difference = 0;

		for (int i = 0; i < string_to_encode_array.length; i++)
		{
			char char_to_encode = string_to_encode_array[i];

			if (encodingTable.containsKey(char_to_encode))
			{
				if (null == encoded_string)
				{
					encoded_string = new StringBuffer(source.length());
				}
				difference = i - (last_match + 1);
				if (difference > 0)
				{
					encoded_string.append(string_to_encode_array, last_match + 1, difference);
				}
				encoded_string.append(encodingTable.get(char_to_encode));
				last_match = i;
			}
		}

		if (null == encoded_string)
		{
			return source;
		}
		else
		{
			difference = string_to_encode_array.length - (last_match + 1);
			if (difference > 0)
			{
				encoded_string.append(string_to_encode_array, last_match + 1, difference);
			}
			return encoded_string.toString();
		}
	}
}

