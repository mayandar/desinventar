package org.lared.desinventar.dbase;

import java.sql.*;
import java.io.*;

import org.lared.desinventar.dbase.*;

/**
* Class to handle DBase III+ memo fields.
*
* @since 2.01
*/
public class DBASEIIIMemoHandler extends MemoHandler
{
	/**
	* End of memo data marker.
	*/
	private final byte EOMD[] = { (byte) 0x1A, (byte) 0x1A};

	/**
	* Standard field naming the DBASE III database.
	* This field must be present in all MemoHandler extenders
	* so that the list of supported databases can be handled
	* as well as the list of classes for creating the instances.
	*/
	public static String MEMO_HANDLER = "DBASE III";

	/**
	* Default constructor.
	*/
	public DBASEIIIMemoHandler()
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
			// DBASE III data starts
			dbt.seek(block * blockSize);

			// Loop on picking up block sized pieces until the contents end in a pair of 0x1A's, or
			// at least one.

			memoData = new byte[(int) blockSize];
			boolean firstTime = true;

			while (true)
			{
				int nz;
				int br = dbt.read(memoData);

				for (nz = 0; nz < br; nz++)
					if (memoData[nz] == (byte)0x1A)
					{
						if (nz + 1 < br && memoData[nz + 1] == (byte)0x1A)
							break;
						// A less common EOR marker is just to have one 0x1A.
						break;
					}

				// Add the data to the current memo
				memo.write(memoData, 0, nz);

				// See if we have all the data.
				if (nz < (int)blockSize)
					break;

				if (firstTime == true)
				{
					// Get a marginally larger buffer since we don't have to ignore header data.
					firstTime = false;
					memoData = new byte[(int) blockSize];
				} else {
					// Clear all the written data.  There are two ways to do it fast.
					if (nz == blockSize / 3)	// If it's over a third of the buffer, use arraycopy
						System.arraycopy(emptyBlock, 0, memoData, 0, (int) blockSize);
					else 	// Zero only the written part.
						while (--nz >= 0)
							memoData[nz] = 0;
				}
			}
		} catch (IOException ioe) {
			throw new SQLException("Error reading memo field: " +  ioe);
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
				if (emptyBlock.length < HEADERSIZE)
					dbt.write(emptyBlock, 0, HEADERSIZE);
				else
					dbt.write(emptyBlock);

				// Write the version number - 0x03.
				dbt.seek(16L);
				dbt.write(0x03);
			} else {
				// Determine where we should write the new data (last block in file).
				dbt.seek(0L);
				lastBlock = Intel.readShort(dbt);
			}

			// The block may not be fleshed out with data.  Write the remainder of the data with zeros
			dbt.seek(fLen);
			int resid = (int) ((blockSize * lastBlock) - fLen);
			if (resid > 0)
				dbt.write(emptyBlock, 0, resid);

			// Write data and marker.
			dbt.write(buf);
			dbt.write(EOMD);

			// Now rewrite the header with the new end position.
			dbt.seek(0L);
			int writtenBlock = lastBlock + (buf.length + (int) blockSize - 1) / (int) blockSize;
			Intel.writeShort(dbt, writtenBlock);

			return lastBlock;

		} catch (IOException ioe) {
				throw new SQLException("Error writing memo file (.dbt): " + DBase.getStackTrace(ioe));
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
		// For DBASE III this is the header size.
		return HEADERSIZE;
	}

}