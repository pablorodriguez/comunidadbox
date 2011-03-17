jQuery(document).ready(function(){
    initializeMap(8);
	var address = $("#full_address").val();
    search_companies_near_to_me(address,16);
	$("#address_map").val(address);
});

function search_address(target){
	var address = $(target).parent().prev().find("label").html().trim();
	search_companies_near_to_me(address,16);
	$("#address_map").val(address);
}

function search_address_text(){
  var address = $("#address_map").val();
  codeAddress(address,16);
}

function search_companies_near_to_me(address){
	codeAddress(address,16);
}



