jQuery(document).ready(function(){

  initializeMap();
  
  set_link_to_function($(".new_company"),newCompany);
  set_link_to_function($(".cancel_new_company"),cancelNewCompany);
  
  $("#near_to_me").click(search_companies_near_to_me);

  $(".new_service_new_company").click(newServiceNewCompany);
  $(".search_address_text").click(search_address_text);
  $(".search_address").live("click",search_address);

  $("#search_map").hide();  
  $("#search_map").dialog({
    height: 540,
    width:570,
    title:'Ver en el Mapa',
    autoOpen: false,
    draggable: false,
    resizable:false,
    modal: true
  });

  var address = $("#full_address").val();
  search_companies(address);
  $("#address_map").val(address);	
});

function newServiceNewCompany(){
  var url = $("#new_service_url").val();
  var comp_info =$("#company_info").val();
  var car = "?car_id=" + $("#car_id").val();
  window.location=url + car + "&c="+comp_info;
}

function newCompany(){
  $("#companies").hide();
  $("#new_company").show();  
}

function cancelNewCompany(){
  $("#companies").show();
  $("#new_company").hide();
}



function searchCompany(){

  $("#menu_options .selected").removeClass("selected");
  $("#service_center_link").addClass("selected");

  $(".menu_data.showed").hide().removeClass("showed"); 
  $("#service_center_menu").show().addClass("showed"); 
}

function search_address(){
	var address = $(this).parent().parent().parent().find(".address").html().trim();
	$("#address_map").val(address);
	$("#search_map").dialog('open')
  initializeMap(8);    
  search_companies(address);
}

function search_address_text(){
  var address = $("#address_map").val();
  codeAddress(address,16);
}

function search_companies_near_to_me(){
  var address = $(this).attr("data-addres-text");
  search_companies(address);  
}

function search_companies(address){  
  $("#address_map").val(address);
  codeAddress(address,16);
}



