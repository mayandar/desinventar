package org.lared.desinventar.map;

public class MapTransformationMercatorSphericalDI extends MapTransformation
{
	  
	  double radius = 6378137.0;
	  double halfRadius=radius/2.0;
	  private double dK=0;


	public MapTransformationMercatorSphericalDI ()
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


	      // optimize: -y*my + yresolution  + pyminif*my;
		  // return (int) (yresolution - (latToY(y) - pyminif) * my);
	      y = latToY(y);
		  return (int) (dK - y*my);

	  }

	  
	  public double longToX(double x)
	  {
		  
		  return Math.toRadians(x/10000)* radius;
	  }
	  
	  public double latToY(double y)
	  {
		  /*
		  if (y<-85)
			  y=-85;
		  else
			  if (y>85)
				  y=85;
	      */	  
	      //	  y= radius * Math.log(Math.tan((Math.PI/4) + 0.5*Math.toRadians(y)));
		  double latitude = Math.toRadians(y/10000);
		  double sinlat=Math.sin(latitude);
		  y = halfRadius *  Math.log( (1.0d + sinlat) / (1.0d - sinlat) );

	   return y;
		  
	  }





	  
	  public void setTransformation()
	  {
		pxminif = longToX(xminif);
		pyminif = latToY(yminif);
		pxmaxif = longToX(xmaxif);
		pymaxif = latToY(ymaxif);
 
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

	  // this expects coordinates in LAT/LON !!!
	  public void setTransformation(double xm, double ym, double xx, double yy)
	  {
	    xminif = xm*10000;
	    yminif = ym*10000;
	    xmaxif = xx*10000;
	    ymaxif = yy*10000;
	    
	    setTransformation();
	  }

	  public void setView(double xres, double yres)
	  {
	    xresolution = xres;
	    yresolution = yres;
	  }



}
