jQuery(document).ready(function(){
  initializeMap();
  $("#search_map").hide();  
  $("#search_map").dialog({
    height: 600,
    width:570,
    autoOpen: false,
    draggable: false,
    resizable:false,
    modal: true});
	  var address = $("#full_address").val();
    search_companies_near_to_me(address);
	  $("#address_map").val(address);
	
});

function search_address(target){
	var address = $(target).parent().prev().find("label").html().trim();	
	$("#address_map").val(address);
	$("#search_map").dialog('open')
  initializeMap(8);    
  search_companies_near_to_me(address,16);
}

function search_address_text(){
  var address = $("#address_map").val();
  codeAddress(address,16);
}

function search_companies_near_to_me(address){
	codeAddress(address,16);
}



