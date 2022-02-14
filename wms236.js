/*
Call generic wms service for GoogleMaps v2
John Deck, UC Berkeley
Inspiration & Code from:
Mike Williams https://www.econym.demon.co.uk/googlemaps2/ V2 Reference & custommap code
Brian Flood https://www.spatialdatalogic.com/cs/blogs/brian_flood/archive/2005/07/11/39.aspx V1 WMS code
Kyle Mulka http://blog.kylemulka.com/?p=287  V1 WMS code modifications
http://search.cpan.org/src/RRWO/GPS-Lowrance-0.31/lib/Geo/Coordinates/MercatorMeters.pm

Modified: JP @ backcountrymaps.com -> Now Displays any stream from USGS
seamless.usgs.gov server. Also GIDB support added with CustomGetTileURLNoStyle.
Append GroupName=STYLE.
*/

var MAGIC_NUMBER=6356752.3142;
var DEG2RAD=0.0174532922519943;
var PI=3.14159267;
function dd2MercMetersLng(p_lng) { 
return MAGIC_NUMBER*(p_lng*DEG2RAD); 
}

function dd2MercMetersLat(p_lat) {
if (p_lat >= 85) p_lat=85;
if (p_lat <= -85) p_lat=-85;
return MAGIC_NUMBER*Math.log(Math.tan(((p_lat*DEG2RAD)+(PI/2)) /2));
}

CustomGetTileUrl=function(a,b,c) {
if (typeof(window['this.myMercZoomLevel'])=="undefined") this.myMercZoomLevel=0; 
if (typeof(window['this.myStyles'])=="undefined") this.myStyles="default"; 
var lULP = new GPoint(a.x*256,(a.y+1)*256);
var lLRP = new GPoint((a.x+1)*256,a.y*256);
var lUL = G_NORMAL_MAP.getProjection().fromPixelToLatLng(lULP,b,c);
var lLR = G_NORMAL_MAP.getProjection().fromPixelToLatLng(lLRP,b,c);
// switch between Mercator and DD if merczoomlevel is set
if (this.myMercZoomLevel!=0 && map.getZoom() < this.myMercZoomLevel) {
    var lBbox=dd2MercMetersLng(lUL.lngDegrees)+","+dd2MercMetersLat(lUL.latDegrees)+","+dd2MercMetersLng(lLR.lngDegrees)+","+dd2MercMetersLat(lLR.latDegrees);
    var lSRS="EPSG:54004";
} else {
    var lBbox=lUL.x+","+lUL.y+","+lLR.x+","+lLR.y;
    var lSRS="EPSG:3785"; // "EPSG:4326";
}
var lURL=this.myBaseURL;
lURL+="&REQUEST=GetMap";
lURL+="&SERVICE=WMS";
lURL+="&reaspect=false&VERSION=1.1.1";
lURL+="&LAYERS="+this.myLayers;
lURL+="&STYLES="+this.myStyles; lURL+="&FORMAT="+this.myFormat;
lURL+="&BGCOLOR=0xFFFFFF";
lURL+="&TRANSPARENT=TRUE";
lURL+="&SRS="+lSRS;
lURL+="&BBOX="+lBbox;
lURL+="&WIDTH=256";
lURL+="&HEIGHT=256";
lURL+="&GroupName="+this.myLayers;
return lURL;
}

CustomGetTileUrlNoStyle=function(a,b,c) {
if (typeof(window['this.myMercZoomLevel'])=="undefined") this.myMercZoomLevel=0; 
if (typeof(window['this.myStyles'])=="undefined") this.myStyles="default"; 
var lULP = new GPoint(a.x*256,(a.y+1)*256);
var lLRP = new GPoint((a.x+1)*256,a.y*256);
var lUL = G_NORMAL_MAP.getProjection().fromPixelToLatLng(lULP,b,c);
var lLR = G_NORMAL_MAP.getProjection().fromPixelToLatLng(lLRP,b,c);
// switch between Mercator and DD if merczoomlevel is set
if (this.myMercZoomLevel!=0 && map.getZoom() < this.myMercZoomLevel) {
    var lBbox=dd2MercMetersLng(lUL.lngDegrees)+","+dd2MercMetersLat(lUL.latDegrees)+","+dd2MercMetersLng(lLR.lngDegrees)+","+dd2MercMetersLat(lLR.latDegrees);
    var lSRS="EPSG:54004";
} else {
    var lBbox=lUL.x+","+lUL.y+","+lLR.x+","+lLR.y;
    var lSRS="EPSG:4326";
}
var lURL=this.myBaseURL;
lURL+="&REQUEST=GetMap";
lURL+="&SERVICE=WMS";
lURL+="&reaspect=false&VERSION=1.1.1";
lURL+="&LAYERS="+this.myLayers;
lURL+="&FORMAT="+this.myFormat;
lURL+="&BGCOLOR=0xFFFFFF";
lURL+="&TRANSPARENT=TRUE";
lURL+="&SRS="+lSRS;
lURL+="&BBOX="+lBbox;
lURL+="&WIDTH=256";
lURL+="&HEIGHT=256";
return lURL;
}

CustomGetTileUrlM=function(a,b,c) {

if (typeof(window['this.myMercZoomLevel'])=="undefined") this.myMercZoomLevel=0;
if (typeof(window['this.myStyles'])=="undefined") this.myStyles="";

        var lULP = new GPoint(a.x*256,(a.y+1)*256);
        var lLRP = new GPoint((a.x+1)*256,a.y*256);
        var lUL = G_NORMAL_MAP.getProjection().fromPixelToLatLng(lULP,b,c);
        var lLR = G_NORMAL_MAP.getProjection().fromPixelToLatLng(lLRP,b,c);
        // switch between Mercator and DD if merczoomlevel is set
        if (this.myMercZoomLevel!=0 && map.getZoom() < this.myMercZoomLevel) {
var lBbox=dd2MercMetersLng(lUL.lngDegrees)+","+dd2MercMetersLat(lUL.latDegrees)+","+dd2MercMetersLng(lLR.lngDegrees)+","+dd2MercMetersLat(lLR.latDegrees);
        var lSRS="EPSG:54004";
        } else {
        var lBbox=lUL.x+","+lUL.y+","+lLR.x+","+lLR.y;
        var lSRS="EPSG:4326";
        }
        var lURL=this.myBaseURL;
        lURL+="REQUEST=GetMap";
        lURL+="&SERVICE=WMS";
        lURL+="&REASPECT=false&VERSION=1.1.1";
        lURL+="&LAYERS="+this.myLayers;
        lURL+="&STYLES="+this.myStyles;
        lURL+="&FORMAT="+this.myFormat;
        lURL+="&BGCOLOR=0xFFFFFF";
        lURL+="&TRANSPARENT=TRUE";
        lURL+="&SRS="+lSRS;
        lURL+="&BBOX="+lBbox;
        lURL+="&WIDTH=256";
        lURL+="&HEIGHT=256";
        return lURL;
}
