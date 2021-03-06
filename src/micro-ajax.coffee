# usage: new MicroAjax 'http://example.com', 1000, (responseText)
# a null value is passed to responseText in case of error/timeout
class MicroAjax
	# Loosely adapted from the microajax library at https://code.google.com/p/microajax/
	constructor: (url, timeout, callback) ->
		req = createRequest url
		return callback null unless req? # can't make request
		req.timeout = timeout if typeof timeout is 'number'
		req.onload = -> callback req.responseText
		req.onerror = req.ontimeout = -> callback null
		req.send()
	# Adapted from http://www.nczonline.net/blog/2010/05/25/cross-domain-ajax-with-cross-origin-resource-sharing/
	createRequest = (url) ->
		if XMLHttpRequest? # nearly all browsers provide XMLHttpRequest, though some refuse to honor cross-origin requests (see below)
			xhr = new XMLHttpRequest()
		if xhr?.withCredentials? # modern browsers support CORS via XMLHttpRequest (add Origin header to the outgoing request, examine Allow-Origin in response, etc) - withCredentials is a good sniff-test for that support
			xhr.open 'GET', url, true
		else if XDomainRequest? # IE 8/9 implemented CORS in XDomainRequest rather than XMLHttpRequest (which did not until IE 10)
			xhr = new XDomainRequest()
			xhr.open 'GET', url
		else
			xhr = null # No attempt to support browsers with no XMLHttpRequest, or without cross-origin support (IE 6/7) - could try to support IE 6/7 via new ActiveXObject("MSXML2.XMLHTTP.3.0") - see http://msdn.microsoft.com/en-us/library/ms535874.aspx
		return xhr
