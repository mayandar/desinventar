package org.lared.desinventar.map;

public class MapTransformationSphericalGoogle extends MapTransformation
{

	  // double radius = circumference/ (2 * Math.PI);
	 public static double radius = 6378137.0;
	 public static double halfRadius=radius/2.0;
	  
	  private double dK=0;

	public MapTransformationSphericalGoogle ()
	{
	bIsotropic=false;
	}	  

	  public double getXResolution()
	  {
		  return xresolution;
	  }
	  
	  public int xdev(int x)
	  {
	    return (int) ( (longToX(x) - pxminif) * m);
	  }

	  public int ydev(int y)
	  {
      return (int) (yresolution - (latToY(y) - pyminif) * my);
	  }

	  public int xdev(double x)
	  {
		x = longToX(x);
	    return  (int) ( (x - pxminif) * m);
	  }

	  public int ydev(double y)
	  {
	      y = latToY(y);
		  return (int) (dK - y*my);
	  }

	  
	  public static  double longToX(double x)
	  {
		  
		  return Math.toRadians(x)* radius;
	  }
	  
	
	public static double latToY(double y)
	  {
		  double latitude = Math.toRadians(y);
		  double sinlat=Math.sin(latitude);
		  y = halfRadius *  Math.log( (1.0d + sinlat) / (1.0d - sinlat) );

	   return y;
		  
	  }



	  public static double YtoLat(double y)
	  {
		  double k=Math.exp(y/halfRadius);			  
		  return Math.toDegrees(Math.asin((k-1)/(1+k)));
	  }

	  public static double XtoLon(double x)
	  {
		  return  Math.toDegrees(x/radius);
	  }



	  
	  public void setTransformation()
	  {
	    double xa = pxmaxif - pxminif;
	    double ya = pymaxif - pyminif;
	    if (xa == 0.0)
	      xa = 1;
	    if (ya == 0.0)
	      ya = 1;
	    m = xresolution / xa;
	    my = yresolution / ya;
	    if (bIsotropic)
	    {
		    if (my<m)
		    	m=my;
	    }
	    dK= yresolution  + pyminif*my;
	    
	  }	    	

	  public void setTransformation(double xm, double ym, double xx, double yy)
	  {
	  
		    pxminif = xm;
		    pyminif = ym;
		    pxmaxif = xx;
		    pymaxif = yy;
		  
		    xminif = XtoLon(xm);
		    yminif = YtoLat(ym);
		    xmaxif = XtoLon(xx);
		    ymaxif = YtoLat(yy);


		    //double xtest=longToX(xmaxif);
		    //double ytest=latToY(ymaxif);
	    
		    setTransformation();    
	    
	  }

	  public void setView(double xres, double yres)
	  {
	    xresolution = xres;
	    yresolution = yres;
	  }



}
