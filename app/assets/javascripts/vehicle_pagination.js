//#vehicle_pagination.js
jQuery(document).ready(function(){

  if ($("#all_vehicles").notExist()){return;};

  //$("#new_note_link").click(createNewNoteVehicle);
  //$("#workorders").delegate(".new_note_link","click",createNewNoteVehicle);

  $("#create_new_service").click(createNewService);

  $(".company_detail").live("click",selectCompany);

  $(".new_service").click(createNewService);

  //$("#all_vehicles").delegate(".message_form","click",submit_message_form);

  $("#all_vehicles").delegate(".new_note_link","click",new_note);
  $("#all_vehicles").delegate(".new_message","click",new_message_wo);

  var dates = $( "#date_from, #date_to" ).datepicker({
      defaultDate: -60,
      changeMonth: true,
      numberOfMonths: 3,
      onSelect: function( selectedDate ) {
        var option = this.id == "date_from" ? "minDate" : "maxDate",
          instance = $( this ).data( "datepicker" ),
          date = $.datepicker.parseDate(
            instance.settings.dateFormat ||
            $.datepicker._defaults.dateFormat,
            selectedDate, instance.settings );
        dates.not( this ).datepicker( "option", option, date );
      }
    });
  $("#service_types :checkbox[id!='all_service_type']").change(function(){
    $(this).parent().parent().parent().find(":checkbox[id='all_service_type']").attr("checked",false);
  });

  $("#service_types #all_service_type").change(function(){
    if ($("#all_service_type").attr("checked")){
      $("#service_types :checkbox[id!='all_service_type']").attr("checked",true);
    }else{
      $("#service_types :checkbox[id!='all_service_type']").attr("checked",false);
    }
  });

  $("#paginator_wo .pagination a").live("click",function(){
    $.setFragment({"page" : $.queryString(this.href).page,
    "page" : $.queryString(this.href).page,
    "d":"wo"
    });
    return false;
  });

  $("#paginator_event .pagination a").live("click",function(){
    $.setFragment({"page" : $.queryString(this.href).page,
    "page" : $.queryString(this.href).page,
    "d":"e"
    });
    return false;
  });

  $.fragmentChange(true);
  $(document).bind("fragmentChange.page",function(){
    $.getScript($.queryString(document.location.href,{
      "page" : $.fragment().page,
      "d":$.fragment().d
      }));
   });

   if ($.fragment().page){
     $(document).trigger("fragmentChange.page");
   }

   $("#company-selector").dialog({
    height: 600,
    width:850,
    title:'Seleccionar Prestador de Servicio',
    autoOpen: false,
    draggable: false,
    resizable:false,
    modal: true});

  $(".contentleft input").labelify({ labelledClass: "labelHighlight" });
  $(".contentright .labelify").labelify({ labelledClass: "labelHighlight" });


  $("#service_done").click(function(){showHideContent($(this),"#vehicles_work_orders");});
  $("#future_event").click(function(){showHideContent($(this),"#vehicles_future_events");});
  $("#report_graph").click(function(){showHideContent($(this),"#vehicles_report_graphics");});
  $("#create_new_message").click(function(){showHideContent($(this),"#vehicles_messages");});

  $("#note").click(function(){
    showHideContent($(this),"#vehicles_notes");
    $("#vehicles_notes .notes_container").show().find(".notes").show();
  });
  $("#messages").click(function(){showHideContent($(this),"#vehicles_messages");});
  $("#budgets_link").click(function(){showHideContent($(this),"#vehicle_budgets")});

  $(".contentright_s .labelify").labelify({ labelledClass: "labelHighlight" });

  $("#vehicle_domain").mouseenter(function(){
    $("#client_info").fadeIn();
  }).mouseleave(function(){
    $("#client_info").fadeOut();
  });

  $(".wo_info_detail").click(function(){
    $(this).parent().parent().parent().next().toggle();
  });

});

function selectCompany(){
  var url = $(this).parent().find(".new_service_link").attr("href");
  window.location = url;
}

function createNewNoteVehicle(){

  $("#vehicles_notes .notes_container").show();

  if($("#vehicles_notes").is(":hidden")){
    $(".contentright_s .data").hide();
    $("#vehicles_notes").show();
  }
  $("#notes_form_container").slideToggle();

}

function createNewService(){
  var vehicle_id = $(this).attr("data-vehicle-id");
  $("#company-selector").dialog('open');
  $("#company-selector #vehicle_id").val(vehicle_id);

  $(".new_service_link").each(function(){
    var href = $(this).attr("href");
    href = href + "&vehicle_id=" + vehicle_id;
    $(this).attr("href",href);
  });

}



