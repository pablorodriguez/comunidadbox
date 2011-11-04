jQuery(document).ready(function(){
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
  $("#notes").click(function(){showHideContent($(this),"#cars_notes");});
  $("#alarms").click(function(){showHideContent($(this),"#cars_alarms");});
  $("#messages").click(function(){showHideContent($(this),"#cars_messages");});

  $(".contentright_s .labelify").labelify({ labelledClass: "labelHighlight" });

  $("form.note_form").bind("ajax:success", function(evt, data, status, xhr){
      var $form = $(this);
      this.reset();
      $(xhr.responseText).insertBefore($form.parent().parent().next().find(".note").first());
      $form.parent().parent().next().find(".note").first().effect("highlight", {color:"#F7DE4F"}, 3000);
    })

    $("#car_domain").mouseenter(function(){
      $("#client_info").fadeIn();
    }).mouseleave(function(){
      $("#client_info").fadeOut();
    });

    $(".wo_info_detail").mouseenter(function(){
      $(this).parent().parent().parent().parent().next().show();
    }).mouseleave(function(){
      $(this).parent().parent().parent().parent().next().hide();
    });

});

function createNewNote(){
  $("#notes_form_container").slideToggle();
}




function createNewService(car_id){
  $("#company-selector").dialog('open');
  $("#company-selector #car_id").val(car_id);
  
  $(".new_service_link").each(function(){
    var href = $(this).attr("href");
    href = href + "&car_id=" + car_id;
    $(this).attr("href",href);
  });
  
}

function newCompany(target){
  $("#all_companies").hide();
  $("#new_company").show();  
}

function cancelNewCompany(target){
  $("#all_companies").show();
  $("#new_company").hide();
}

function newServiceNewCompany(){
  var url = $("#new_service_url").val();
  var comp_info =$("#company_info").val();$
  window.location=url + "&c="+comp_info;
}

function show_notes(element){
  $(element).parent().parent().parent().find(".notes").slideToggle();
}

function new_note(element){
  $(element).parent().parent().parent().find(".new_note").slideToggle();
}