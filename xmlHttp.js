var debug = false;

function sendHttpRequest(method, url, callback) 
{

	var request;
	var async = true;
	
	if (window.XMLHttpRequest) {
		request = new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		request = new ActiveXObject("Microsoft.XMLHTTP");
	} else {
	    alert("ERROR: could not determine platform"); 
		return null;
	}

	if (method) {
		method = method.toUpperCase();
	} else {
		method = "GET";
	}
		
	request.open(method, url, async);
	
	function callbackWrapper() 
	{
		if (request.readyState == 4) {				
			if (request.status == 200) {				
				callback(request);
			} else {
				reportError(request, url);
			}
		}
	}

    request.onreadystatechange = callbackWrapper;	
	request.send(null);
	
	return request;
}

function buildQueryString(params) 
{
	var query = "";
	for (var i = 0; i < params.length; i++) {
		query += (i > 0 ? "&" : "")
			+ escape(params[i].name) + "="
			+ escape(params[i].value);
	}
	return query;
}

function hasResponse(request, responseTagName) 
{
	var responseXML = request.responseXML;
	if (responseXML) {
		var docElem = responseXML.documentElement;
		if (docElem) {
			var tagName = docElem.tagName;
			if (tagName == responseTagName) {
				return true;
			}
		}
	}
	return false;
}

function reportError(request, url) 
{
	if (debug) {
		if (request.status != 200) {
			if (request.statusText) {
				alert(request.statusText);
			} else {
				alert("HTTP Status: " + request.status+" URL="+url);
			}
		} else {
			alert("Response Error "+request.status+"- URL="+url);
		}		
	}
}


