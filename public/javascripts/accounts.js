var sc_hide =["#li_info_sc","#li_info_asc","#h_info_sc","#h_address_sc"];
var usr_hide=["#li_info_car","#li_info_ausr","#h_car_info","#h_ausr_inf"];
jQuery(document).ready(function(){
	$('.brand').change(searchModel);
	//$(".usr_menu_link").click(changeAccountTabs);
	//$("input[type=radio]").change(updateAccountUserType);
	//updateAccountUserType();

});

var RecaptchaOptions = {
    	theme : 'clean'
};

function updateAccountUserType(){
  var id = $("input[name='user[type]']:checked").val();
  
  if (id == "sp"){
    $("#company_data").show();
    for(var i = 0; i < sc_hide.length; i++){
      $(sc_hide[i]).show();
      $(usr_hide[i]).hide();
    }
  }else{
    $("#company_data").hide();
    for(var i = 0; i < sc_hide.length; i++){
      $(sc_hide[i]).hide();
      $(usr_hide[i]).show();
    }
    //$(".personal_address").find("input").val("");
    //$(".personal_address").find("select").val("");
  }
  $("#user_data").accordion( "activate" ,0);
}

function changeAccountTabs(){
  var item = $(this)
  var ul = item.parent();
  ul.find(".usr_menu_selected").each(function(){
    $(this).removeClass("usr_menu_selected");
  });
  item.addClass("usr_menu_selected");
  var a = item.find("a");
  var tabId = parseInt(a.attr("id"));
  $( "#user_data" ).accordion({ active: tabId });
}


function showMap(event){
	var target = event.target;
	var td =$(target).parent().prev().prev().prev();
	var state = td.find("select option:selected").text();
	td = td.prev();
	var cp =    td.find("input").val();
	td = td.prev();
	var city =  td.find("input").val();
	td = td.prev();
	var street = td.find("input").val();
	var country ="Argentina";
	var address = country + " " + state + " " + city + " " + street;
	codeAddress(address,16);
}




function show_html_callback(code){
	eval(code);
}

function remove_fields(link,association){
    $(link).prev("input[type=hidden]").attr("value", '1');
    $(link).closest(".fields").hide();
	if (association=="address"){
		rowAddNro--;
	}else{
		rowCarNro--;
	}
}

function add_fields(link, association, content){
	var msg="";
	
	if (association == "user_addresses"){
		rowAddNro++;
		rowNro=rowAddNro;
		msg="Nos se puede ingresar más direcciones";
	}else{
		rowCarNro++;
		rowNro=rowCarNro;
		msg="No se pueden ingresar más automoviles";
	}
	if (rowNro <= 5) {
		var new_id = new Date().getTime();;
		var regexp = new RegExp("new_" + association, "g");
		$(link).parent().parent().find('table tr:last').after(content.replace(regexp, new_id));
		if (association=="addresses"){

		}else{
			initModels(new_id);	
		}
		
	}else{
		if (association == "user_addresses"){
			rowAddNro--;
			msg="Nos se puede ingresar más direcciones";
		}else{
			rowCarNro--;
			msg="No se pueden ingresar más automoviles";
		}
		alert(msg);
	}
}

function initModels(id){
	var brandId ="brand_" + id;
	var brand = $('#cars_link').parent().find('table tr:last').find('.brand');
	brand.attr('id',brandId);
	brand.change(searchModel);
}

function initDepartments(id){
	var stateId ="state_" + id;
	var state = $('#addresses_link').parent().find('table tr:last').find('.state');
	state.attr('id',stateId);
	state.change(searchDepartment);
}