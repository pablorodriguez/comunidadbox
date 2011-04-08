var sc_hide =["#li_info_sc","#li_info_asc","#h_info_sc","#h_address_sc"];
var usr_hide=["#li_info_car","#li_info_ausr","#h_car_info","#h_ausr_inf"]
jQuery(document).ready(function(){
  for(var i = 0; i < sc_hide.length; i++)
      $(sc_hide[i]).hide();
	$('.brand').change(searchModel);
	$( "#user_data" ).accordion();
	$(".usr_menu_link").click(changeAccountTabs);
	
});

function updateAccountUserType(){
  var id = $(this).attr("id");
  if (id == "sc"){
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
  }
  $( "#user_data" ).accordion();
  
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

function toggleCheck(event){
	var ele= event.target;
	$('.default_check').each(
		function(){
			alert(this.checked);
		}
	);
}

function searchModel(event){
	var brand_id = event.target.id;	
	var token = $("input[name='authenticity_token']")[0];
	//AjaxLoader.enable();
	$.ajax({
		url: "/cars/find_models",
			data: {
				'id':brand_id,
				'brand_id':$("#"+brand_id).val(),
				'authenticity_token':encodeURIComponent(token)
			},
		dataType:'script',
		type:'POST'
	});
}
