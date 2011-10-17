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
   
   $("#service-tabs").tabs();
   
   $("#company-selector").dialog({
    height: 570,
    width:650,
    title:'Seleccionar Prestador de Servicio',
    autoOpen: false,
    draggable: false,
    resizable:false,
    modal: true});

  $(".contentleft input").labelify({ labelledClass: "labelHighlight" });
  $(".contentright .labelify").labelify({ labelledClass: "labelHighlight" });
    

});

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