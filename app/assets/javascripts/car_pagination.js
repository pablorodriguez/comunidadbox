//#car_pagination.js
jQuery(document).ready(function(){

  if ($("#all_cars").length == 0){return;};
  
  //$("#new_note_link").click(createNewNoteCar);
  //$("#workorders").delegate(".new_note_link","click",createNewNoteCar);

  $("#create_new_service").click(createNewService);



  $(".new_note_link").click(new_note);  

  $(".new_service").click(createNewService);

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

  
  $("#service_done").click(function(){showHideContent($(this),"#cars_work_orders");}).click();
  $("#future_event").click(function(){showHideContent($(this),"#cars_future_events");});
  $("#report_graph").click(function(){showHideContent($(this),"#cars_report_graphics");});
  $("#create_new_message").click(function(){showHideContent($(this),"#cars_messages");});

  $("#note").click(function(){
    showHideContent($(this),"#cars_notes");
    $("#cars_notes .notes_container").show().find(".notes").show();
  });  
  $("#messages").click(function(){showHideContent($(this),"#cars_messages");});
  $("#budgets_link").click(function(){showHideContent($(this),"#car_budgets")});

  $(".contentright_s .labelify").labelify({ labelledClass: "labelHighlight" });

  $("#car_domain").mouseenter(function(){
    $("#client_info").fadeIn();
  }).mouseleave(function(){
    $("#client_info").fadeOut();
  });

  $(".wo_info_detail").click(function(){      
    $(this).parent().parent().parent().next().toggle();
  });

});

function createNewNoteCar(){
  
  $("#cars_notes .notes_container").show();

  if($("#cars_notes").is(":hidden")){
    $(".contentright_s .data").hide();
    $("#cars_notes").show();  
  }
  $("#notes_form_container").slideToggle();
  
}

function createNewService(){
  var car_id = $(this).attr("data-car-id");
  $("#company-selector").dialog('open');
  $("#company-selector #car_id").val(car_id);
  
  $(".new_service_link").each(function(){
    var href = $(this).attr("href");
    href = href + "&car_id=" + car_id;
    $(this).attr("href",href);
  });
  
}



