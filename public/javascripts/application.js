// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready( function(){
  $.datepicker.setDefaults( $.datepicker.regional[ "es" ] );
	$("#avatar").click(showGRAvatar);
	$("#app_msg").ajaxError(function(event,request,settings){
		$(this).html("Ha ocurrido un error general en la applicación. Por favor intente nuevamente en 5 minutos");
		$(".ajax_loader").hide();
	});
	
});

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

