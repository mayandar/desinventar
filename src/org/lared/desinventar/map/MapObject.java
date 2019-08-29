package org.lared.desinventar.map;

import java.io.*;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.jsp.JspWriter;

import java.awt.*;
import java.awt.image.*;

import org.lared.desinventar.dbase.DBase;
import org.lared.desinventar.util.*;
import org.lared.desinventar.webobject.*;

import org.lared.desinventar.dbase.*;

public class MapObject
{
	// this is the threshold to virtualize a file or fully load it in memory, 30 MB!.
	public int MAXMEMORYSIZE=50000000; 
	public final int DI_format=-1;
	public final int AV_NullShape=0 ;
	public final int AV_Point=1 ;
	public final int AV_PolyLine=3 ;
	public final int AV_Polygon=5 ;
	public final int AV_MultiPoint=8 ;
	public final int AV_PointZ=11;
	public final int AV_PolyLineZ=13;
	public final int AV_PolygonZ=15;
	public final int AV_MultiPointZ=18;
	public final int AV_PointM=21;
	public final int AV_PolyLineM=23;
	public final int AV_PolygonM=25;
	public final int AV_MultiPointM=28;
	public final int AV_MultiPatch=31;
	
	public final double deg170=3.141592*170.0/180.0;

	// mandatory for level maps. This will connect with DesInventar Geography 
	public String sCodeField="";

	// field names with default names coming from the MAP
	public String sNameField="";
	public String sName_enField="";

	// This is to load a thematic layer proper names with Unicode, etc, from DI database
	public Connection con=null;

	public int level=0;

	public String sShapefileName="";
	public int shape_type=AV_Polygon;  // default
	public ArrayList<ArcObject> lArcs=new ArrayList<ArcObject>();	
	public double xmin=1800000, ymin=900000, xmax=-1800000, ymax=-1800000, mmin=0, mmax=0, zmin=0,zmax=0;
    // point/shape types M and Z
	public boolean bZmeasures=false;
	public boolean bMmeasures=false;
	


	boolean bInMemory=true;
	boolean bLoaded=false;
	boolean bLoading=false;
	// number of references
	int nCount=0;
	long filelength=100;
	long currpos=101;

	RandomAccessFile f_arc=null;
	DBase db=null;

	private int nBufferSize=10000; 
	byte[] buffer = new byte[nBufferSize];
	public MapObject(String sShapefile)
	{
		sShapefileName=sShapefile;

	}

	/** java.awt.Color from an HTML color  string #RRGGBB */
	public Color gColorFromString(String strColor)
	{
		int r = 0, g = 0, b = 0;

		if (strColor == null || strColor.length() == 0)
			strColor = "#";
		strColor += "000000";
		try
		{
			r = Integer.parseInt(strColor.substring(1, 3), 16);
		}
		catch (Exception er)
		{}
		try
		{
			g = Integer.parseInt(strColor.substring(3, 5), 16);
		}
		catch (Exception eg)
		{}
		try
		{
			b = Integer.parseInt(strColor.substring(5, 7), 16);
		}
		catch (Exception eb)
		{}

		return new Color(r, g, b);
	}

	private void setBufferSize(int newSize)
	{
		if (newSize>nBufferSize)
		{
			nBufferSize=newSize+5000;
			buffer = new byte[nBufferSize];
		}
	}

	public void SetCodeField(String sc){
		sCodeField=sc;
	}

	public void SetConnection(Connection scon){
		con=scon;
	}

	public void SetNameField(String nf)
	{
		sNameField=nf;
		if (sNameField.length()==0)
			sNameField=sCodeField;
	}

	public void SetNameEnField(String nef)
	{
		sName_enField=nef;
		if (sName_enField.length()==0)
			sName_enField=sNameField;
	}

	public void SetLevel(int lev)
	{
		level=lev;
	}


	/**
	 * gets a suitable xdev position for a name
	 * 
	 */

	public int StringLength(Graphics2D g2, String sName)
	{
		return sName.length()*6;
		//	   FontMetrics fmt= g2.getFontMetrics(g2.getFont());
		//	   int lon=fmt.stringWidth(sName);   // fmt.getHeight() gives the height 
		//	   return lon;
	}

	// this scans one side of a polygon, inserting intersentions in the array
	void scan_convert(int xx, int xr, int yr, int xs, int ys, ArrayList[] hashv)
	{
		int i, j, k;
		int x_act,xar, xxx;
		double pend, y_act;

		//* para cada lado [i -> i+1], tamano puntos ,tamano-1 lados
		//* LADOS NO VERTICALES (O NULOS!!!)
		if (xr != xs)
		{
			//* los ordena de izq a derecha
			if (xr > xs)
			{
				xxx = xr;
				xr = xs;
				xs = xxx;
				xxx = yr;
				yr = ys;
				ys = xxx;
			}

			if (xs >= 0 && xr <= xx)
			{
				//* calcula pendiente, primer Y, paso en y
				pend = (double) (ys - yr) / (xs - xr);
				if (xr <= 0)
				{
					x_act = 0;
					y_act = yr -xr * pend;                      
					j = 0;
				}
				else
				{
					//* calcula interseccion menor o igual
					j = xr;
					x_act = xr;
					y_act = yr;
				}
				if (xs>xx)
					xs=xx;
				while (x_act < xs)
				{
					hash_insert(j, (int) (y_act),hashv);
					j++;
					y_act += pend;
					x_act++;
				}
			} //* no verts
		}
	}

	void hash_insert(int nWhere, int y, ArrayList[] hashv)
	{
		try
		{
			// 	   if (nWhere<hashv.length && nWhere>=0)
			// 	   {
			if (hashv[nWhere] == null)
			{
				hashv[nWhere] = new ArrayList();
				hashv[nWhere].add(new Integer(y));
			}
			else
			{
				int k = 0;
				while (k < hashv[nWhere].size() && (y > ( (Integer) (hashv[nWhere].get(k))).intValue()))
					k++;
				hashv[nWhere].add(k,new Integer(y));
			}

			//	   }

		}
		catch (Exception e)
		{
			System.out.println("CV1: Exception hash-inserting "+nWhere);
		}
	}

	void scan_plot(int xm, int xx, ArrayList[] hashv, Graphics2D g2)
	{
		Stroke currStroke=g2.getStroke();
		g2.setStroke(new BasicStroke(1.0f));
		int i, k, iy1, iy2;
		//* recorre las listas de intersecciones
		for (i = 0; i < hashv.length; i++)
		{
			if (hashv[i] != null)
			{
				k = 0;
				while (k < hashv[i].size() - 1)
				{
					iy1 = ( (Integer) (hashv[i].get(k++))).intValue();
					iy2 = ( (Integer) (hashv[i].get(k++))).intValue();
					if (iy1!=iy2)
						g2.drawLine(i, iy1, i, iy2);
				}
			}
		}
		// libera espacio de interseccs
		for (i = 0; i <hashv.length; i++)
			hashv[i] = null;
		g2.setStroke(currStroke);

	}

	public void fillVector(ArcObject arco, Graphics2D g2, MapTransformation m, Color cBorderColor)
	{
		fillVector(arco, g2, m);
		//       g2.setColor(cBorderColor);
		//	     if (cBorderColor.getBlue()!=256 || cBorderColor.getRed()!=255 || cBorderColor.getGreen()!=255)
		//	   	   plotVector(arco, g2, m);
	}

	public void fillVector(ArcObject arco, Graphics2D g2, MapTransformation m)
	{
		ArrayList[] hashv = new  ArrayList[(int) m.xresolution+2]; 
		// initializes all interseccs
		for (int i = 0; i <= (int) m.xresolution; i++)
			hashv[i] = null;


		while (arco!=null)
		{
		int nSize;
		int i=0;
		for (int k = 0; k<arco.numparts; k++)
		{
			nSize = arco.parts[k+1]-arco.parts[k];
			int currentX = m.xdev(arco.xcoo[i]);
			int currentY = m.ydev(arco.ycoo[i]);
			i++;
			for (int j = 1; j < nSize; j++)
			{
				int x = m.xdev(arco.xcoo[i]);
				int y = m.ydev(arco.ycoo[i]);
				i++;
				if (currentX!=x)
					scan_convert((int) m.xresolution, currentX, currentY, x,y, hashv);
				currentX = x;
				currentY = y;
			}
		}
			arco=arco.aNextArc;
		}
		scan_plot(0, (int) m.xresolution, hashv, g2);     
	}

	void plotVector(ArcObject arco, Graphics2D g2, MapTransformation m)
	{
		while (arco!=null)
		{
		int nSize;
		int i=0;
		for (int k = 0; k<arco.numparts; k++)
		{
			nSize = arco.parts[k+1]-arco.parts[k];
			int currentX = m.xdev(arco.xcoo[i]);
			int currentY = m.ydev(arco.ycoo[i]);
			i++;
			for (int j = 1; j < nSize; j++)
			{
				int x = m.xdev(arco.xcoo[i]);
				int y = m.ydev(arco.ycoo[i]);
				i++;
				if (currentX!=x || currentY!=y)
				{
					g2.drawLine(currentX, currentY, x, y);
					currentX = x;
					currentY = y;
				}
			}
		}
			arco=arco.aNextArc;
		}
	}


	void plotPoints(ArcObject arco, Graphics2D g2, MapTransformation m)
	{
		for (int k = 0; k<arco.numpoints; k++)
		{
			int ixcoo = m.xdev(arco.xcoo[k]);
			int iycoo = m.ydev(arco.ycoo[k]);

			int nsize=4; // Math.max(20,(int)(Math.round(1+Math.sqrt(arco.zcoo[k])/2)));

			/*        if (arco.zcoo!=null)
        	if (arco.zcoo[k]==1)
        		nsize=4;
        	else if (arco.zcoo[k]<=5)
        		nsize=5;
        	else if (arco.zcoo[k]<=10)
        		nsize=6;
        	else 
        		nsize=7;
			 */

			int nsize2=nsize/2;

			g2.fillRect(ixcoo-nsize2,iycoo-nsize2, nsize, nsize);
		}
	}


	public int getShort(byte[] buffer, int offset)
	{
		int ix1 = buffer[offset++] & 0xff;
		int ix2 = buffer[offset] & 0xff;
		return ix2 <<8  | ix1;
	}

	boolean safe = false;

	public int getInt(byte[] buffer, int offset)
	{

		int ix1 = buffer[offset++] & 0xff;
		int ix2 = buffer[offset++] & 0xff;
		int ix3 = buffer[offset++] & 0xff;
		int ix4 = buffer[offset] & 0xff;
		return (((((ix4 << 8) | ix3) << 8) | ix2) <<8) | ix1;

	}

	public int getShortBig(byte[] buffer, int offset)
	{
		int ix2 = buffer[offset++] & 0xff;
		int ix1 = buffer[offset] & 0xff;
		return ix2 << 8 | ix1;
	}

	public int getIntBig(byte[] buffer, int offset)
	{
		int ix4 = buffer[offset++] & 0xff;
		int ix3 = buffer[offset++] & 0xff;
		int ix2 = buffer[offset++] & 0xff;
		int ix1 = buffer[offset] & 0xff;
		return (((((ix4 << 8) | ix3) << 8) | ix2) <<8) | ix1;
	}

	public long getLong(byte[] buffer, int offset)
	{
		long iRet = 0;
		for (int i = offset + 7; i >= offset; i--)
		{
			int ix = buffer[i] & 0xff;
			iRet = (iRet << 8) | ix;
		}
		return iRet;
	}

	public double getDouble(byte[] buffer, int offset)
	{
		double dRet = 0;
		long iRet = getLong(buffer, offset);
		dRet = Double.longBitsToDouble(iRet);
		return dRet;
	}


	public boolean readArcViewPoint(ArcObject arco, MapTransformation m)
	{
		boolean bNotEof=true;
		try
		{
			int nToRead =(int)filelength-100;
			setBufferSize(nToRead);
			f_arc.readFully(buffer, 0, nToRead);

			arco.numpoints=nToRead/28;
			arco.numparts=1;
			arco.parts=new int[2];
			arco.parts[0]=0;
			arco.parts[1]=arco.numpoints;
			arco.xcoo = new double[arco.numpoints];
			arco.ycoo = new double[arco.numpoints];	  	  

			if (this.sCodeField.length()>0)
			{
				arco.aCode = new String[arco.numpoints];
				arco.aName = new String[arco.numpoints];
				arco.aName_en = new String[arco.numpoints];
	
			}
			int offset=0;
			int i=0;
			while (offset<nToRead)
			{
				int rec_num=getIntBig(buffer,offset);
				int rec_len=getIntBig(buffer,offset+4);
				int ntype=getInt(buffer,offset+8);
				regiones rg=new regiones();
				//System.out.println("point # "+rec_num+" len="+rec_len+" offset="+offset+" internal counter="+i);
				if (ntype==1) // safeguard. Current spec requires no mix of shape types
				{
					arco.xcoo[i] =getDouble(buffer,offset+12);      		  //' x, little
					arco.ycoo[i] =getDouble(buffer,offset+20);      	  //' y, little
					arco.xmin=Math.min(arco.xmin, arco.xcoo[i]);
					arco.xmax=Math.max(arco.xmax, arco.xcoo[i]);
					arco.ymin=Math.min(arco.ymin, arco.ycoo[i]);
					arco.ymax=Math.max(arco.ymax, arco.ycoo[i]);
					if (this.sCodeField.length()>0)
					{
						if (db.next())
						{
							arco.sCode=db.getString(sCodeField);
							// NUMERIC FIELDS HAVE A DECIMAL POINT AND A ZERO - EVEN IF THEY ARE INTEGER. REMOVE THIS...
							if (arco.sCode.endsWith(".0"))
								arco.sCode=arco.sCode.substring(0,arco.sCode.length()-2);
							arco.aCode[i]=rg.codregion=arco.sCode;
							int n=con==null?0:rg.getWebObject(con);
							arco.aName[i]=db.getString(sNameField);
							arco.aName_en[i]=db.getString(sName_enField);
							if (n>0)
							{
								arco.aName[i]=rg.nombre;	
								arco.aName_en[i]=rg.nombre_en;	
							}
						}
					}
					i++;
				}
				offset+=28;
			}
			bNotEof=false;      

		}
		catch (Exception e)
		{
			bNotEof=false;
			System.out.println("DI9: Exception reading A/V:"+e.toString());
		}
		return bNotEof;
	}



	public boolean readArcViewArc(ArcObject arco, MapTransformation m)
	{
		boolean  bNotEof=true; 
		try
		{
			int nToRead =52; // 4+4+4+8+8+8+8+4+4
			f_arc.readFully(buffer, 0, nToRead);

			arco.rec_num=getIntBig(buffer, 0);
			arco.rec_len=getIntBig(buffer, 4)*2;  // length in words !
			
			arco.shape_type=getInt(buffer, 8);
			// decode the bounding box
			arco.xmin=getDouble(buffer, 12);
			arco.ymin=getDouble(buffer, 20);
			arco.xmax=getDouble(buffer, 28);
			arco.ymax=getDouble(buffer, 36);
			arco.numparts=getInt(buffer, 44);
			arco.numpoints=getInt(buffer, 48);
			arco.lArcPointer=f_arc.getFilePointer();      
			readShapeArc(arco, m);
			if (this.shape_type==this.AV_PolygonZ || this.shape_type==this.AV_PolyLineZ)
			{
				nToRead =16+arco.numpoints*8; // 2 double fields + double[nPoints] vector
				f_arc.readFully(buffer, 0, nToRead);  // buffer must be enough
				// M measures are optional
				if (arco.rec_len>60+arco.numparts*4+arco.numpoints*24)    // 60=  52 bytes as above, minus 8 of the rec header plus 16 of zmin,zmax 
				{
					nToRead =16+arco.numpoints*8; // 2 double fields + double[nPoints] vector
					f_arc.readFully(buffer, 0, nToRead);  // buffer must be enough
				}
			}			
		}
		catch (Exception e)
		{
			bNotEof=false;
		}
		return bNotEof;
	}


	private void readShapeArc(ArcObject arco, MapTransformation m) throws IOException 
	{
		
		int MaxBufferSize=arco.numparts*4+arco.numpoints*16;

		setBufferSize(MaxBufferSize);
		arco.parts=new int[arco.numparts+2];
		arco.parts[0]=0;
		f_arc.readFully(buffer, 0,arco.numparts*4);
		for (int j = 0; j<arco.numparts; j++)
		{
			arco.parts[j]=getInt(buffer, j*4);
			if (arco.parts[j]<0)
			{
				arco.parts[j]=0;
			}
		}
		arco.parts[arco.numparts]=arco.numpoints;
		f_arc.readFully(buffer, 0,arco.numpoints*16);
		arco.xcoo = new double[arco.numpoints];
		arco.ycoo = new double[arco.numpoints];	  	  
		int offset=0;
		for (int j = 0; j<arco.numpoints; j++)
		{
			arco.xcoo[j] =getDouble(buffer, offset);      		  //' x, little
			offset += 8;
			arco.ycoo[j] =getDouble(buffer, offset);      	  //' y, little
			offset += 8;
		}
	}

	/**
	 *  Arc view file header record - 100 bytes
	 *   opens all map files and database

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
   
   * Unused, with value 0.0 if not measured or Z type

   */

	public boolean openMap()
	{
		boolean bRet = true;

		try
		{
			// System.out.println("Starting processing:"+sShapefileName);
			File f=new File(sShapefileName);
			if (f.exists() && f.isFile())
			{
				filelength=(int) f.length();
				if (filelength<MAXMEMORYSIZE)
					bInMemory=true;

				f_arc = new RandomAccessFile(sShapefileName, "r");
				f_arc.readFully(buffer, 0, 100);
				int filecode=getIntBig(buffer, 0);
				// filelength=getIntBig(24);
				int version=getInt(buffer, 28);
				shape_type=getInt(buffer, 32);

				// WE ASSUME IT IS A LAT-LON  file.   
				xmin=getDouble(buffer, 36);
				ymin=getDouble(buffer, 44);
				xmax=getDouble(buffer, 52);
				ymax=getDouble(buffer, 60);

				zmin=getDouble(buffer, 68);
				zmax=getDouble(buffer, 76);
				if (zmin!=0.0 || zmax!=0.0)
					this.bZmeasures=true;

				mmin=getDouble(buffer, 84);
				mmax=getDouble(buffer, 92);
				if (mmin!=0.0 || mmax!=0.0)
					this.bMmeasures=true;
				
				
				// support for points, polygons and polylines only
				boolean bNotEof=false;
				switch (shape_type)
				{
				case AV_Point:
				case AV_PointZ:
				case AV_PointM:
				case AV_PolyLine:
				case AV_Polygon:
				case AV_PolyLineZ:
				case AV_PolygonZ:
				case AV_PolyLineM:
				case AV_PolygonM:
					bNotEof=true;
				}
			}
		}
		catch (Exception e)
		{
			System.out.println("DI9: Exception opening: " + e.toString());
		}

		return bRet;
	}

	public boolean closeMap()
	{
		boolean bRet = true;

		try
		{
			if (f_arc!=null)
				f_arc.close();
		}
		catch (Exception e)
		{
			System.out.println("[DI9] MapObject: Exception closing: " + e.toString());
		}

		return bRet;
	}


	public boolean openTable()
	{
		boolean bRet=true;
		int pos=sShapefileName.lastIndexOf("/");

		try{
			String sDbaseDir=sShapefileName.substring(0,pos);
			int pos2=sShapefileName.lastIndexOf(".");
			String sDbaseTable=sShapefileName.substring(pos+1,pos2);
			db = new DBase(sDbaseDir);
			db.setMemoHandler(DBase.DBASEIII);
			db.openTable(sDbaseTable);
			}
		catch (Exception e)
		{
			System.out.println("DI9: Error Loading DBASE:"+e.toString());
		}


		return bRet;
	}


	private int calculateColorIndex(DICountry countrybean, Double sVal) 
	{
		int k = 0;
		if (sVal != null)
		{
			double dVal = sVal.doubleValue();
			while ( (k < 10) && (countrybean.asMapRanges[k] < dVal) && (countrybean.asMapRanges[k] > 0))
				k++;
		}
		else 
			k=-1;
		return k;
	}

	private Color calculateColor(Graphics2D g2, Color cFillColor, DICountry countrybean, Double sVal, MapTransformation m, ArcObject arco) 
	{
		int k = calculateColorIndex(countrybean, sVal);
		if (k>=0)
		{
			cFillColor=gColorFromString(countrybean.asMapColors[k]);
		}
		else
			cFillColor=null;
		return cFillColor;
	}


	private void showValue(Graphics2D g2, DICountry countrybean, MapTransformation m, ArcObject arco, double dVal) 
	{
		g2.setColor(Color.darkGray);
		String sValue=countrybean.formatDouble(dVal);
		g2.drawString(sValue , m.xdev((arco.xmax+arco.xmin)/2)-StringLength(g2,sValue)/2, m.ydev((arco.ymax+arco.ymin)/2)+(countrybean.nShowIdType>0?12:0));
	}

	/**
	 * @param g2
	 * @param cBorderColor
	 * @param cFillColor
	 * @param countrybean
	 * @param htData
	 * @param m
	 * @param arco
	 * @param sVal
	 */
	public void renderPointMap(Graphics2D g2, Color cBorderColor, Color cFillColor, DICountry countrybean, HashMap htData, MapTransformation m, ArcObject arco, int nShowIdType) 
	{
		try{
			for  (int kp=0; kp<arco.numpoints; kp++)
			{
				Double sVal=null;
				double dVal=0;
				int xc=m.xdev(arco.xcoo[kp]);
				int yc=m.ydev(arco.ycoo[kp]);
				if ((this.sCodeField.length()>0 && arco.aCode[kp].length()>0 && htData!=null ))  // codes and data.. color needs to be determined
				{
					sVal=(Double) (htData.get(arco.aCode[kp]));
					int k = calculateColorIndex(countrybean, sVal);
					if (sVal!=null) 
						dVal=sVal.doubleValue();
					// first fills the polygon
					if (k>=0)
					{
							cFillColor=gColorFromString(countrybean.asMapColors[k]);
							g2.setColor(cFillColor);
							k++;
							if (countrybean.nMapType <= 1)
							{
								g2.fillOval(xc-k*2, yc-k*2,k*4,k*4);
							}
							else if (countrybean.nMapType == 2)
							{
								g2.fillRect(xc-3, yc-k*4-3,6,k*4);
								g2.setColor(Color.black);
								g2.drawRect(xc-3, yc-k*4-3,6,k*4);
							}	 
						if (countrybean.nShowValueType == 1)
						{
							g2.setColor(Color.darkGray);
							String sValue=countrybean.formatDouble(dVal);
							g2.drawString(sValue , xc-StringLength(g2,sValue)/2, yc+(countrybean.nShowIdType>0?12:0));
						}
					}
				}
				else{
					// draws the point, anyway
					if (cBorderColor!=null)
						g2.setColor(cBorderColor);
					else
						g2.setColor(Color.darkGray);
					g2.fillRect(xc-2, yc-2,4,4);					
					//g2.fillRect(xc-1, yc-1,2,2);					
				}
				// and now renders name/code and/or value for thematic/effect layers
				if (nShowIdType == 2)
				{
					g2.setColor(Color.darkGray);
					String sName=countrybean.getLocalOrEnglish(arco.sName, arco.sName_en);
					g2.drawString(sName, xc-StringLength(g2,sName)/2, yc);
				}
				else if (nShowIdType == 1)
				{
					g2.setColor(Color.darkGray);
					g2.drawString(arco.sCode, xc-StringLength(g2,arco.sCode)/2, yc);
				}
				
			}
		}
		catch (Exception e)
		{
			System.out.println("DI9: Exception rendering points: "+e.toString());
		}
	}

	/**
	 * @param g2
	 * @param cBorderColor
	 * @param cFillColor
	 * @param countrybean
	 * @param htData
	 * @param m
	 * @param arco
	 * @param sVal
	 */
	public void renderMapObject(Graphics2D g2, Color cBorderColor, Color cFillColor, DICountry countrybean, HashMap htData, MapTransformation m, ArcObject arco, int nShowIdType) 
	{
		try{
			Double sVal=null;
			double dVal=0;

			// this is to take into account the case of FIJI, KIRIBATI, part <-180 -180-> part 
			int xc=(m.xdev(arco.xmax)+m.xdev(arco.xmin))/2;
			int yc=m.ydev((arco.ymax+arco.ymin)/2);
			if ((this.sCodeField.length()>0 && arco.sCode.length()>0 && htData!=null ))  // codes and data.. color needs to be determined
			{
				sVal=(Double) (htData.get(arco.sCode));
				if (sVal!=null) 
				{
					dVal=sVal.doubleValue();
					cFillColor = calculateColor(g2, cFillColor, countrybean, sVal, m, arco);
				}
				// first fills the polygon
				if (cFillColor!=null)
				{
					g2.setColor(cFillColor);
					if (countrybean.nMapType == 0)
						fillVector(arco, g2, m, cBorderColor);
					else{
						int k = calculateColorIndex(countrybean, sVal);
						k++;
						if (countrybean.nMapType == 1)
						{
							g2.fillOval(xc, yc-k*4,k*8,k*8);
						}
						else if (countrybean.nMapType == 2)
						{
							g2.fillRect(xc, yc,10,k*8);
							g2.setColor(Color.black);
							g2.drawRect(xc, yc,10,k*8);
						}	 
					}
					if (countrybean.nShowValueType == 1)
					{
						g2.setColor(Color.darkGray);
						String sValue=countrybean.formatDouble(dVal);
						g2.drawString(sValue , xc-StringLength(g2,sValue)*5, yc+(countrybean.nShowIdType>0?12:0));
					}
				}
			}
			// polygon
			else 
			{
				if (cFillColor!=null)
				{	
					g2.setColor(cFillColor);
					fillVector(arco, g2, m ,cBorderColor);
				}
				if (cBorderColor!=null)
				{
					g2.setColor(cBorderColor);
					if (this.shape_type==AV_Point)
						plotPoints(arco, g2, m);
					else
						plotVector(arco, g2, m);
				}
			}
			// and now renders name/code and/or value for thematic/effect layers
			if (nShowIdType == 2)
			{
				g2.setColor(Color.darkGray);
				String sName=countrybean.getLocalOrEnglish(arco.sName, arco.sName_en);
				g2.drawString(sName, xc-StringLength(g2,sName)/2, yc);
			}
			else if (nShowIdType == 1)
			{
				g2.setColor(Color.darkGray);
				g2.drawString(arco.sCode, xc-StringLength(g2,arco.sCode)/2, yc);
			}

		}
		catch (Exception e)
		{
			System.out.println("DI9: Exception rendering: "+e.toString());
		}
	}

	public void renderMapInMemory(Graphics2D g2, int xResolution, int yResolution, Color cBorderColor, Color cFillColor, DICountry countrybean,  HashMap htData, MapTransformation m, int nShowIdType)
	{
		// the map has previously been used, first call triggered a full scan of the file, loading the index and polygons into memory
		if (shape_type==AV_Point)
		{
			ArcObject arco=(ArcObject)(lArcs.get(0));
			// rendersObject
			if (htData==null)
				{
				g2.setColor(cBorderColor);
				plotPoints(arco, g2, m);
				}
			else
				renderPointMap(g2, cBorderColor, cFillColor, countrybean, htData, m, arco, nShowIdType);
		}
		else
			for (int j=0; j<lArcs.size(); j++)
			{
				ArcObject arco=(ArcObject)(lArcs.get(j));
				if (arco.xmax>m.xminif && arco.ymax>m.yminif && arco.xmin<m.xmaxif && arco.ymin<m.ymaxif)
				{
					renderMapObject(g2, cBorderColor, cFillColor, countrybean, htData, m, arco, nShowIdType);
				}
			}		   
	}

	public void renderMapVirtual(Graphics2D g2, int xResolution, int yResolution, Color cBorderColor, Color cFillColor, DICountry countrybean,  HashMap htData, MapTransformation m, int nShowIdType)
	{
		// the map has been used, first call will triggered a full scan of the file, loading into memory the index of polygons, but size prevented fully loading the polygons
		for (int j=0; j<lArcs.size(); j++)
		{
			ArcObject arco=(ArcObject)(lArcs.get(j));
			if (!(arco.xmax<m.xminif || arco.ymax<m.yminif || arco.xmin>m.xmaxif || arco.ymin>m.ymaxif))
			{
				try{
					while (arco!=null)
					{
						f_arc.seek(arco.lArcPointer);      
						readShapeArc(arco, m);
						// render the object
						renderMapObject(g2, cBorderColor, cFillColor, countrybean, htData, m, arco, nShowIdType);					      	
						// releases memory in large files
						arco.parts=null;
						arco.xcoo=null;
						arco.ycoo=null;
						arco=arco.aNextArc;						
					}
				}
				catch (Exception ioex)
				{
					System.out.println("DI9: Error rendering virtual arc object:"+ioex.toString());
				}
			}
		}

	}


	public void renderMapLoading(Graphics2D g2, int xResolution, int yResolution, Color cBorderColor, Color cFillColor, DICountry countrybean,  HashMap htData, MapTransformation m, int nShowIdType)
	{
		// the map has never been used, so the first call will trigger a full scan of the file, loading the index of polygons
		if (sName_enField.length()==0)
			sName_enField=sNameField;

		try{
			openMap();
			if (this.sCodeField.length()>0)
				openTable();
			if (shape_type==AV_Point)
			{
				ArcObject arco=new ArcObject();
				readArcViewPoint(arco,m);
				if (cBorderColor!=null)
				{
					g2.setColor(cBorderColor);
					// rendersObject
					if (htData!=null)
						plotPoints(arco, g2, m);
					else
						renderMapObject(g2, cBorderColor, cFillColor, countrybean, htData, m, arco, nShowIdType);
				}
				lArcs.add(arco);  
				bInMemory=true;
			}
			else
			{
				boolean bNotEof=true;
				Double sVal;
				HashMap<String, Integer> htCodes=new HashMap<String, Integer>();
				int nrec=0;
				Integer iRec;
				regiones rg=new regiones();
				while (bNotEof)
				{
					ArcObject arco=new ArcObject();
					bNotEof=readArcViewArc(arco,m);
					boolean bDuplicate=false;
					if (this.sCodeField.length()>0)
					{
						if (db.next())
						{
							arco.sCode=db.getString(sCodeField);
							// NUMERIC FIELDS HAVE A DECIMAL POINT AND A ZERO - EVEN IF THEY ARE INTEGER. REMOVE THIS...
							if (arco.sCode.endsWith(".0"))
								arco.sCode=arco.sCode.substring(0,arco.sCode.length()-2);
							rg.codregion=arco.sCode;
							int n=con==null?0:rg.getWebObject(con);
							arco.sName=db.getString(sNameField);
							arco.sName_en=db.getString(sName_enField);
							if (n>0)
							{
								arco.sName=rg.nombre;	
								arco.sName_en=rg.nombre_en;	
							}
							if ((iRec=htCodes.get(arco.sCode))!=null)
							{ // is a multi-polygon feature
								bDuplicate=true;
								if (((ArcObject)(lArcs.get(iRec)))!=null)
									{
										arco.xmin=Math.min(arco.xmin, ((ArcObject)(lArcs.get(iRec))).xmin);
										arco.xmax=Math.max(arco.xmax, ((ArcObject)(lArcs.get(iRec))).xmax);
										arco.ymin=Math.min(arco.ymin, ((ArcObject)(lArcs.get(iRec))).ymin);
										arco.ymax=Math.max(arco.ymax, ((ArcObject)(lArcs.get(iRec))).ymax);										
									}
								arco.aNextArc=((ArcObject)(lArcs.get(iRec)));
								lArcs.set(iRec,arco);
							}
							else
								htCodes.put(arco.sCode, nrec);
						}
					}
					// rendersObject
					renderMapObject(g2, cBorderColor, cFillColor, countrybean, htData, m, arco, nShowIdType);
					// releases memory in large files
					if (!bInMemory)
					{
						arco.parts=null;
						arco.xcoo=null;
						arco.ycoo=null;
					}
					if (!bDuplicate)
					{
						lArcs.add(arco);
						nrec++;
					}					   	
					if (arco.parts!=null)
					{
						xmin=Math.min(xmin,arco.xmin);
						ymin=Math.min(ymin,arco.ymin);
						xmax=Math.max(xmax,arco.xmax);
						ymax=Math.max(ymax,arco.ymax);
					}
				}
			}
			if (this.sCodeField.length()>0)
				db.closeTable();	
		}
		catch (Exception e)
		{
			System.out.println("DI9: Error Loading SHP:"+e.toString());
		}
		System.out.println("DI9: DONE processing shapefiled LOAD...");
		if (bInMemory)
			closeMap();	 
		bLoaded=true;
	}


	public void renderMap(Graphics2D g2, int xResolution, int yResolution, Color cBorderColor, Color cFillColor, DICountry countrybean,  HashMap htData, MapTransformation m, int nShowIdType)
	{
		int iter=0;

		m.setView(xResolution, yResolution);
		m.setTransformation();   

		if (lArcs.size()==0)
			bLoaded=false;
		// other process may be loading this Map object
		while (bLoading)
		{
			try
			{
				Thread.sleep(100);
				//System.out.print("..");
				iter++;
				if (iter==3000)
					bLoading=false; // something wrong must have happened...
			}
			catch (Exception exsleep)
			{
				// do nothing
			}
		}
		
		if (bLoaded)
		{
			if (bInMemory)
				renderMapInMemory(g2, xResolution, yResolution, cBorderColor, cFillColor,  countrybean,   htData, m, nShowIdType);
			else
				renderMapVirtual(g2, xResolution, yResolution, cBorderColor, cFillColor,  countrybean,   htData, m, nShowIdType);
		}
		else
		{
			bLoading=true;
			renderMapLoading(g2, xResolution, yResolution, cBorderColor, cFillColor,  countrybean,   htData, m, nShowIdType);
			bLoading=false;
		}

	}

}
