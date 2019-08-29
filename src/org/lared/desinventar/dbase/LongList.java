package org.lared.desinventar.dbase;

import java.util.Arrays;

/**
* Class to hold a list of longs.
*/
class LongList
{
	final int GROWBY = 100;	// Amount to grow list by each time.
	long list[];
	int elements;	// Count of active elements.
	int totalElements;	// Number of active and inactive elements.

	/**
	* Constructor.
	*/
	LongList()
	{
		list = new long[GROWBY];
		elements = 0;
		totalElements = GROWBY;
	}

	/**
	* Add a long to the list.
	*
	* @param n Long number.
	*/
	void add(long n)
	{
		if (elements >= totalElements)
		{
			totalElements += GROWBY;
			long newList[] = new long[totalElements];
			System.arraycopy(list, 0, newList, 0, list.length);
			list = newList;
		}

		list[elements++] = n;
	}

	/**
	* Get the list.
	*
	* @return The list.
	*/
	long [] get()
	{
		// Maybe we get lucky or they already asked for a get().
		if (elements == totalElements)
			return list;

		// Trim the list to it's actual size.
		long newList[] = new long[elements];
		System.arraycopy(list, 0, newList, 0, elements);
		list = newList;
		totalElements = elements;	// Correct the actual number of elements.

		return list;
	}
	
	/**
	* Get the size of the list.
	*
	* @return size.
	*/
	public int size()
	{
		return elements;
	}

	/**
	* Uniquely sort the list.
	*/
	void usort()
	{
		if (elements <= 1)
			return;

		int i;
		Arrays.sort(list, 0, elements);
		long sorted[] = new long[totalElements];

		long lastValue = list[0];
		sorted[0] = lastValue;

		int sortCount = 1;
		for (i = 1; i < elements; i++)
		{
			long t = list[i];
			if (t != lastValue)
				sorted[sortCount++] = t;

			lastValue = t;
		}

		list = sorted;
		elements = sortCount;
	}

}