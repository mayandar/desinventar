package org.lared.desinventar.dbase;

import java.util.ArrayList;

/**
* Class to hold a Name / Value pair list
*/
public class PairList
{
	protected ArrayList pairs = new ArrayList();
	int index = 0;

	/**
	* Add a new pair to the list.
	*
	* @param name Name of data.
	* @param value Value of data.
	*/
	public void add(Object name, Object value)
	{
		if (name instanceof String)
			add((String)name, value);
		else
			throw new ClassCastException("String argument  required");
	}
	
	/**
	* Add a new pair to the list.
	*
	* @param name Name of data.
	* @param value Value of data.
	*/
	public void add(String name, Object value)
	{
		Pair p = new Pair(name, value);
		pairs.add(p);
	}

	public void first()
	{
		index = 0;
		pairs.trimToSize();
	}

	public Pair next()
	{
		try {
			return (Pair) pairs.get(index++);
		} catch (IndexOutOfBoundsException iooe) {
			return null;
		}
	}

	/**
	* Return the size of the list.
	*
	* @return size.
	*/
	public int size()
	{
		return pairs.size();
	}
	
	/**
	* Return the pair name.
	*
	* @return name
	*/
	public String name()
	{
		return ((Pair)pairs.get(index)).name;
	}

	/**
	* Return the pair value.
	*
	* @return name
	*/
	public Object value()
	{
		return ((Pair)pairs.get(index)).value;
	}

	public String toString()
	{
		StringBuffer sb = new StringBuffer();

		int len = size();
		for (int i = 0; i < len; i++)
			sb.append( ((Pair)pairs.get(i)).toString() ).append('\n');

		return sb.toString();
	}

}