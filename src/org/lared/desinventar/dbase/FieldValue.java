package org.lared.desinventar.dbase;

/**
* Class to handle values - they have two attributes, the value, and if their a literal or a field name.
*/
public class FieldValue
{
	static final int LITERAL = 0;	// The Value is a literal.
	static final int FIELD = 1;	// The Value is a field name.

	Object value;		// Object form of the literal vaue (or the field name itself).
	String literal;		// Original string.
	int type;				// One of LITERAL or FIELD.
	
	/**
	* Is this value an Integer?
	*@return true if an int.
	*/
	public boolean isInteger()
	{
		return (value instanceof Integer);
	}
	
	/**
	* Get the Integer value.
	* @Return int.
	*/
	public int getInteger()
	{
		return ((Integer)value).intValue();
	}
	
	/**
	* Is this value a Double?
	*@return true if a double.
	*/
	public boolean isDouble()
	{
		return (value instanceof Double);
	}
	
	/**
	* Get the double value.
	* @Return double.
	*/
	public double getDouble()
	{
		return ((Double)value).doubleValue();
	}
	
	/**
	* Is this value a String?
	*@return true if a string.
	*/
	public boolean isString()
	{
		return (value instanceof String);
	}
	
	/**
	* Get the String value.
	* @Return string.
	*/
	public String getString()
	{
		return (String)value;
	}
	
	public String toString()
	{
		if (type == FIELD)
			return "FIELD => " + value;
		
		return "LITERAL => " + value;
	}
	
	public Object getObject()
	{
		return value;
	}
			
	
}