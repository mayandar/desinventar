package org.lared.desinventar.util;

public class EncodeUtil {

	    /**
	    * Which ascii characters may be sent in HTML without escaping
	    */
	    public static String htmlEncode(String src) {
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

		

	}
