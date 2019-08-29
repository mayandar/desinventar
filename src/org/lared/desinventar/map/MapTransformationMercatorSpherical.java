package org.lared.desinventar.map;

public class MapTransformationMercatorSpherical extends MapTransformation
{
	  // double radius = circumference/ (2 * Math.PI);
	static double radius = 6378137.0;
	static double halfRadius=radius/2.0;
	  
	  private double dK=0;

	public MapTransformationMercatorSpherical ()
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
	      // optimize: -y*my + yresolution  + yminif*my;
		  // return (int) (yresolution - (y - yminif) * my);
		  return (int) (dK - y*my);
	  }

	  
	  public static double longToX(double x)
	  {
		  
		  return Math.toRadians(x)* radius;
	  }
	  
	  public static double latToY(double y)
	  {
		  /*
		  if (y<-85)
			  y=-85;
		  else
			  if (y>85)
				  y=85;
	      */	  
		  //	other version??  y= radius * Math.log(Math.tan((Math.PI/4) + 0.5*Math.toRadians(y)));

		  double latitude = Math.toRadians(y);
		  double sinlat=Math.sin(latitude);
		  y = halfRadius *  Math.log( (1.0d + sinlat) / (1.0d - sinlat) );

	   return y;
		  
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
	    pxminif = longToX(xm);
	    pyminif = latToY(ym);
	    pxmaxif = longToX(xx);
	    pymaxif = latToY(yy);

	    xminif = xm;
	    yminif = ym;
	    xmaxif = xx;
	    ymaxif = yy;

	    setTransformation();
	  }

	  public void setView(double xres, double yres)
	  {
	    xresolution = xres;
	    yresolution = yres;
	  }



}
