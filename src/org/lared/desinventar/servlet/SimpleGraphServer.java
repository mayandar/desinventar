package org.lared.desinventar.servlet;

import java.awt.*;
import java.awt.image.*;
import java.io.*;
import javax.servlet.*;

import java.awt.geom.*;
import javax.swing.*;

import org.lared.desinventar.util.*;
import org.lared.desinventar.system.*;
import org.lared.desinventar.webobject.*;

import org.apache.poi.hssf.dev.*;
import org.apache.poi.hssf.model.*;
import org.apache.poi.hssf.record.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.*;
import org.apache.poi.util.StringUtil;

public class SimpleGraphServer extends GenericServlet
{


    int maxCharHeight = 15;
    int minFontSize = 6;

    Color bg = Color.white;
    Color fg = Color.black;
    Color red = Color.red;
    Color white = Color.white;

    BasicStroke stroke = new BasicStroke(2.0f);
    BasicStroke wideStroke = new BasicStroke(8.0f);

    float dash1[] = {10.0f};
    BasicStroke dashed = new BasicStroke(1.0f, BasicStroke.CAP_BUTT,
                                               BasicStroke.JOIN_MITER,
                                               10.0f, dash1, 0.0f);
    Dimension totalSize;
    FontMetrics fontMetrics;


    //----------------------------------------------------------------------------
    // interface variables
    //----------------------------------------------------------------------------

    // Graphics context objects
    Graphics2D g2;
    Graphics g;


    //  values to be plotted
    double[] x;                     // x values (x[nPoints])
    double[][] y;                   // multiple sets of y values y[nSet][nPoints]
    Color[]  cSetColor;             // color of each set  cSetColor[nSet]
    String[] sSetLabels;            // label of each set sSetLabel[nSets]
    String[] sLabels;               // label of each value sLabel[nPoints]
    int nPoints=10;                 // number of points
    int nSets=1;                    // number of sets

    boolean b3dEffect=true;         // 3d effect on

    // custom values of the chart
    Color cLabelColor;              // color for labels
    int nLabelColorType;            // type of coloring method for labels

    double  xMin=0,
            xMax=10,
            yMin=0,
            yMax=500;              // World boundaries

    double  xcMin=0,
            xcMax=10,
            ycMin=0,
            ycMax=500;              // Chart boundaries

    int     dyMax=500,
            dxMax=640;              // Device boundaries

    double xScale, yScale;
    double xTrans, yTrans;

    // space around the charts
    double dLeftOffset=10.0;        //  left of x=0, to put Y axis coordinates
    double dRightOffset=20.0;       //  right of x=xcMax, tu put set names
    double dLowerOffset=15.0;       //  below y=0, to put X axis legend
    double dUpperOffset=5.0;        //  above y=ycMax, tu put Titles


    int nChartType=0;               // type of chart:
    final int LINETYPE=0;           //                  0-line,
    final int BARTYPE=1;            //                  1-bar,
    final int PIETYPE=2;            //                  2-Pie,
    final int STACKBARTYPE=3;       //                  3-stacked bar,
    final int STACKLINETYPE=4;      //                  4-stacked line,
    final int SCATTEREDVALUES=5;    //                  5-SCATTERED VALUES


    
    public void excel_test()
    {
    	// create a new workbook
    	HSSFWorkbook workBook = null;
    	//create a new worksheet
    	HSSFSheet sheet=null;
    	

    	try{
        	InputStream inp = new FileInputStream("workbook.xls");
        	workBook = new HSSFWorkbook(inp);
        	sheet = workBook.getSheetAt(0);

        	HSSFRow row = sheet.getRow(2);
        	HSSFCell cell = row.getCell((short)3);
       	    if (cell == null)
        	        cell = row.createCell((short)3);
       	    cell.setCellType(HSSFCell.CELL_TYPE_STRING);
       	    cell.setCellValue("a test");

        	    // Write the output to a file
        	    FileOutputStream fileOut = new FileOutputStream("workbook.xls");
        	    workBook.write(fileOut);
        	    fileOut.close();    		
    	}
    	catch (Exception e)
    	{
    		
    	}

    }
    
    //----------------------------------------------------------------------------
    // number of points in each set
    //----------------------------------------------------------------------------
    public void setNpoints(int nP)
    {
    nPoints=nP;
    }

    //----------------------------------------------------------------------------
    // number of sets
    //----------------------------------------------------------------------------
    public void setNsets(int nS)
    {
    nSets=nS;
    }

    //----------------------------------------------------------------------------
    // allocates space for vectors
    //----------------------------------------------------------------------------
    public void initVectors()
    {
    x=new double[nPoints+2];         // x values (x[nPoints])
    y=new double[nSets][nPoints+2];  // multiple sets of y values y[nSet][nPoints]
    cSetColor=new Color[nSets];    // color of each set  cSetColor[nSet]
    sSetLabels=new String[nSets];  // label of each set sSetLabel[nSets]
    sLabels=new String[nPoints+2];   // label of each value sLabel[nPoints]
    }

    //----------------------------------------------------------------------------
    // calculates the world-to-device transformation matrix
    //----------------------------------------------------------------------------
    public void setTransformation()
    {
    AffineTransform Tx;

    // scaling factor
    xScale=dxMax/(xMax-xMin);
    yScale=dyMax/(yMax-yMin);

    // translation
    xTrans=-xMin * xScale;
    yTrans=dyMax + yMin*yScale;

    // inverts the axis and translate the origin NOT WORKING AS EXPECTED!!!
    // double m00, double m10, double m01, double m11, double m02, double m12
    // Tx=new AffineTransform(1.0, 0.0, 0.0, -1.0, 0.0, dyMax);
    // g2.setTransform(Tx);

    }

    //----------------------------------------------------------------------------
    // sets the size of the device coordinates
    //----------------------------------------------------------------------------
    public void setDevice(int dxMax, int dyMax)
    {
    this.dxMax=dxMax;
    this.dyMax=dyMax;
    setTransformation();
    }

    //----------------------------------------------------------------------------
    // sets the window of world coordinates
    //----------------------------------------------------------------------------
    public void setWorld(double xMin, double yMin, double xMax, double yMax)
    {
    this.xMax=xMax;
    this.yMax=yMax;
    this.xMin=xMin;
    this.yMin=yMin;
    setTransformation();
    }

    //----------------------------------------------------------------------------
    // sets the window of chart coordinates
    //----------------------------------------------------------------------------
    public void setChartWorld(double xMin, double yMin, double xMax, double yMax)
    {
    double dLeft, dRight, dBelow, dAbove;

    xcMax=xMax;
    ycMax=yMax;
    xcMin=xMin;
    ycMin=yMin;
    // space for Axis, Leyends, etc.
    dLeft=(xcMax-xcMin)/dLeftOffset;            // -> before x=0
    dRight=(xcMax-xcMin)/dRightOffset;          // -> right of x=xcMax
    dBelow=(ycMax-ycMin)/dLowerOffset;         // under Y=0;
    dAbove=(ycMax-ycMin)/dUpperOffset;          // above Y=ycMax

    // sets the final world coordinates
    setWorld(xcMin-dLeft, ycMin-dBelow, xcMax+dRight, ycMax+dAbove);
    }

    //----------------------------------------------------------------------------
    // sets the window of user coordinates
    //----------------------------------------------------------------------------
    public void setUserCoordinate(double xMin, double yMin, double xMax, double yMax)
    {
    xcMax=xMax;
    ycMax=yMax;
    xcMin=xMin;
    ycMin=yMin;
    }

    //----------------------------------------------------------------------------
    // gets the X device coordinate of user coordinates (world)
    //----------------------------------------------------------------------------
    public int gxdev(double xCoo)
    {
    return (int)((xCoo-xMin)*xScale);
    }

    //----------------------------------------------------------------------------
    // gets the Y device coordinate of user coordinates (world)
    //----------------------------------------------------------------------------
    public int gydev(double yCoo)
    {
    return (int) (dyMax -(yCoo-yMin)*yScale);
    }

    //----------------------------------------------------------------------------
    // specifies the graphics context (object) to draw to
    //----------------------------------------------------------------------------
    public void setContext(Graphics gGraphics)
    {
    // save the graphic context;
    g=gGraphics;
    g2 = (Graphics2D) g;
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    }




    //----------------------------------------------------------------------------
    // interface variables
    //----------------------------------------------------------------------------
    FontMetrics pickFont(String longString,int xSpace)
       {
        boolean fontFits = false;
        Font font = g2.getFont();
        FontMetrics fontMetrics = g2.getFontMetrics();
        int size = font.getSize();
        String name = font.getName();
        int style = font.getStyle();

        while ( !fontFits ) {
            if ( (fontMetrics.getHeight() <= maxCharHeight)
                 && (fontMetrics.stringWidth(longString) <= xSpace) ) {
                fontFits = true;
            }
            else {
                if ( size <= minFontSize ) {
                    fontFits = true;
                }
                else {
                    g2.setFont(font = new Font(name, style,--size));
                    fontMetrics = g2.getFontMetrics();
                }
            }
        }

        return fontMetrics;
    }



    //----------------------------------------------------------------------------
    // draws a rectangle
    //----------------------------------------------------------------------------
    public void xDrawRectangle(int xm, int ym, int xx, int yy)
    {
    int temp;

    if (xm>xx)
        {
        temp=xx;
        xx=xm;
        xm=temp;
        }
    if (ym>yy)
        {
        temp=yy;
        yy=ym;
        ym=temp;
        }
    g2.fill3DRect(xm, ym, xx-xm, yy-ym , true);
    g2.setColor(Color.black);
    g2.draw3DRect(xm, ym, xx-xm, yy-ym , true);
    }


    //----------------------------------------------------------------------------
    // paints the overal frame
    //----------------------------------------------------------------------------
    public void paint_frame()
    {
    g2.setColor(Color.white);
    g2.fillRect(0,0,dxMax,dyMax);

    g2.setColor(Color.blue);
    g2.drawRect(0,0,dxMax,dyMax);
    }

    //----------------------------------------------------------------------------
    // paints the Y coordinate grid
    //----------------------------------------------------------------------------
    public void paint_gridY()
    {
    int pasoy;
    String sWorkStr="";
    int xm,xx,xact,yact;


    pasoy=(int)(ycMax-ycMin)/5;
    xm=gxdev(xcMin);
    xx=gxdev(xcMax);
    // paints the axis
    g2.setColor(Color.black);
    g2.drawLine(xm,gydev(ycMin),xx,gydev(ycMin));
    // paints the grid
    g2.setColor(Color.gray);
    for (int j=0; j<5; j++)
        {
        yact=gydev(ycMin +j*pasoy);
        g2.drawLine(xm-10,yact,xx,yact);
        sWorkStr=" "+(ycMin +j*pasoy);
        g2.drawString(sWorkStr,10 ,yact);
        }

    }


    //----------------------------------------------------------------------------
    // paints the coordinate grid and axes
    //----------------------------------------------------------------------------
    public void paint_gridX()
    {
    String sWorkStr="";
    int ym,yy,xact;

    ym=gydev(ycMin);
    yy=gydev(ycMax);
    // paints the axis
    g2.setColor(Color.black);
    g2.drawLine(gxdev(xcMin),ym,gxdev(xcMin),yy);
    // paints the grid
    g2.setColor(Color.lightGray);
    for (int j=0; j<nPoints; j++)
        {
        // paints X axis
        xact=gxdev(x[j]);
        sWorkStr=" "+x[j];
        g2.drawLine(xact-5,ym,xact,yy);
        g2.drawString(sWorkStr, xact, gydev(0)+10);
        }

    }



    //----------------------------------------------------------------------------
    // paints a line chart
    //----------------------------------------------------------------------------
    public void paint_line()
    {
    String sWorkStr="";
    int j,k;
    Color c;
    int basex,basey, tox,toy;

    paint_gridX();
    paint_gridY();

    for (k=0; k<nSets; k++)
        {
        toy= gydev(y[k][0]);
        tox= gxdev(x[0]);
        g2.setColor(Color.black);
        g2.fill3DRect(tox-2,toy-2,4,4,true);
        for (j=1; j<nPoints; j++)
            {
            g2.setColor(cSetColor[k]);
            basey= gydev(y[k][j]);
            basex= gxdev(x[j]);
            g2.drawLine(tox,toy, basex,basey);
            g2.setColor(Color.black);
            g2.fill3DRect(basex-2,basey-2,4,4,true);
            toy=basey;
            tox=basex;
            }
        }
    }

    //----------------------------------------------------------------------------
    // paints a bar chart
    //----------------------------------------------------------------------------
    public void paint_bar()
    {
    String sWorkStr="";
    int j,k;
    Color c;
    int h, base, width;

    paint_gridX();
    paint_gridY();

    // determines the width of the bars
    width= (gxdev(xcMax)-gxdev(xcMin))/(nSets*nPoints);
    if (width>10)
        width=width*8/10;
      else
        width=width-2;
    if (width<2)
        width=2;

    for (k=0; k<nSets; k++)
        {
        for (j=0; j<nPoints; j++)
            {
            g2.setColor(cSetColor[k]);
            h= gydev(y[k][j]);
            base=gydev(0);
            xDrawRectangle(gxdev(j)+width*k, base, gxdev(j)+width*(k+1), h);
            g2.setColor(Color.black);
            g2.drawString(""+(int)y[k][j],gxdev(j),h-5);
            }
        }
    }

    //----------------------------------------------------------------------------
    // paints a pie chart
    //----------------------------------------------------------------------------
    public void paint_pie()
    {
    }

    //----------------------------------------------------------------------------
    // paints a stacked line chart
    //----------------------------------------------------------------------------
    public void paint_stackedLine()
    {
    }

    //----------------------------------------------------------------------------
    // paints a stacked bar chart
    //----------------------------------------------------------------------------
    public void paint_stackedBar()
    {
    }

    //----------------------------------------------------------------------------
    // paints a scattered chart
    //----------------------------------------------------------------------------
    public void paint_scattered()
    {
    }


    //----------------------------------------------------------------------------
    // paints the chart!!!
    //----------------------------------------------------------------------------
    public void paint()
    {


    paint_frame();
    paint_bar();
    paint_line();
    }

    //----------------------------------------------------------------------------
    // Constructor of the chartServer object
    //----------------------------------------------------------------------------
    public void ChartServer(Graphics gGraphics)
    {
    double dmaximum;

    nPoints=(int)(Math.random()*20+3);
    nSets=(int)(Math.random()*4+1);


    setContext(gGraphics);
    initVectors();
    setTransformation();

    cSetColor=new Color[10];

    cSetColor[0]=Color.blue;             // color of each set  cSetColor[nSet]
    cSetColor[1]=Color.red;
    cSetColor[2]=Color.green;
    cSetColor[3]=Color.yellow;
    cSetColor[4]=Color.magenta;
    cSetColor[5]=Color.orange;
    cSetColor[6]=Color.cyan;
    cSetColor[7]=Color.pink;
    cSetColor[8]=Color.lightGray;
    cSetColor[9]=Color.yellow;


    // fills the vectors with random data
    dmaximum=Math.random()*1000;
    for (int k=0; k<nSets; k++)
        for (int j=0; j<nPoints; j++)
            {
            x[j]=j;
            y[k][j]=Math.random()*dmaximum;
            sSetLabels[k]="Set "+k;
            sLabels[j]="Point "+j;
            }

     setChartWorld(0.0, 0.0, (double) nPoints, dmaximum);

    }






    public void service(ServletRequest request, ServletResponse response) throws IOException
    {
    // Tell the browser this servlet is returning a JPeg image
    response.setContentType("image/jpeg");

    //DEBUG: PrintWriter SystemOut = new PrintWriter(new FileOutputStream("c:/temp/imgdebg.txt"));

    // Create the in-memory image
    BufferedImage buffImage = new BufferedImage(640, 500, BufferedImage.TYPE_INT_RGB);
    // Create a graphics object from the image

    Graphics2D graphics = (Graphics2D) buffImage.getGraphics();
    // Graphics graphics =  buffImage.getGraphics();


    //  ChartServer

    // ChartServer cs=new ChartServer(graphics);

    ChartServer(graphics);
    paint();

    response.setContentType("image/png");
	byte[] pngbytes;
	PngEncoderB png =  new PngEncoderB( buffImage, PngEncoder.ENCODE_ALPHA,	0,1);
	ServletOutputStream out = response.getOutputStream();
	try
	{
		pngbytes = png.pngEncode();
		if (pngbytes == null) {
			System.out.println("MAP: Null image");
		}
		 out.write(pngbytes);
		
	}
	catch (Exception e)
	{
		e.printStackTrace();
	}
    out.close();
    }
}


