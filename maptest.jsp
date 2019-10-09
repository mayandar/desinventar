<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Full Screen Example</title>
        
        <link rel="stylesheet" href="../theme/default/style.css" type="text/css" />
        <style type="text/css">
            #map {
                width: 100%;
                height: 100%;
                border: 1px solid black;
            }

            #text {
                position: absolute;
                bottom: 0px;
                left:0px;
                width: 512px;
            }
        </style>
        <script src="/DesInventar/OpenLayers.js"></script>
        <script type="text/javascript">
            var map;
            function init(){
                map = new OpenLayers.Map('map');
                var level0 = new OpenLayers.Layer.WMS( "DesInventar OpenLayers WMS","http://desinventar/DesInventar/jsmapserv",
				                                        {layers: 'effects', 'transparent':true, 'format':'png' },
														{'isBaseLayer':false} );

				level0.setVisibility(true);
				map.addLayer(level0);

				var metc = new OpenLayers.Layer.WMS("** Metacarta WMS",
						"http://labs.metacarta.com/wms-c/Basic.py", 
						{'layers':'basic', 'transparent':true, 'format':'png' },
						{'isBaseLayer':true });
				metc.setVisibility(true);
				map.addLayer(metc);
							
				//var layer = new OpenLayers.Layer.WMS( "OpenLayers WMS","http://labs.metacarta.com/wms/vmap0", {layers: 'basic'});

                // map.addLayers([ol_wms, jpl_wms, dm_wms]);
                map.addControl(new OpenLayers.Control.LayerSwitcher());
                // map.setCenter(new OpenLayers.LonLat(0, 0), 0);
                map.zoomToMaxExtent();




            }
        </script>
    </head>
    <body onload="init()">
        <div id="map"></div>
    </body>
</html>
