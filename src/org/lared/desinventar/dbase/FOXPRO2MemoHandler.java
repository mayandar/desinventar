package org.lared.desinventar.dbase;

import java.sql.*;
import java.io.*;

import org.lared.desinventar.dbase.*;

/**
* Class to handle Foxpro V2 memo fields.
*
* @since 2.01
*/
public class FOXPRO2MemoHandler extends MemoHandler
{
	/**
	* Standard field naming the FoxPro V2 database.
	* This field must be present in all MemoHandler extenders
	* so that the list of supported databases can be handled
	* as well as the list of classes for creating the instances.
	*/
	public static String MEMO_HANDLER = "FOXPROV2";

	/**
	* Default constructor.
	*/
	public FOXPRO2MemoHandler()
	{
		// Create the default empty block based on the assumed block size.
		blockSize = 64;
		emptyBlock = new byte[ HEADERSIZE];
	}

	/**
	* Set block size for the memo data.
	* @param blockSize Block size for the memo blocks, usually 512 bytes.
	*/
	public void setBlockSize(long blockSize)
	{
		if (blockSize != emptyBlock.length)
		{
			emptyBlock = new byte[ (int) blockSize];
			this.blockSize = blockSize;
		}
	}

	/**
	* Retrieve the memo field from the database.
	*
	* @param 	dbt RandomAccessFile object for the memo database.
	* @param block Block to start reading memo data.
	* @return the memo data or null if something went wrong.
	* @throws SQLException if  the field doesn't contain memo data,
	* or the memo data block doesn't exist.
	*/
	public ByteArrayOutputStream getMemoData(RandomAccessFile dbt, long block) throws SQLException
	{
		byte memoData[];		// Storage for partial raw memo data.
		ByteArrayOutputStream memo = new ByteArrayOutputStream();

		try {
			// Get the block size the first time we read or write.
			if (firstReadWrite)
			{
				getBlockSize(dbt);
				firstReadWrite = false;
			}

			// NOTE: Actually we seek to the given position from the memo field.
			// The first four bytes is the record type: 00 - Picture on a Mac, 01 - Memo, 02 a- Object
			// Next four bytes are the length of the data.
			// Two EOF (0x1A) chars terminate the data.

			// Seek to the block and 4 bytes of DBT header on the first record.
			// The memo data size includes the header.
			// Currently we ignore the type of data. Programmer beware!
			dbt.seek(block * blockSize + 4L);
			int dataSize = readShort(dbt);
			if (dataSize < 0)
			{
				dbt.seek(block * blockSize + 4L);
				byte tmp[] = new byte[8];
				dbt.read(tmp);
			}
			memoData = new byte[dataSize];
			int br = dbt.read(memoData);
			memo.write(memoData);
		} catch (IOException ioe) {
			throw new SQLException("Error reading memo field: " +  DBase.getStackTrace(ioe));
		}

		return memo;
	}

	/**
	* Write a memo.
	*
	* @param 	dbt RandomAccessFile object for the memo database.
	* @param buf data to write.
	* @return the block number where the memo starts.
	* @throws SQLException
	*/
	public int writeMemoData(RandomAccessFile dbt, byte buf[], String tableName) throws SQLException
	{
		try {
			// Read header to find out where to write next block.
			long fLen = dbt.length();	// Seek to end of file to add bytes.
			int lastBlock;

			// If the file is empty, write the header.  Update the file length as we write.
			if (fLen == 0)
			{
				// New file - create the first empty block and set up lastBlock to be one.
				// The lastBlock value will be written later.
				dbt.seek(0L);
				if (emptyBlock.length < HEADERSIZE)
					dbt.write(new byte[HEADERSIZE]);
				else
					dbt.write(emptyBlock, 0, HEADERSIZE);

				// Write the block size.
				dbt.seek(6L);
				writeVeryShort(dbt, (int) blockSize);
				lastBlock = (int) (HEADERSIZE / blockSize);
			} else {
				// Get the block size the first time we read or write.
				if (firstReadWrite)
				{
					getBlockSize(dbt);
					firstReadWrite = false;
				}

				// Determine where we should write the new data (last block in file).
				dbt.seek(0L);
				lastBlock = readShort(dbt);

				int likelyLastBlock = (int) ((fLen + blockSize - 1) / blockSize);
				// See if this make sense.
				if (lastBlock > likelyLastBlock)
				{
					lastBlock = likelyLastBlock;
				}
			}

			// The block may not be fleshed out with data.  Write the remainder of the data with zeros
			dbt.seek(fLen);
			int resid = (int) ((blockSize * lastBlock) - fLen);
			if (resid > 0)
				dbt.write(emptyBlock, 0, resid);

			// Write memo header, length, and data.
			// The type of field is a Memo (0x01), but it could be an Object (0x02), or a Mac picture
			// (0x00).
			writeShort(dbt, 0x01);
			writeShort(dbt, buf.length - 4);
			dbt.write(buf);

			// Now rewrite the header with the new end position.
			dbt.seek(0L);
			int writtenBlock = lastBlock + (buf.length + (int) blockSize - 1) / (int) blockSize;
			Intel.writeShort(dbt, writtenBlock);

			return lastBlock;

		} catch (IOException ioe) {
				throw new SQLException("Error writing memo file (.dbt): " + ioe.toString());
		}
	}

	public String getDatabaseName()
	{
		return MEMO_HANDLER;
	}

	/**
	* Get the block size from the file.
	* The file is assumed to exist as a memo file complete with header.
	* @param dbt Memo file handle.
	* @return block size.
	* @throws IOException if there's a problem reading the file.
	*/
	protected long getBlockSize(RandomAccessFile dbt) throws IOException
	{
		dbt.seek(6L);
		
		blockSize = (long) readVeryShort(dbt);
		if (blockSize == 0)
			blockSize = HEADERSIZE;

		return blockSize;
	}

	/**
	* Read a netork byte order four byte value as an int.
	* @param dbf File handle.
	*
	* @return int value.
	*/
	public int readShort(RandomAccessFile dbt) throws IOException
	{
		// Get the next 4 bytes (int Intel order) and turn them into a java int.
		byte ib[] = new byte[4];
		ib[0] = (byte)dbt.read();
		ib[1] = (byte)dbt.read();
		ib[2] = (byte)dbt.read();
		ib[3] = (byte)dbt.read();

		int val = (ib[0] << 24 ) | (((ib[1])&0xff) << 16) | (((ib[2])&0xff) << 8) | ((ib[3])&0xff);

		return val;
	}

	/**
	* Write a netork byte order four byte int.
	* @param dbf File handle.
	* @param val int to write (will write Java short).
	*/
	public void writeShort(RandomAccessFile dbt, int val)  throws IOException
	{
		byte ib[] = new byte[4];
		ib[0] = (byte)((val >>> 24) & 0xff);
		ib[1] = (byte)((val >>> 16) & 0xff);
		ib[2] = (byte)((val >>> 8) & 0xff);
		ib[3] = (byte)(val & 0xff);

		 // Write the number of records out.
		dbt.write((int)ib[0]);
		dbt.write((int)ib[1]);
		dbt.write((int)ib[2]);
		dbt.write((int)ib[3]);
	}

	/**
	* Read a netork byte order two byte value as an int.
	* @param dbf File handle.
	*
	* @return int value.
	*/
	public int readVeryShort(RandomAccessFile dbt) throws IOException
	{
		byte ib[] = new byte[2];
		ib[1] = (byte)dbt.read();
		ib[0] = (byte)dbt.read();

		return (((ib[0])&0xff | ((ib[1])&0xff) << 8));
	}

	/**
	* Read a netork byte order two byte value as an int.
	* @param dbf File handle.
	*
	* @return int value.
	*/
	public void writeVeryShort(RandomAccessFile dbt, int val) throws IOException
	{
		byte ib[] = new byte[2];
		ib[0] = (byte)((val >>> 8) & 0xff);
		ib[1] = (byte)(val & 0xff);

		 // Write the number of records out.
		dbt.write((int)ib[0]);
		dbt.write((int)ib[1]);
	}
}