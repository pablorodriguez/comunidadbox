var map;
var geocoder;

function initializeMap(zoom_param) {
	if (zoom_param == null){
		zoom_param = 8;
	}
	
	var latlng = new google.maps.LatLng(-35.055182,-58.190919);
	geocoder = new google.maps.Geocoder();

	var myOptions = {
	  zoom: zoom_param,
	  center: latlng,
	  mapTypeControl: false,
	  mapTypeId: google.maps.MapTypeId.ROADMAP
	};
	map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
}

function codeAddress(address,zoom,callBackFunction) {
	if (geocoder) {
	  geocoder.geocode( { 'address': address}, function(results, status) {
	    if (status == google.maps.GeocoderStatus.OK) {
	      map.setCenter(results[0].geometry.location);
	      var marker = new google.maps.Marker({
	          map: map, 
	          position: results[0].geometry.location
	      });
		  if(zoom){
			var b = results[0].geometry.location.b;
			var c = results[0].geometry.location.c;
			var latlng = new google.maps.LatLng(b,c);
			map.setZoom(zoom);
		  }
		  callBackFunction(results);
	    } else {
	      //alert("Geocode was not successful for the following reason: " + status);
	    }
	  });
	}
}



