package org.lared.desinventar.dbase;

import java.lang.reflect.*;
import java.sql.*;
import java.io.*;

/**
* Base class for a Memo field reader.
* <b>Note: Do not use this class directly.</b>
<p>
* This class should be extended to handle other memo field types and is not intended for actually reading memo fields by people using the DBase class.
* <p>
* Memo field data is problematic because the .DBT file's contents are not defined as a standard.
* Consequently each DBase vendor has a different format.  This class may be extended to
* read and write new memo file formats.
* <p>
* The only standard is that the DBT file has two parts, a header block and data blocks.
* Each memo field starts on a block boundary starting past the header block.
* The contents of the header and each memo field vary considerably.
*
* @since 2.01
*/
public class MemoHandler
{
	/**
	* Empty block for writing and it should not be altered directly.
	* @see #setBlockSize(long blockSize) setBlockSize()
	*/
	public byte emptyBlock[];
	
	/**
	* Header block size - {@value}.
	*/
	public static final int HEADERSIZE = 512;

	/**
	* Memo data buffer.
	*/
	private byte memoData[];
	
	/**
	* The first time through we read the block size.
	*/
	boolean firstReadWrite = true;

	/**
	* Current database name.
	*/
	private String databaseName;
	
	/**
	* DBT block size - default value {@value}.
	* The default is the header size.
	*/
	protected long blockSize = HEADERSIZE;

	/**
	* Default constructor.
	*/
	protected MemoHandler()
	{
	}

	/**
	* Creates a memo handler  with the specified datbase name
	* @param name of the database.
	*/
	protected MemoHandler(String memoReader)
	{
		databaseName = memoReader;
	}

	/**
	* Get an instance of a particular memo handler class.
	* @param memoHandlerClass Class path to the memo handler
	* class.  If this has no path it's assumed to be in the current package.
	* For example using the string "MemoHandlerFoxPro" would pick
	* up the class org.lared.desinventar.dbase.dbase.MemoHandlerFoxPro.
	* The package is dynamically determined so it will always pick the
	* class from the the DBase class package.  If you have your own a fully
	* qualified class path will work too.
	* @throws SQLException if there's a problem instantiating the class.
	*/
	public static MemoHandler getInstance(String memoHandlerClass) throws SQLException
	{
		MemoHandler tmh = new MemoHandler();

		try {
			Class mhC;
			try {
				// Try a fullly qualified path first.
				mhC = Class.forName(memoHandlerClass);
			} catch (ClassNotFoundException cnfe) {
				// Not found, try our own package.
				Package p = tmh.getClass().getPackage();
				String fqcp = p.getName() + "." + memoHandlerClass;
				try {
					mhC = Class.forName(fqcp);
				} catch (ClassNotFoundException cnfe1) {
					throw new SQLException(DBase.getStackTrace(cnfe1));
				}
			}

			return (MemoHandler) mhC.newInstance();

		} catch (Exception ie) {
			throw new SQLException(DBase.getStackTrace(ie));
		}
	}

	/**
	* Get the database name for the memo handler.
	*/
	public String getDatabaseName()
	{
		return "";
	}

	/**
	* Retrieve the memo field from the database.
	*
	* @param 	dbt RandomAccessFile object for the memo database.
	* @param block Block to start reading memo data.
	* @return the memo data stream.
	* @throws SQLException if there's no memo file or the field doesn't contain memo data,
	* or the memo data block doesn't exist.
	*/
	public ByteArrayOutputStream getMemoData(RandomAccessFile dbt, long block) throws SQLException
	{
		// This must be overridden.
		return null;
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
		// This must be overridden.
		return 0;
	}

	/**
	* Set block size for the memo data.
	* @param blockSize Block size for the memo blocks, almost always 512 bytes.
	* The block size is the same block size used by the main database.
	*/
	public void setBlockSize(long blockSize)
	{
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
		return 0L;
	}
}

