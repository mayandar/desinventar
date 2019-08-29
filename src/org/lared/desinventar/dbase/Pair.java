package org.lared.desinventar.dbase;

/**
* Class to hold Name / Value pairs.
*/
public class Pair
{
	String name;
	Object value;
	
	public Pair(String name, Object value)
	{
		this.name = name;
		this.value = value;
	}
	
	public String toString()
	{
		return name + " => " + value;
	}
}