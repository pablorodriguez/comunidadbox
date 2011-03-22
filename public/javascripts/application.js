// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready( function(){
  
  $('ul li:has(ul)').hover( 
      function(e) 
      { 
         $(this).find('ul').css({display: "block"}); 
      }, 
      function(e) 
      { 
         $(this).find('ul').css({display: "none"}); 
      } 
   ); 
   
	$('.login').each(function(){
		$(this).click(toggleLogin);
		});
		
	$("#avatar").click(showGRAvatar);
	$("#app_msg").ajaxError(function(event,request,settings){
		$(this).html("Ha ocurrido un error general en la applicación. Por favor intente nuevamente en 5 minutos");
		$(".ajax_loader").hide();
	});
	
	
	if ($("#notice").length > 0){
    $container = $("#msgs").notify();
    create("sticky",{},{sticky:true});
  }
});

function create( template, vars, opts ){
  return $container.notify("create", template, vars, opts);
}

function resetStatusMessages(){
  //$("#msgs").fadeOut();
}

function showGRAvatar(){
	window.open("http://www.gravatar.com");
	return false;
}

function beforeSubmit(form){
	$(form).find("input[type=submit]").disable();
}

function afterSubmit(form){
	$(form).find("input[type=submit]").enable();
}

function toggleLogin(){
	$("#login").toggle();
}

var AjaxLoader={};

AjaxLoader={
	disable:function(idElement){
		var defaultId="#ajax_loader";
		if (idElement) {
			defaultId = idElement;
		}
		
		$(defaultId).hide();
		//$('#car_domains :input').each(function(){
		//	$(this).attr("disabled", "disabled");
		//});		
	},
	enable:function(idElement){
		var defaultId="#ajax_loader";
		if (idElement) {
			defaultId = idElement;
		}
		$(defaultId).show();
		//$('#car_domains :input').each(function(){
		//	$(this).attr("disabled", "");
		//});
		//$('#car_domain').val("");
	}
};

function initTable(){
    $('#sort_table').dataTable({
		"iDisplayLength": 10,
		"oLanguage": {
			"sProcessing":   "Procesando...",
		    "sLengthMenu":   "Mostrar _MENU_ registros",
		    "sZeroRecords":  "No se encontraron resultados",
		    "sInfo":         "Mostrando desde _START_ hasta _END_ de _TOTAL_ registros",
		    "sInfoEmpty":    "Mostrando desde 0 hasta 0 de 0 registros",
		    "sInfoFiltered": "(filtrado de _MAX_ registros en total)",
		    "sInfoPostFix":  "",
		    "sSearch":       "Buscar:",
		    "sUrl":          "",
		    "oPaginate": {
		        "sFirst":    "Primero",
		        "sPrevious": "Anterior",
		        "sNext":     "Siguiente",
		        "sLast":     "Último"
		    }
		}
	});
}
