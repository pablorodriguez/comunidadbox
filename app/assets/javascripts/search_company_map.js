jQuery(document).ready(function(){
  initializeMap();
  $("#search_map").hide();  
  $("#search_map").dialog({
    height: 540,
    width:570,
    title:'Ver en el Mapa',
    autoOpen: false,
    draggable: false,
    resizable:false,
    modal: true});
    
	  var address = $("#full_address").val();
    search_companies_near_to_me(address);
	  $("#address_map").val(address);
	
});
function searchCompany(){

  $("#menu_options .selected").removeClass("selected");
  $("#service_center_link").addClass("selected");

  $(".menu_data.showed").hide().removeClass("showed"); 
  $("#service_center_menu").show().addClass("showed"); 
}

function search_address(target){
	var address = $(target).parent().parent().parent().find(".address").html().trim();
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
  $("#address_map").val(address);
	codeAddress(address,16);
}


