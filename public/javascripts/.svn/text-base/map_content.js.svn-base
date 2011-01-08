var axisPatter = /^axis/;

function get_json_map(){
	var json_url = jQuery("#json_url").val();
	jQuery.ajax({
		url: json_url,
		success: set_json_map,
		dataType: "jsonp",
		type:'GET'
		})
}

function set_json_map(jsonObj){
	mapString = "";
	var serviceUrl = jQuery("#services_url").val().split("|").reverse();
	var urlIndex=0;
	var area = false;
	var chart = jsonObj.chartshape;
	for (var i = 0; i < chart.length; i++) {
		area = chart[i];
		if (area.name.match(axisPatter)) {
			mapString += "<area name='" + area.name + "' shape='" + area.type +
			"' coords='" +
			area.coords.join(",") +
			"' href='" + serviceUrl[urlIndex] + "' title=''>";
			urlIndex++;
		}
	}	
	jQuery("#notes")[0].innerHTML=mapString;
}


jQuery(document).ready( function(){
	get_json_map();
});
