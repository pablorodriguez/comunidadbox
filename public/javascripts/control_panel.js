function checkAll(element,css){
	var id = "input[class='" + css +"']";
	var value = element.checked;
	$(id).each(function(){
		this.checked = value;
	});
}

function submitServiceOffer(){
	if ($("#cars_events input:checkbox:checked").size() > 0){
		$('#service_offer_service_type_id').val($('#service_filter_service_type_id') .val());
		$('#service_offer_form').submit();		
	}else{
		$('#error h2').text("Debe elegir al menos un automovil");
		$('#error').addClass("notice").addClass("errorExplanation");
		$('#error').show();
		return false;
	}
	
}

function submit_form(){
	$('#service_filter_form').submit();
}

function save_filter(){
	var new_action=$('#save_filter_url').val();
	var params= "service_type_id=" + $('#service_filter_service_type_id').val();
	$.ajax({
		url: new_action,
			data: {
				'service_filter[name]':$('#service_filter_name').val(),
				'service_filter[service_type_id]':$('#service_filter_service_type_id').val(),
				'service_filter[brand_id':$('#service_filter_brand_id').val(),
				'service_filter[model_id]':$('#service_filter_model_id').val(),
				'service_filter[fuel]':$('#service_filter_fuel').val(),
				'service_filter[year]':$('#service_filter_year').val(),
				'service_filter[state_id]':$('#service_filter_state_id').val(),
				'service_filter[city]':$('#service_filter_city').val()
			},
		type:'POST',
		dataType:'script'
	});
}

function save_filter_callback(){
	$('#filter_label').text($('#service_filter_name').val());
	$('#service_filter_name').hide();
	$('#filter_label').show();
	$('#save_filter').hide();
}

function edit_filter_name(){
	$('#service_filter_name').show();
	$('#filter_label').hide();	
	$('#save_filter').show();
}

function searchModel(event){
  var brand_id = event.target.id; 
  var token = $("input[name='authenticity_token']").val();
  AjaxLoader.enable();
  $.ajax({
    url: "/control_panels/find_models",
      data: {
        'id':brand_id,
        'brand_id':$("#"+brand_id).val(),
        'authenticity_token':encodeURIComponent(token)
      },
    dataType:'script',
    type:'POST'
  });  
}

jQuery(document).ready( function(){
	$('#operators_red').click(function(){checkAll(this,'red');});
	$('#operators_yellow').click(function(){checkAll(this,'yellow');});
	
	$('#reload').click(submit_form);
	$('#new_reload').click(submit_form);
	$('#save_filter').click(save_filter);
	$('#new_reload').hide();
	$('#filter_label').click(edit_filter_name);
	$('#clear_filter').click(clear_filter);
	$('#save_offer').click(submitServiceOffer);
	$('#sf').change(submit_form);
	$('#find_filter').click(toggleSearchFilter);
	
	$('#service_filter_brand_id').change(searchModel);
	
	if ($('#service_filter_name').val()){
		$('#filter_label').text($('#service_filter_name').val());
		$('#service_filter_name').hide();
		$('#filter_label').show();
		$('#save_filter').hide();
	}else{
		$('#service_filter_name').show();
		$('#filter_label').hide();		
	}
	
	$("#events").easyListSplitter({ colNumber: 7,direction: 'horizontal' });
	$("#cars_events ul").delegate(".small_event","click",showBigEvent);
	$("#cars_events ul").delegate(".big_event","click",hideBigEvent);
	$("#cars_events ul").delegate(".my_big_event","click",hideBigEvent);
	
});

function hideBigEvent(){
  $(this).hide();
}

function showBigEvent(){
  var top =$(this).offset().top -30;
  var left = $(this).offset().left -30;
  $(this).next().offset({top:top,left:left}).show();
}

function toggleSearchFilter(){
	if ($('#sf').is(':visible')){
		$('#sf').hide();
		if ($('#filter_label').text() == "") {
			$('#service_filter_name').show();
			$('#filter_label').hide();
			$('#save_filter').show();
		}else {
			$('#service_filter_name').hide();
			$('#filter_label').show();
			$('#save_filter').hide();
		}
	}else{
		$('#sf').show();
		$('#filter_label').hide();
		$('#service_filter_name').hide();
		$('#save_filter').hide();
	}
	
	
}

function filter_change(){
	$('#reload').hide();
	$('#new_reload').show();
}

function clear_filter(){
	$(".clear").val('');
}

