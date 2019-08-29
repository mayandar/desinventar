package org.lared.desinventar.map;

/**
 * <p>Title: DesInventar WEB Version 7.x Arc/View shapefile renderer</p>
 * <p>Description: On Line Version of DesInventar/DesConsultar 6.</p>
 * <p>Copyright: Copyright (c) 2002  La  Red.</p>  
 * <p>Company: La Red -  La Red de Estudios Sociales en Prevención de Desastres en América Latina</p>
 * @author Julio Serje
 * @version 1.0
 */

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;

import java.awt.*;
import java.awt.image.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.webobject.*;


public class ArcviewServer extends MapServer
{

  public String sShapefileName="";
  int rec_num=0;
  int rec_len=0;
  int shape_type=3;
  int numparts=0;
  int numpoints=0;
  int filelength=100;

 
  
  public void setShapefile(String sShapefileName)
  {
    this.sShapefileName=sShapefileName;
  }

  public void reallocateAreas(int numparts, int numpoints)
  {
  if (numparts*4+numpoints*16> MaxBufferSize)
  	{
	  MaxBufferSize=numparts*4+numpoints*16+1000;
	  buffer = new byte[MaxBufferSize];
  	}
  if (MaxVectorSize<numpoints)
  	{
	  MaxVectorSize=numpoints+100;
	  xcoo = new int[MaxVectorSize];
	  ycoo = new int[MaxVectorSize];	  	  
  	}
  if (nPartSize<numparts)
  	{
	  nPartSize=numparts+50;
	  nParts=new int[nPartSize];	  
  	}
 
  }
  
  
  
  public ArcviewServer()
  {
  }


  public void readArcViewPoint()
  {
    try
    {
      int nToRead =filelength-100;
      
      if (nToRead>= MaxBufferSize)
    	{
  	    MaxBufferSize=nToRead+100;
  	    buffer = new byte[MaxBufferSize];
    	}

      f_arc.readFully(buffer, 0, nToRead);
      
      int offset=0;
      int i=0;
      while (offset<nToRead)
      {
    	  rec_num=getIntBig(offset);
          rec_len=getIntBig(offset+4);
          shape_type=getInt(offset+8);
          System.out.println("point # "+rec_num+" len="+rec_len+" offset="+offset+" internal counter="+(i++));
          if (shape_type==1)
          {
              int xcoo =(int) (getDouble(offset+12)*10000);      		  //' x, little
              int ycoo =(int) (getDouble(offset+20)*10000);      	  //' y, little
              xcoo = mt.xdev(xcoo);
              ycoo = mt.ydev(ycoo);
              g2.fillRect(xcoo-2,ycoo-2, 4, 4);
          }
      	  offset+=28;
      }
      bNotEof=false;      
      
    }
    catch (Exception e)
    {
    	bNotEof=false;
    	System.out.println("Exception reading A/V:"+e.toString());
    }
  }

  
  boolean bNotEof=true;
  public void readArcView()
  {
    try
    {
      int nToRead =52; // 4+4+4+8+8+8+8+4+4
      f_arc.readFully(buffer, 0, nToRead);
      rec_num=getIntBig(0);
      rec_len=getIntBig(4);
      shape_type=getInt(8);
      // don't read the bounding box - lost time
      numparts=getInt(44);
      numpoints=getInt(48);
      /*

                    Get file_shp, , long_var   'big 4
                    paselong long_var, rec_num
                    Get file_shp, , long_var   'big 4
                    paselong long_var, rec_len
                    Get file_shp, , shape_type 'little 4
                    ' lee el registro gráfico
                    Get file_shp, , dx_min    ' xmin, little 8
                    Get file_shp, , dy_min    ' xmin, little 8
                    Get file_shp, , dx_max    ' xmin, little 8
                    Get file_shp, , dy_max    ' xmin, little 8
                    Get file_shp, , numparts  'little 4
                    Get file_shp, , numpoints 'little 4
*/
  
      reallocateAreas(numparts,numpoints);
      f_arc.readFully(buffer, 0,numparts*4);
      for (int j = 0; j<numparts; j++)
    	  nParts[j]=getInt(j*4);
      nParts[numparts]=numpoints;
      f_arc.readFully(buffer, 0,numpoints*16);
      int offset=0;
      //ap_descripcion = 0;
      for (int k = 0; k<numparts; k++)
      	{
    	  tamano = nParts[k+1]-nParts[k];
          for (int j = 0; j<tamano; j++)
      		{
    	        xcoo[j] =(int) (getDouble(offset)*10000);      		  //' x, little
    	        offset += 8;
    	        ycoo[j] = (int) (getDouble(offset)*10000);      	  //' y, little
    	        offset += 8;
      		}
           devVector();
           plotVector();
      	}

/*                    For j = 1 To numparts
                                        Get file_shp, , parts(j)  'little
                                        Next
                                For j = 1 To numpoints
                                        Get file_shp, , points_x(j)  ' x, little
                                        Get file_shp, , points_y(j)  ' y, little
                                        Next
*/

    }
    catch (Exception e)
    {
    	bNotEof=false;
    }
  }

  /**
   * Expands & plots an area in certain level. If level=0, normally all areas are plotted. 
   * @param level level to be drawn
   * @request http Request object with user params
   */
  public void plotLevel(int level, String code, ServletRequest request)
  {
	  
  }

  public void plotShapefile()
  {
	  try{
		  while (bNotEof)
			  if (shape_type==1)
				  readArcViewPoint();		  	  
			  else
				  readArcView();		  	  
		  f_arc.close();
	  }
	  catch (Exception e)
	  {
		  System.out.println("Error plotting AV shp:"+e.toString());
	  }
  //   System.out.println("DONE processing");
  }

  /* Arc view file header record - 100 bytes
  Position	Field 		Value 		Type 		Order
  Byte 0 	FileCode	9994 		Integer 	Big
  Byte 4 	Unused 		0 		Integer 	Big
  Byte 8 	Unused 		0 		Integer 	Big
  Byte 12 	Unused 		0 		Integer 	Big
  Byte 16 	Unused 		0 		Integer 	Big
  Byte 20 	Unused 		0 		Integer 	Big
  Byte 24 	File Length 	File Length 	Integer 	Big
  Byte 28 	Version 	1000 		Integer 	Little
  Byte 32 	Shape Type 	Shape Type 	Integer 	Little
  Byte 36 	Bounding Box 	Xmin 		Double 		Little
  Byte 44 	Bounding Box 	Ymin 		Double 		Little
  Byte 52 	Bounding Box 	Xmax 		Double 		Little
  Byte 60 	Bounding Box 	Ymax 		Double 		Little
  Byte 68* 	Bounding Box 	Zmin 		Double 		Little
  Byte 76* 	Bounding Box 	Zmax 		Double 		Little
  Byte 84* 	Bounding Box 	Mmin 		Double 		Little
  Byte 92* 	Bounding Box 	Mmax 		Double 		Little
*/

  // opens all map files and database
  public boolean openMap(DICountry countrybean, Graphics2D g2d, Connection con, int xresolution, int yresolution, boolean checkbounds)
  {
    boolean bRet = true;

    mt.xresolution = xresolution;
    mt.yresolution = yresolution;
    this.con = con;
    this.countrybean = countrybean;
    sCountryCode = countrybean.getCountrycode();
    g2d.setColor(Color.black);
    
    if (hashv==null)
    	{
    	hashv = new ArrayList[ (int) xresolution + 2];
        for (int i = 0; i <= xresolution; i++)
            hashv[i] = null;
    	}

    try
    {
      // opens the window textfile
      if (sShapefileName.length()==0)
        sShapefileName=countrybean.countryname;

      String sFileName = sShapefileName+".shp";
      
    //   System.out.println("Starting processing:"+sFileName);
      File f=new File(sFileName);
      if (f.exists() && f.isFile())
      {
          filelength=(int) f.length();
          f_arc = new RandomAccessFile(sFileName, "r");
          f_arc.readFully(buffer, 0, 100);
          int filecode=getIntBig(0);
          // filelength=getIntBig(24);
          int version=getInt(28);
          shape_type=getInt(32);
    	  double xm=getDouble(36)*10000;
    	  double ym=getDouble(44)*10000;
    	  double xx=getDouble(52)*10000;
    	  double yy=getDouble(60)*10000;

          // support for points, polygons and polylines only
          bNotEof=false;
    	  switch (shape_type)
    	  {
    	  case 1:
    	  case 3:
    	  case 5:
    		  bNotEof=true;
    	  }

    	  if (checkbounds){
    		  mt.xminif=xm;
    		  mt.yminif=ym;
    		  mt.xmaxif=xx;
    		  mt.ymaxif=yy;
              mt.setTransformation(mt.xminif,mt.yminif,mt.xmaxif,mt.ymaxif);
          }
          else
          {
        	  if (xx<mt.xminif ||
        		  yy<mt.yminif ||
        		  xm>mt.xmaxif ||
        		  ym>mt.ymaxif)
        		  bNotEof=false;	  
          }    	  
      }

    }
    catch (Exception e)
    {
      System.out.println("Exception opening: " + e.toString());
    }

    return bRet;
  }


  public static void main(String[] args)
  {
 
//    org.lared.desinventar.dbase.Test.main(args);
	  
    ArcviewServer ms = new ArcviewServer();
    DICountry countrybean = new DICountry();
    countrybean.country = new country();
    countrybean.countrycode = "CO";
    countrybean.country.sjetfilename = "d:/bases_6";

    BufferedImage buffImage = new BufferedImage(600, 600, BufferedImage.TYPE_INT_RGB);
    // Create a graphics object from the image
    Graphics2D graphics = (Graphics2D) buffImage.getGraphics();
    graphics.setColor(Color.white);
    graphics.fillRect(0, 0, 600, 600);
    // ms.setShapefile("C:/ESRI/ESRIDATA/indonesia/IDN_ADM2");
    ms.setShapefile("C:/temp/Myanmar/Maps/urban_all");
    
    ms.openMap(countrybean, graphics, null, 600, 600);
    ms.plotLevel(0, "", null);

	byte[] pngbytes;
	PngEncoderB png =  new PngEncoderB( buffImage, PngEncoder.ENCODE_ALPHA,	0,1);
	try
	{
		pngbytes = png.pngEncode();
		if (pngbytes == null) {
			System.out.println("MAP: Null image");
		}
		new FileOutputStream("c:/temp/av_indo.jpg").write(pngbytes);
		
	}
	catch (Exception e)
	{
		e.printStackTrace();
	}

  }

}