package org.lared.desinventar.dbase;

import java.sql.*;
import java.io.*;

import org.lared.desinventar.dbase.*;

/**
* Class to handle DBase IV memo fields.
*
* @since 2.01
*/
public class DBASEIVMemoHandler extends MemoHandler
{
	/**
	* Mysterious bytes written to the start of each memo record.
	*/
	private final byte std[] = { (byte)0xff, (byte)0xff, (byte)0x08, (byte)0x00 };

	/**
	* Standard field naming the DBASE IV database.
	* This field must be present in all MemoHandler extenders
	* so that the list of supported databases can be handled
	* as well as the list of classes for creating the instances.
	*/
	public static String MEMO_HANDLER = "DBASE IV";

	/**
	* Default constructor.
	*/
	public DBASEIVMemoHandler()
	{
		// Create the default empty block based on the assumed block size.
		emptyBlock = new byte[ (int) blockSize];
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
			// Then the first 4 bytes are always FF FF 08 00 followed four bytes of
			// intel int giving the size of the data block.

			// Seek to the block and 8 bytes of DBT header on the first record.
			// The memo data size includes the header.
			dbt.seek(block * blockSize + 4L);
			int dataSize = Intel.readShort(dbt) - 8;
			if (dataSize < 0)
			{
System.out.println("Data size is " + dataSize);
				dbt.seek(block * blockSize + 4L);
				byte tmp[] = new byte[8];
				dbt.read(tmp);
System.out.println("Bad data: " + new ByteIterator(tmp).dump(0, 8));
System.exit(0);

			}
//System.out.println("Data size is " + dataSize);

			memoData = new byte[dataSize];
			int br = dbt.read(memoData);
//System.out.println("Data: length " + br);
			memo.write(memoData);
//System.out.println("Data is : " + new ByteIterator(memoData).dump(0, memoData.length));
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
				lastBlock = 1;
				dbt.seek(0L);
				if (emptyBlock.length < HEADERSIZE)
					dbt.write(emptyBlock, 0, HEADERSIZE);
				else
					dbt.write(emptyBlock);
				// Write the table name.
				dbt.seek(8L);
				byte tblName[] = new byte[8];
				System.arraycopy(tableName.getBytes(), 0, tblName, 0, tblName.length);
				dbt.write(tblName);
System.out.println("Writing header for new file with table name." + new String(tblName));

			} else {
				// Determine where we should write the new data (last block in file).
				dbt.seek(0L);
				lastBlock = Intel.readShort(dbt);
				
				// Get the block size the first time we read or write.
				if (firstReadWrite)
				{
					getBlockSize(dbt);
					firstReadWrite = false;
				}

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
			dbt.write(std);
			Intel.writeShort(dbt, buf.length + 8);
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
		dbt.seek(4L);
		blockSize = (long) Intel.readShort(dbt);
		if (blockSize == 0)
			blockSize = HEADERSIZE;
			
		return blockSize;
	}
	
}