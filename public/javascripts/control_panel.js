function checkAll(element,css){
	var id = "input[class='" + css +"']";
	var value = element.checked;
	$(id).each(function(){
		this.checked = value;
	});
}

function submitServiceOffer(){
	if ($("#cars_events input:checkbox:checked").size() > 0){
		setEventsIds();
		$("#events_ids_chk").val($("#events_ids").val());		
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
	
	$("#events").delegate(".small_event","click",showBigEvent);
	$("#events").delegate(".big_event","click",hideBigEvent);
	$("#events").delegate(".my_big_event","click",hideBigEvent);
	
	
	$(".pagination a").live("click",function(){
	   	var page = $.queryString(this.href).page
	   	var eventIds = "";
	   	setEventsIds();
	   	
     	$("#page").val(page);
     	$("#service_filter_form").submit(); 
    	return false;
  	});

	checkEventsIds();
  
  //$("#view input:checkbox").click(view);
  $("#select input:checkbox").click(select);
   
});

function checkEventsIds(){
  //Si hay datos en events id, busco los checkbox y los selecciono
  var events_ids = $("#events_ids").val();
  var remove_ids ="";
  if (events_ids != ""){
  	var ids = events_ids.substr(1,events_ids.length).split("#");
  	for(var x=0,n = ids.length;x < n;x++){
  		var checkbox = $("#events input:checkbox[value='" + ids[x] + "']");
  		if (checkbox.size() > 0){
  			checkbox.attr("checked","checked");
  			remove_ids += "#" + ids[x];
  		}
  	}
  	if (remove_ids != ""){
  		$("#events_ids").val(events_ids.replace(remove_ids,""));
  	}
  	
  }
	
}

function setEventsIds(){
	var eventIds ="";
	$("#events input:checked").each(function(){
	   		eventIds += "#" + $(this).val();
	});
	var history_ids =  $("#events_ids").val();
   	if (eventIds != "") {
   		$("#events_ids").val(history_ids + eventIds);
   		console.debug( "Envio estos ids " + $("#events_ids").val());
   	}	
}

function view(){
  $("#view input:checkbox").each(function(){
    var value = $(this).attr("value");      
    if (this.checked){
      $("#events ." + value).each(function(){
        $(this).parent().show();
      });
    }else{
      $("#events ." + value).each(function(){
        $(this).parent().hide();
      });      
    }
    
  });
  
}

function select(){
   
    var value = $(this).attr("value");      
    if (this.checked){
      $("#events ." + value).each(function(){        
        $(this).find("input:checkbox").attr("checked","checked");
      });
    }else{
      $("#events ." + value).each(function(){
        $(this).find("input:checkbox").attr("checked","");
      });      
    }
      
}


function hideBigEvent(){
  $(this).fadeOut();
}

function showBigEvent(){
  var top =$(this).offset().top -30;
  var left = $(this).offset().left -30;
  $(this).parent().next().offset({top:top,left:left}).fadeIn();
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

