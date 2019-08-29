package org.lared.desinventar.dbase;

/**
* A byte iterator class that returns groups of bytes as a value.
* <P>
* For example, nextLong() would return the value of the next 8 bytes.
* To move over these bytes use moveLong().  In this way bytes
* may be parsed variously.  Eg. one could look for a special byte that
* indicates the next value is a short.
* <P>
* Copyright 1998, 1999, 2000 Michael Lecuyer, all rights reserved.
* <P>
* This program is free software
* <P>
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/
public class ByteIterator
{
	private byte array[];
	private int current;	// current position in byte array

	/**
	* Creates a new copy of the buffer.  Used if you want to preserve the
	* original buffer while making changes to the copy.
	*
	* @param d Data <code>byte</code> array to use.
	*
	* @see #getBuffer
	*/
	public ByteIterator(byte d[])
	{
		array = new byte[d.length];
		System.arraycopy(d, 0, array, 0, d.length);
		current = 0;
	}

	/**
	* May use the given buffer or create a new copy.
	*
	* @param d Data <code>byte</code> array to use.
	* @param newBuf true if a new buffer is required, false if we use the original.
	*
	* @see #getBuffer
	*/
	public ByteIterator(byte d[], boolean newBuf)
	{
		if (newBuf)
		{
			array = new byte[d.length];
			System.arraycopy(d, 0, array, 0, d.length);
		}
		else
			array = d;

		current = 0;
	}

	/**
	* Create a new buffer from a portion of a data buffer.
	* References to the new buffer are zero based.
	*
	* @param d Data <code>byte</code> array to use.
	* @param start Index of the first <code>byte</code>
	* @param length  length to use
	*
	* @see #getBuffer
	*/
	public ByteIterator(byte d[], int start, int length)
	{
		array = new byte[length];
		System.arraycopy(d, start, array, 0, length);
		current = 0;
	}

	/**
	* Return the current data buffer.
	* Useful if you need to retreive the copied data buffer.
	*
	* @return work buffer
	*/
	public byte [] getBuffer()
	{
		return array;
	}

	/**
	* Returns the first byte of buffer in the data.
	* Sets the current position to zero.
	*
	* @return <code>byte</code>
	*/
	public byte first()
	{
		current = 0;
		return array[0];
	}

	/**
	* Returns the last byte of buffer in the data.
	* Sets the current position to the last byte.
	*
	* @return <code>byte</code>
	*/
	public byte last()
	{
		current = array.length - 1;
		return array[current];
	}

	/**
	* Sets the current position.
	* If the position exceeds the length, the position is not changed
	*
	* @param posn Set the current index into the array.
	*
	* @see #seek
	*/
	public void setIndex(int posn)
	{
		current = posn;
	}

	/**
	* Move current position by an arbitrary number of bytes.
	* If the position exceeds the length, the position is not changed
	*
	* @param count Number of byte to advance
	*/
	public void move(int count)
	{
		current += count;
	}

	/**
	* Returns the current position in the buffer.
	*
	* @return current position
	*/
	public int current()
	{
		return current;
	}

	/**
	* Returns the next <code>long</code> (8 bytes).
	* Does not advance the buffer position.
	*
	* @return the <code>long</code> value.
	*/
	public long nextLong()
	{
		// Assemble bytes into a long value
		return concoctLong(array, current);
	}

	/**
	* Advance in the array by 8 bytes (size of <code>long</code>).
	*/
	public void moveLong()
	{
		current += 8;
	}

	/**
	* Returns the next <code>int</code> (4 bytes).
	* Does not advance the buffer position.
	*
	* @return the <code>int</code> value.
	*/
	public int nextInt()
	{
		// Assemble bytes into a int value
		return concoctInt(array, current);
	}

	/**
	* Advance in the array by four bytes (size of <code>int</code>).
	*/
	public void moveInt()
	{
		current += 4;
	}

	/**
	* Returns the next <code>short</code> (2 bytes).
	* Does not advance the buffer position.
	*
	* @return the <code>short</code> value.
	*/
	public short nextShort()
	{
		return concoctShort(array, current);
	}

	/**
	* Returns the next unsigned short (2 bytes) as an <code>int</code>.
	* Does not advance the buffer position.
	*
	* @return unsigned <code>short</code> value as an <code>int</code>.
	*/
	public int nextUnsignedShort()
	{
		return (int)concoctShort(array, current) & 0xffff;
	}

	/**
	* Returns the next unsigned byte (1 byte) as an <code>int</code>.
	* Does not advance the buffer position.
	*
	* @return the unsigned <code>byte</code> value an <code>int</code>.
	*/
	public int nextUnsignedByte()
	{
		return (int)array[current] & 0xff;
	}

	/**
	* Advance in the array by two bytes (size of <code>short</code>).
	*/
	public void moveShort()
	{
		current += 2;
	}

	/**
	* Return the next <code>byte</code>.
	* Does not advance the buffer position.
	*
	* @return the next <code>byte</code> value
	*/
	public byte nextByte()
	{
		return array[current];
	}

	/**
	* Advance in the array by one byte
	*/
	public void moveByte()
	{
		current++;
	}

	/**
	* Sets a <code>byte<code> at the current location
	* Does not advance the buffer position.
	*
	* @param i
	*/
	public void setByte(byte i)
	{
		array[current] = i;
	}

	/**
	* Sets a <code>short<code> at the current location
	* Does not advance the buffer position.
	*
	* @param i
	*/
	public void setShort(short i)
	{
		byte b[] = decoct(i);
		array[current] = b[0];
		array[current+1] = b[1];
	}

	/**
	* Sets an <code>int<code> at the current location
	* Does not advance the buffer position.
	*
	* @param i
	*/
	public void setInt(int i)
	{
		byte b[] = decoct(i);
		array[current] = b[0];
		array[current+1] = b[1];
		array[current+2] = b[2];
		array[current+3] = b[3];
	}

	/**
	* Sets a <code>long<code> at the current location.
	* Does not advance the buffer position.
	*
	* @param i
	*/
	public void setLong(long i)
	{
		byte b[] = decoct(i);
		array[current] = b[0];
		array[current+1] = b[1];
		array[current+2] = b[2];
		array[current+3] = b[3];
		array[current+4] = b[4];
		array[current+5] = b[5];
		array[current+6] = b[6];
		array[current+7] = b[7];
	}

	/**
	* Converts the first 8 bytes of a byte array into a <code>long</code>.
	*
	* @param b buffer.
	*
	* @return long value
	*/
	public static long concoctLong(byte b[])
	{
		long l;
		
		l = ((long)b[0] &0xff) << 56;
		l |= ((long)b[1] &0xff) << 48;
		l |= ((long)b[2] &0xff) << 40;
		l |= ((long)b[3] &0xff) << 32;
		l |= ((long)b[4] &0xff) << 24;
		l |= ((long)b[5] &0xff) << 16;
		l |= ((long)b[6] &0xff) << 8;
		l |= (long)b[7] &0xff;
		
		return l;
			
//		long u = concoctInt(b) & 0xffffffffL;
//		long l = concoctInt(b, 4) & 0xffffffffL;
//		return (u << 32) | l;
	}

	/**
	* Converts 8 bytes of a byte array into a <code>long</code> from the starting position.
	*
	* @param b buffer.
	* @param start postion to extract data
	*
	* @return long value
	*/
	public static long concoctLong(byte b[], int start)
	{
		long u = concoctInt(b, start) & 0xffffffffL;
		long l = concoctInt(b, start + 4) & 0xffffffffL;
		return (u << 32) | l;
	}

	/**
	* Converts 4 bytes of a byte array into an <code>int</code>.
	*
	* @param b buffer.
	*
	* @return int value
	*/
	public static int concoctInt(byte b[])
	{
	 	return (b[0] << 24 ) | (((b[1])&0xff) << 16) | (((b[2])&0xff) << 8) | ((b[3])&0xff);
	}


	/**
	* Converts 4 bytes of a byte array into an <code>int</code> from the starting position.
	*
	* @param b buffer.
	* @param start postion to extract data
	*
	* @return int value
	*/
	public static int concoctInt(byte b[], int start)
	{
	 	return (b[start] << 24 ) | (((b[start + 1])&0xff) << 16) | (((b[start + 2])&0xff) << 8) | ((b[start + 3])&0xff);
	}

	/**
	* Converts 2 bytes of a byte array into a <code>short</code>
	*
	* @param b buffer.
	*
	* @return int value
	*/
	public static short concoctShort(byte b[])
	{
	 	return (short)((((b[0])&0xff) << 8) | ((b[1])&0xff));
	}

	/**
	* Converts 2 bytes of a byte array into a <code>short</code> from the starting position.
	*
	* @param b buffer.
	* @param start postion to extract data
	*
	* @return int value
	*/
	public static short concoctShort(byte b[], int start)
	{
	 	return (short)((((b[start])&0xff) << 8) | ((b[start + 1])&0xff));
	}

	/**
	* Converts a <code>short</code> into 2 bytes.
	*
	* @param i Short value.
	*
	* @return byte array
	*/
	public static byte [] decoct(short i)
	{
		byte b[] = new byte[2];
		b[0] = (byte)(i >>> 8);
		b[1] = (byte)i;
		return b;
	}

	/**
	* Converts an <code>int</code> into 4 bytes.
	*
	* @param i Integer value.
	*
	* @return byte array
	*/
	public static byte [] decoct(int i)
	{
		byte b[] = new byte[4];
		b[0] = (byte)(i >>> 24);
		b[1] = (byte)(i >>> 16);
		b[2] = (byte)(i >>> 8);
		b[3] = (byte)i;
		return b;
	}

	/**
	* Converts a <code>long</code> into 8 bytes.
	*
	* @param i Long value.
	*
	* @return byte array
	*/
	public static byte [] decoct(long i)
	{
		byte b[] = new byte[8];
		b[0] = (byte)(i >>> 56);
		b[1] = (byte)(i >>> 48);
		b[2] = (byte)(i >>> 40);
		b[3] = (byte)(i >>> 32);
		b[4] = (byte)(i >>> 24);
		b[5] = (byte)(i >>> 16);
		b[6] = (byte)(i >>> 8);
		b[7] = (byte)i;
		return b;
	}

	/**
	* Returns the next <code>int</code> (4 bytes).
	* Advance the buffer position.
	*
	* @return the <code>int</code> value.
	*/
	public int readInt()
	{
		int i = nextInt();
		moveInt();
		return i;
	}

	/**
	* Returns the next <code>short</code> (2 bytes).
	* Advances the buffer position.
	*
	* @return the <code>short</code> value.
	*/
	public short readShort()
	{
		short i = nextShort();
		moveShort();
		return i;
	}

	/**
	* Returns the next <code>long</code> (8 bytes).
	* Advances the buffer position.
	*
	* @return the <code>long</code> value.
	*/
	public long readLong()
	{
		long i = nextLong();
		moveLong();
		return i;
	}

	/**
	* Returns the next unsigned<code>short</code> (2 bytes).
	* Advances the buffer position.
	*
	* @return the <code>int</code> value.
	*/
	public int readUnsignedShort()
	{
		int i = nextUnsignedShort();
		moveShort();
		return i;
	}

	/**
	* Returns the next unsigned<code>byte</code> (1 byte).
	* Advances the buffer position.
	*
	* @return the <code>int</code> value.
	*/
	public int readUnsignedByte()
	{
		int i = (int)(nextByte() & 0xff);
		moveByte();
		return i;
	}

	/**
	* Returns the next <code>byte</code>.
	* Advances the buffer position.
	*
	* @return the <code>byte</code> value.
	*/
	public byte readByte()
	{
		byte i = nextByte();
		moveByte();
		return i;
	}

	/**
	* Skips over bytes.
	* Advances the buffer position.
	*
	* @param count bytes to skip.
	*/
	public void skipBytes(int count)
	{
		move(count);
	}

	/**
	* Read a buffer full of bytes.  If there are not enough bytes in
	* the ByteIterator the buffer will not be filled.
	* <P>
	* Advances the buffer position by the number of bytes read.
	*
	* @param b buffer to fill.
	*
	* @return number of bytes read.
	*/
	public int read(byte b[])
	{
		return read(b, 0, b.length);
	}

	/**
	* Read bytes into a buffer.  If there are not enough bytes in
	* the ByteIterator the requested number of bytes will not be filled.
	* <P>
	* Advances the buffer position by the number of bytes read.
	*
	* @param b buffer to fill.
	* @param offset position in the buffer to start filling.
	* @param count number of bytes to read.
	*
	* @return number of bytes read.
	*/
	public int read(byte b[], int offset, int count)
	{
		if (offset + count > b.length)
			count = b.length - offset;

		if (count > array.length - current)
			count = array.length - current;

		if (count <= 0)
			return 0;

		System.arraycopy(array, current, b, offset, count);
		move(count);
		return count;
	}

	/**
	* Moves to the given byte position in the data buffer.
	*
	* @param posn position
	*
	* @see #setIndex
	*/
	public void seek(long posn)
	{
		setIndex((int)posn);
	}

	/**
	* Moves to the given byte position in the data buffer.
	*
	* @param posn position
	*/
	public void seek(int posn)
	{
		setIndex(posn);
	}

	/**
	* Write a <code>byte</code> to the buffer at the current position.
	* <P>
	* Advances the buffer position over the byte.
	*
	* @param i value to write.
	*/
	public void writeByte(byte i)
	{
		setByte(i);
		moveByte();
	}

	/**
	* Write an <code>int</code> to the buffer at the current position.
	* <P>
	* Advances the buffer position over the integer.
	*
	* @param i value to write.
	*/
	public void writeInt(int i)
	{
		setInt(i);
		moveInt();
	}

	/**
	* Write an <code>long</code> to the buffer at the current position.
	* <P>
	* Advances the buffer position over the long.
	*
	* @param i value to write.
	*/
	public void writeLong(long i)
	{
		setLong(i);
		moveLong();
	}

	/**
	* Write a <code>short</code> to the buffer at the current position.
	* <P>
	* Advances the buffer position over the short.
	*
	* @param i value to write.
	*/
	public void writeShort(short i)
	{
		setShort(i);
		moveShort();
	}


	/**
	* Write a <code>byte</code> array to the buffer at the current position.
	* <P>
	* Advances the buffer position by the number of bytes written.
	*
	* @param b buffer to write.
	*/
	public int write(byte b[])
	{
		int blen = b.length;
		System.arraycopy(b, 0, array, current(), blen);
		move(blen);
		return blen;
	}

	/**
	* Write a <code>byte</code> array to the buffer at the current position.
	* <P>
	* Advances the buffer position by the number of bytes written.
	*
	* @param b buffer to write.
	* @param start Start position in buffer.
	* @param length Length of buffer to write.
	* @return amount written or -1 if it doesn't fit in the ByteIterator buffer.
	*/
	public int write(byte b[], int start, int length)
	{
		int blen = b.length;
		if (current() + blen > array.length)
			return -1;	// Failed to write.

		System.arraycopy(b, start, array, current(), length);
		move(blen);

		return blen;
	}

	/**
	* Returns the current length of the data buffer.
	*
	* @return length of buffer.
	*
	* @see #extend
	*/
	public long length()
	{
		return (long)array.length;
	}

	/**
	* Extends data buffer (may be set longer or shorter).
	* If the caller constructed the data buffer with newBuf == false
	* the caller *MUST* reassign the original buffer to the returned value
	* In other words if you're using the original buffer to work in, this
	* reassigns the contents.  Will throw exception if the resulting buffer
	* size is negative.
	* <BR>
	* <BR> byte b[] = new byte[100];
	* <BR> ByteIterator bi = new ByteIterator(b, false)
	* <BR> file.read(b);
	* <BR> b = bi.extend(100);	// Extended by 100 bytes to 200, we must get the new buffer back.
	* <BR> b = bi.extend(-110);	// Shortened by 110 bytes to 90.
	* <BR>
	* <P>
	* Does not change buffer position although it may be at an illegal value after being reduced
	* in size.
	*
	* @param diff difference in size (negative or positive)
	*
	* @return new buffer.
	*
	* @see #getBuffer
	*/
	public byte [] extend(int diff)
	{
		byte newBuf[] = new byte[array.length + diff];
		int smallest = (newBuf.length > array.length) ? array.length : newBuf.length;
		System.arraycopy(array, 0, newBuf, 0, smallest);
		array = newBuf;

		return array;
	}

	/**
	* Read a line from the byte buffer.
	* Lines are terminated by EOF, '\n', or '\r' or both '\n' and '\r' in any order.
	* These characters are not returned.
	* <P>
	* Advances the buffer position by the number of bytes read.
	*
	* @return the string read or <code>null</code> if at the end of <i>file</i>.
	*/
	public String readLine()
	{
		if (current == array.length)
			return null;

		StringBuffer sb = new StringBuffer();
		byte c;

		// Get line and remove end chars.
		try {
			while ((c = nextByte()) != -1)
			{
				current++;	// do this the raw way and catch the exception.

				if (c == '\r' || c == '\n')
					break;

				sb.append((char)c);
			}
		} catch (ArrayIndexOutOfBoundsException aoobe)
		{
			last();	// set us at the last position in the buffer.
		}
		return sb.toString();
	}

	/**
	* Dump part of the byte buffer.
	* This is done in the customary way, suitable for framing or wrapping fish.
	* <PRE>
	* 6D 69 73 63 3B 0D 0A 0D - 0A 69 6D 70 6F 72 74 20   misc;... - .import
	* </PRE>
	* Does not advance the buffer position.
	*
	* @param start start position
	* @param length length to dump
	*
	* @return <code>String</code> containing the String representation of the dump.
	*/
	public String dump(int start, int length)
	{
		StringBuffer sb = new StringBuffer();
		int origPosn = current();	// remember original position.
		int here;	// where we are.

		byte b1[] = new byte[8];
		byte b2[] = new byte[8];

		// dump in 16 byte chunks, hex on the left, printables on the right.

		int end = length + start;
		for (here = start; here < end; here += 16)
		{
			int j, br;

			br = read(b1, 0, 8);
			if (br == 8)
			{
				// If we read enought fill the other buffer
				br = read(b2, 0, 8);
				for (j = br; j < 8; j++)
					b2[j] = 0;
			}
			else
			{
				// If too few bytes were read, clear the end of b1 and all of b2
				for (j = 0; j < 8 ; j++)
				{
					if (j >= br) b1[j] = 0;
					b2[j] = 0;
				}
			}

			// write the hex representation.
			sb.append(hexString(b1)).append("- ");
			sb.append(hexString(b2)).append("  ");

			for (j = 0; j < 8; j++)
				if (Ctype.isprint(b1[j]))
				{
					if (Ctype.isspace(b1[j]))
						sb.append(' ');
					else
						 sb.append((char)b1[j]);
				}
				else
					 sb.append('.');

			sb.append(" - ");	// Add a '-' to the byte display as well.

			for (j = 0; j < 8; j++)
				if (Ctype.isprint(b2[j]))
				{
					if (Ctype.isspace(b2[j]))
						sb.append(' ');
					else
						 sb.append((char)b2[j]);
				}
				else
					 sb.append('.');

			sb.append('\n');
		}
		current = origPosn;	// restore starting position.

		return sb.toString();
	}


	// Belongs with hexString().
	private final String hex = "0123456789ABCDEF";
	/**
	* Convert bytes into a hex string.
	* @return string.
	*/
	private String hexString(byte [] vb)
	{

		StringBuffer sb = new StringBuffer();

		for (int j = 0; j < vb.length; j++)
		{
			sb.append(hex.charAt((int)(vb[j] >> 4) & 0xf));
			sb.append(hex.charAt((int)(vb[j]) & 0xf));
			sb.append(' ');
		}

		return sb.toString();
	}

	private static final int MAXCHAR = 256;	// Maximum chars in character set.

	private byte pat[];	// Byte representation of pattern
	private int patLen;
	private int partial;	// Bytes of a partial match found at the end of a text buffer

	private int skip[];	// Internal BM table
	private int d[];		// Internal BM table

	/**
	* Boyer-Moore text search
	* Does not advance the buffer position.
	* <P> Scans text left to right using what it knows of the pattern
	* quickly determine if a match has been made in the text. In addition
	* it knows how much of the text to skip if a match fails.
	* This cuts down considerably on the number of comparisons between
	* the pattern and text found in pure brute-force compares
	* This has some advantages over the Knuth-Morris-Pratt text search.
	* <P>The particular version used here is
	* from "Handbook of Algorithms and Data
	* Structures", G.H. Gonnet & R. Baeza-Yates.
	*
	* Example of use:
	* <PRE>
	* buf = new byte[4096];
	* ...
	* String pattern = "and ";
	* <BR>
	* ByteIterator bi = new ByteIterator(buf);
	* bi.compile(pattern);
	* search = 0;
	* bcount = bi.current();	// get the position.
	* while ((search = bi.search(search, bcount-search)) >= 0)
	* {
	*       if (search >= 0)
	*       {
	*          System.out.println("full pattern found at " + search);
	* <BR>
	*          search += pattern.length();
	*          continue;
	*       }
	*    }
	*    if ((search = bi.partialMatch()) >= 0)
	*    {
	*       System.out.println("Partial pattern found at " + search);
	*    }
	* }
	* </PRE>
	*/

	/**
	* Compiles the text pattern for searching.
	*
	* @param pattern What we're looking for.
	*/
	public void compile(String pattern)
	{
		// Intialization, if necessary.
		if (skip == null)
			skip = new int[MAXCHAR];

		// create pattern
		pat = pattern.getBytes();
		patLen = pat.length;

		int j, k, m, t, t1, q, q1;
		int f[] = new int[patLen];
		d = new int[patLen];

		m = patLen;
		for (k = 0; k < MAXCHAR; k++)
			skip[k] = m;

		for (k = 1; k <= m; k++)
		{
			d[k-1] = (m << 1) - k;
			skip[pat[k-1]] = m - k;
		}

		t = m + 1;
		for (j = m; j > 0; j--)
		{
			f[j-1] = t;
			while (t <= m && pat[j-1] != pat[t-1])
			{
				d[t-1] = (d[t-1] < m - j) ? d[t-1] : m - j;
				t = f[t-1];
			}
			t--;
		}
		q = t;
		t = m + 1 - q;
		q1 = 1;
		t1 = 0;

		for (j = 1; j <= t; j++)
		{
			f[j-1] = t1;
			while (t1 >= 1 && pat[j-1] != pat[t1-1])
				t1 = f[t1-1];
			t1++;
		}

		while (q < m)
		{
			for (k = q1; k <= q; k++)
				d[k-1] = (d[k-1] < m + q - k) ? d[k-1] : m + q - k;
			q1 = q + 1;
			q = q + t - f[t-1];
			t = f[t-1];
		}
	}

	/**
	* Search for the compiled pattern in the given text.
	* A side effect of the search is the notion of a partial
	* match at the end of the searched buffer.
	* This partial match is helpful in searching text files when
	* the entire file doesn't fit into memory.
	*
	* @param start Start position for search
	* @param length Length of text in the buffer to be searched.
	*
	* @return position in buffer where the pattern was found or -1 if the pattern wasn't found.
	* @see #partialMatch
	*/
	public int search(int start, int length)
	{
		byte text[] = array;
		int textLen = length + start;
		partial = -1;	// assume no partial match

		if (start > array.length)
			return -1;	// No match, we're passed EOB.

		if (d == null)
			return -1;	// no pattern compiled, nothing matches.

		int m = patLen;
		if (m == 0)
			return 0;

		int k, j = 0;
		int max = 0;	// used in calculation of partial match. Max distance we jumped.

		for (k = start + m - 1; k < textLen;)
		{
			for (j = m - 1; j >= 0 && text[k] == pat[j]; j--)
				k--;

			if (j == -1)
				return k + 1;

			int z = skip[text[k]];
			max = (z > d[j]) ? z : d[j];
			k += max;
		}

		if (k >= textLen && j > 0)	// if we're near end of buffer --
		{
			partial = k - max - 1;

			return -1;	// not a real match
		}

		return -1;	// No match
	}

	/**
	* Returns the position at the end of the text buffer where a partial match was found.
	* <P>
	* In many case where a full text search of a large amount of data
	* precludes access to the entire file or buffer the search algorithm
	* will note where the final partial match occurs.
	* After an entire buffer has been searched for full matches calling
	* this method will reveal if a potential match appeared at the end.
	* This information can be used to patch together the partial match
	* with the next buffer of data to determine if a real match occurred.
	*
	* @return -1 the number of bytes that formed a partial match, -1 if no
	* partial match
	*/
	public int partialMatch()
	{
		return partial;
	}

}
