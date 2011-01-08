
jQuery(document).ready(function(){
	$('.brand').change(searchModel);
});

function addNewAddress(element){
	$(element).prev().find("input").click();
	$(".default").change(updateDefaults);
}

function updateDefaults(){	
		var target = $(this);
		$(".default").each(function(){
			var check = $(this);
			if (check.attr("id") != target.attr("id")){
				check.attr("checked",false);
			}
		});	
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
	AjaxLoader.enable();
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
