var sizex=1000;
var sizey=500;

	// For IE use Body to determine client area
	if (document.all) {
		sizex = document.body.clientWidth;
		sizey = document.body.clientHeight-40;
	}
	// Otherwise for NS/Mozilla/Firefox use the window object to determine client area
	else {
		 sizex = innerWidth;
		 sizey = innerHeight-100;
	}
sizey-=80;
//if (sizey<500)
//	sizey=500;
document.getElementById("contentFrame").height=sizey;
//document.getElementById("contentFrame").width=1000;  //sizex;
