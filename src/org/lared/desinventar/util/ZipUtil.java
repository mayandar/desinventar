package org.lared.desinventar.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;
import java.util.ArrayList;

/**
 * Created by IntelliJ IDEA. User: The Hien Date: Sep 22, 2009 Time: 2:50:10 PM
 */
public class ZipUtil 
{
	public static void main(String arg[]) throws Exception 
	{
		int dayBefore = 1;

		String srcFolder = "C:/APP";
		String destZipFile = srcFolder + ".zip";
		File file = new File(srcFolder);
		if (file.exists())
			zipFolder(srcFolder, destZipFile);

		// ?? (new SendFile()).fileTranfer();
		// ?? DelFolder.deleteDir(new File(srcFolder));

	}

	static public void zipFolder(String srcFolder, String destZipFile)
	throws Exception 
	{
		ZipOutputStream zip = null;
		FileOutputStream fileWriter = null;
		boolean ziped = false;
		try {
			fileWriter = new FileOutputStream(destZipFile);
			zip = new ZipOutputStream(fileWriter);

			addFileToZip("", srcFolder, zip);
			ziped = true;
			// System.out.println("Your file " + (ziped ? "" : "not ") +
			// "zipped .");
		}

		finally {
			if (null != zip)
				zip.close();
			if (null != fileWriter)
				fileWriter.close();

		}
	}


	static public void zipFolder(ArrayList srcFiles, String destZipFile)	throws Exception 
	{
		String[] sArray=new String[srcFiles.size()];
		for (int j=0; j<sArray.length; j++)
			sArray[j]=(String)srcFiles.get(j);
		zipFolder(sArray,destZipFile);
	}

	
	static public void zipFolder(String[] srcFiles, String destZipFile)	throws Exception 
	{
		ZipOutputStream zip = null;
		FileOutputStream fileWriter = null;
		boolean ziped = false;
		try {
			fileWriter = new FileOutputStream(destZipFile);
			zip = new ZipOutputStream(fileWriter);

			for (int j=0; j<srcFiles.length; j++)
				addFileToZip("", srcFiles[j], zip);

			ziped = true;
		}

		finally {
			if (null != zip)
				zip.close();
			if (null != fileWriter)
				fileWriter.close();

		}
	}



	static public void addFileToZip(String Path, String scrFile, ZipOutputStream zip) throws Exception {

		File folder = new File(scrFile);
		if ((folder.isDirectory())) 
		{
			addFolderToZip(Path, scrFile, zip);
		} 
		else 
		{

			byte[] buffer = new byte[1024];
			int len;
			FileInputStream in = null;
			try {
				in = new FileInputStream(scrFile);
				zip.putNextEntry(new ZipEntry(Path + (Path.length() > 0 ? "/" : "") + folder.getName()));
				while ((len = in.read(buffer)) > 0) {
					zip.write(buffer, 0, len);
				}
			} 
			finally {
				if (null != in)
					in.close();
			}
		}
	}

	static private boolean addFolderToZip(String subFolder, String srcFolder, ZipOutputStream zip) throws Exception {

		File folder = new File(srcFolder);
		try {
			for (File item : folder.listFiles()) 
			{
				if (item.isDirectory())
					addFolderToZip(subFolder
							+ (subFolder.length() > 0 ? "/" : "")
							+ item.getName(), item.getPath(), zip);
				else {
					addFileToZip(subFolder, item.getPath(), zip);
				}
			}

			return true;
		} catch (Exception e) {
			e.printStackTrace();

		}
		return false;
	}
	


    public static void testUnzip() 
    {
        String zipFilePath = "/Users/pankaj/tmp.zip";
        
        String destDir = "/Users/pankaj/output";
        
        unzip(zipFilePath, destDir);
    }

    public static void unzip(String zipFilePath, String destDir) {
        File dir = new File(destDir);
        // create output directory if it doesn't exist
        if(!dir.exists()) dir.mkdirs();
        FileInputStream fis;
        //buffer for read and write data to file
        byte[] buffer = new byte[1024];
        try {
            fis = new FileInputStream(zipFilePath);
            ZipInputStream zis = new ZipInputStream(fis);
            ZipEntry ze = zis.getNextEntry();
            while(ze != null){
                String fileName = ze.getName();
                File newFile = new File(destDir + File.separator + fileName);
                // System.out.println("Unzipping to "+newFile.getAbsolutePath());
                //create directories for sub directories in zip
                new File(newFile.getParent()).mkdirs();
                FileOutputStream fos = new FileOutputStream(newFile);
                int len;
                while ((len = zis.read(buffer)) > 0) {
                fos.write(buffer, 0, len);
                }
                fos.close();
                //close this ZipEntry
                zis.closeEntry();
                ze = zis.getNextEntry();
            }
            //close last ZipEntry
            zis.closeEntry();
            zis.close();
            fis.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }


}
