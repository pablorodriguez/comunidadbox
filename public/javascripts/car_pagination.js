jQuery(document).ready(function(){
  
  $(".notes_container").hide();
  var notes_links = $(".new_note_link");
  if (notes_links.length > 0){
    notes_links.click(new_note);  
  }

  var service_links = $(".new_service");
  if (service_links.length > 0){
    service_links.click(createNewService);
  }  
  

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

function createNewNote(){
  if($("#cars_notes").is(":hidden")){
    $(".contentright_s .data").hide();
    $("#cars_notes").show();  
  }
  $("#notes_form_container").slideToggle();
  
}

function createNewService(){
  var car_id = $(this).attr("id");
  $("#company-selector").dialog('open');
  $("#company-selector #car_id").val(car_id);
  
  $(".new_service_link").each(function(){
    var href = $(this).attr("href");
    href = href + "&car_id=" + car_id;
    $(this).attr("href",href);
  });
  
}



