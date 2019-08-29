package org.lared.desinventar.map;

public class MapTransformationDI extends MapTransformation{

  
	  public double getXResolution()
	  {
		  return xresolution;
	  }
	  
	  public int xdev(int x)
	  {
	    return (int) ( (x - xminif) * m);
	  }

	  public int ydev(int y)
	  {
	    return (int) (yresolution - (y - yminif) * m);
	  }

	  public int xdev(double x)
	  {
	    return  (int) ( (x - xminif) * m);
	  }

	  public int ydev(double y)
	  {
	    return (int) (yresolution - (y - yminif) * m);
	  }


	  public void setTransformation()
	  {
	    double xa = xmaxif - xminif;
	    double ya = ymaxif - yminif;
	    if (xa == 0.0)
	      xa = 1;
	    if (ya == 0.0)
	      ya = 1;
	    m = xresolution / xa;
	    double m2 = yresolution / ya;
	    if (m2<m)
	    	m=m2;
	    else
	    	{
	    	yminif=ymaxif-yresolution/m;
	    	}
	    my=m;
	  }	    	

	  public void setTransformation(double xm, double ym, double xx, double yy)
	  {
	    xminif = xm * 10000;
	    yminif = ym * 10000;
	    xmaxif = xx * 10000;
	    ymaxif = yy * 10000;
	    
	    pxminif = xm;
	    pyminif = ym;
	    pxmaxif = xx;
	    pymaxif = yy;
	    
	    setTransformation();
	  }

	  public void setView(double xres, double yres)
	  {
	    xresolution = xres;
	    yresolution = yres;
	  }


}
