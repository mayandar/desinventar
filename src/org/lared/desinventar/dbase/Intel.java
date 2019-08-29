package org.lared.desinventar.dbase;

import java.io.RandomAccessFile;
import java.io.IOException;

/**
* Class to read and write intel short values.
*/
public class Intel
{
	/**
	* Read an intel four byte value as an int.
	* @param dbf File handle.
	*
	* @return int value.
	*/
	public static int readShort(RandomAccessFile dbf) throws IOException
	{
		// Get the next 4 bytes (int Intel order) and turn them into a java int.
		byte ib[] = new byte[4];
		ib[3] = (byte)dbf.read();
		ib[2] = (byte)dbf.read();
		ib[1] = (byte)dbf.read();
		ib[0] = (byte)dbf.read();

		int val = (ib[0] << 24 ) | (((ib[1])&0xff) << 16) | (((ib[2])&0xff) << 8) | ((ib[3])&0xff);

		return val;
	}

	/**
	* Write an Intel four byte int.
	* @param dbf File handle.
	* @param val int to write (will write Java short).
	*/
	public static void writeShort(RandomAccessFile dbf, int val)  throws IOException
	{
		byte ib[] = new byte[4];
		ib[0] = (byte)((val >>> 24) & 0xff);
		ib[1] = (byte)((val >>> 16) & 0xff);
		ib[2] = (byte)((val >>> 8) & 0xff);
		ib[3] = (byte)(val & 0xff);

		 // Write the number of records out.
		dbf.write((int)ib[3]);
		dbf.write((int)ib[2]);
		dbf.write((int)ib[1]);
		dbf.write((int)ib[0]);
	}
	
}