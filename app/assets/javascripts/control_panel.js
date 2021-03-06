var cp_eventDetailDialog;

function searchNotes(event_id){
  var token = $("input[name='authenticity_token']")[0];
  //AjaxLoader.enable();
  //data: {'authenticity_token':encodeURIComponent(token)},
  $.ajax({
    url: "/events/"+ event_id +"/search_notes",
    dataType:'script',
    type:'GET'
  });
}

function checkAll(element,css){
	var id = "input[class='" + css +"']";
	var value = element.checked;
	$(id).each(function(){
		this.checked = value;
	});
}

function submitServiceOffer(){
	setEventsIds();
	$("#events_ids_chk").val($("#events_ids").val());

	if ($("#events_ids_chk").val() != ""){
		$('#service_offer_service_type_id').val($('#service_filter_service_type_id') .val());
		$('#service_offer_form').submit();
	}else{
		$('#error h2').text("Debe elegir al menos un automovil");
		$('#error').addClass("errorExplanation");
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

function searchModelControlPanel(event){
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

function updateEventSelected(checkbox){
  if (checkbox.is(":checked")){
      checkbox.parent().parent().parent().addClass("small_event_selected");
    }else{
      checkbox.parent().parent().parent().removeClass("small_event_selected");
    }
}

function createNewAlarm(){
  $("#alarms").toggle();
  $(".notes_container,#mesage").hide();
}

function createNewNote(){
  $(".notes_container").toggle();
  $("#alarms,#message").hide();
}

function createNewMessage(){
  $("#alarms,.notes_container").hide();
  $(".message").toggle();
}

jQuery(document).ready( function(){

  if ($("#control_panel").length == 0){return;};

	$('#operators_red').click(function(){checkAll(this,'red');});
	$('#operators_yellow').click(function(){checkAll(this,'yellow');});

  $(".add_alarm").click(createNewAlarm);
  $(".new_note").click(createNewNote);
  $(".new_message").click(createNewMessage);

	$('#reload').click(submit_form);
	$('#new_reload').click(submit_form);
	$('#save_filter').click(save_filter);
	$('#new_reload').hide();
	$('#filter_label').click(edit_filter_name);
	$('#clear_filter').click(clear_filter);
	$('#save_offer').click(submitServiceOffer);
	$('#sf').change(submit_form);
	$('#find_filter').click(toggleSearchFilter);
  //$("#view input:checkbox").click(view);
  $("#select input:checkbox").click(select);
  
  $(".vehicles .cp_event :checkbox").change(function(){
    updateEventSelected($(this));
  });

  $(".vehicles .small_event label").click(function(){
    var checkbox = $(this).parent().parent().parent().find(":checkbox");
    checkbox.click();
    updateEventSelected(checkbox);
  });

	$('#service_filter_brand_id').change(searchModelControlPanel);

	if ($('#service_filter_name').val()){
		$('#filter_label').text($('#service_filter_name').val());
		$('#service_filter_name').hide();
		$('#filter_label').show();
		$('#save_filter').hide();
	}else{
		$('#service_filter_name').show();
		$('#filter_label').hide();
	}

	$("#events").delegate(".due_date","click",showBigEvent);
	$("#events").delegate(".big_event","click",hideBigEvent);
	$("#events").delegate(".my_big_event","click",hideBigEvent);
	$(".labelify").labelify({ labelledClass: "labelHighlight" });

	$(".pagination a").live("click",function(){
	   	var page = $.queryString(this.href).page
	   	var eventIds = "";
	   	setEventsIds();

     	$("#page").val(page);
     	$("#service_filter_form").submit();
    	return false;
  	});

	checkEventsIds();



  cp_eventDetailDialog = $("#event_detail").dialog({
	autoOpen: false ,
    modal: true,
    draggable:true,
    resizable:false,
    width:750,
    title: title,
     close:function(){
    	var notes_txt = [];
    	$(".notes .note").each(function(){
    		notes_txt.push($(this).children().first().children().first().html().trim());
    	});
    	// creo el id del event
    	var event_id = "#event_" + $(".notes_container form").attr("action").match(/\d+/)[0];

    	if (notes_txt.length > 0){
    		$(event_id +" .event_notes").attr("title",notes_txt).addClass("has_notes");
    	}else{
    		$(event_id +" .event_notes").attr("title","").removeClass("has_notes");
    	}

      if ($(".alarms").children().size() > 0){
        $(event_id +" .event_alarm").addClass("has_alarms");
      }else{
        $(event_id +" .event_alarm").removeClass("has_alarms");
      }

      $("#repit").attr("checked",false).trigger('change');

    	$(".notes_container .notes").html("");
    	$(".notes_container .note_form").attr("action","");
      $("#message .new_msg_form").attr("action","");
    },
    open: function(){
    	$("#notes").hide();
      $("#alarms").hide();
    },
    buttons: [
          {
            text: done,
            click:function(){
            	$(this).dialog("close");
            }
          }
        ]
	});


  var dates = $( "#service_filter_date_from, #service_filter_date_to" ).datepicker({
      defaultDate: -30,
      changeMonth: true,
      numberOfMonths: 2,
      onSelect: function( selectedDate ) {
        var option = this.id == "service_filter_date_from" ? "minDate" : "maxDate",
          instance = $( this ).data( "datepicker" ),
          date = $.datepicker.parseDate(
            instance.settings.dateFormat ||
            $.datepicker._defaults.dateFormat,
            selectedDate, instance.settings );
        dates.not( this ).datepicker( "option", option, date );
      }
    });

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
        updateEventSelected(checkbox);
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
        var checkbox = $(this).parent().find("input:checkbox");
        checkbox.prop("checked",true);
        updateEventSelected(checkbox);
      });
    }else{
      $("#events ." + value).each(function(){
        var checkbox = $(this).parent().find("input:checkbox");
        checkbox.prop("checked",false);
        updateEventSelected(checkbox);
      });
    }

}


function hideBigEvent(){
  $(this).fadeOut();
}

function showBigEvent(){
	var event = $(this);
	$("#event_detail").show();
	var event_detail = $("#event_detail .detail");

	var event_id = event.parent().parent().attr("id");
	event_id = event_id.match(/\d*$/)[0];
	searchNotes(event_id);

	var event_data = event.parent().parent();

  if (event_data.find('[class^="mi_domain"]').size() > 0){
    $(".new_message").show();
  }else{
    $(".new_message").hide();
  }

	$.each([".domain",".km",".km_avg",".total_company_spend",".total_spend",".vehicle",".user_full_name",".user_email",".user_phone"],function(index,value){
		var val = event_data.find(value).html();
		if (val != null){
			event_detail.find(value).html(val).show();
			event_detail.find(value + "_label").show();
		}else{
			event_detail.find(value).html("").hide();
			event_detail.find(value + "_label").hide();
		}
	});

	var url = event_data.find(".url").html().trim();
  var alarm_url = event_data.find(".alarm_url").html().trim();
  var message_url = event_data.find(".message_url").html().trim();

	$(".note_form").attr("action",url).find("#element_id").val(event_id);;
	$("#new_alarm").attr("action",alarm_url);
  var msg_form = $(".message .new_msg_form");
  msg_form.attr("action",message_url).find("#element_id").val(event_id);
  msg_form.find("#message_event_id").val(event_id);

  $("#messages_container_").attr("id","messages_container_" + event_id);
  $("#notes_container_0").attr("id","notes_container_" + event_id);


	cp_eventDetailDialog.dialog("open");
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

