var checkBoxMap;
jQuery(document).ready(function(){
    initializeMap();
	
	google.maps.event.addListener(map, 'dblclick', function(event) {
    	placeMarker(event.latLng);
  	});
	
	$(".view_map").change(showAddressInMap);
	checkBoxMap = $(".view_map:checked");
	showAddress(checkBoxMap);
});

function showAddressInMap(){
	var element= $(this);
	checkBoxMap = element;
	if (element.attr("checked")){
		$(".view_map").each(function(){
			$(this).attr("checked",false);
		});
		element.attr("checked",true);
		showAddress(element);
	}
}

function showAddress(element){
	var address = getAddress(element);
	codeAddress(address,16,setLatLng);
}

function getAddress(element){
		var state = element.parent().prev().find("select :selected").text();
		var country = element.parent().prev().find("input").val();
		var city = element.parent().prev().prev().prev().find("input").val();
		var street = element.parent().prev().prev().prev().prev().find("input").val();
		var address =  street + ", " + city + ", " + state + ", " + country;
		return address;
}

function setLatLng(results){
	var lat = checkBoxMap.next();
	var lng = checkBoxMap.next().next();
	lat.val(results[0].geometry.location.lat());
	lng.val(results[0].geometry.location.lng());
}

function placeMarker(location) {
  var marker = new google.maps.Marker({
      position: location, 
      map: map
  });

  map.setCenter(location);
}



