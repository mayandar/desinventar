package org.lared.desinventar.map;

public class MapTransformation 
{

	public double xminif = -180;
	public double yminif = -90;
	public double xmaxif = 180;
	public double ymaxif = 90;
	
	public double pxminif=0;
	public double pyminif=0;
	public double pxmaxif=1;
	public double pymaxif=1;
		
	public double xresolution = 800;
	public double yresolution = 600;
	public double m = 0.001;
	public double my = 0.001;
		  
	public boolean bIsotropic=true;

	  
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

	  public double dxdev(double x)
	  {
	    return  (double) ( (x - xminif) * m);
	  }

	  public double dydev(double y)
	  {
	    return (double) (yresolution - (y - yminif) * m);
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
	    	yminif=ymaxif-yresolution/m;
	    my=m;
	  }	    	

	  public void setTransformation(double xm, double ym, double xx, double yy)
	  {
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
