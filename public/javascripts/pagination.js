jQuery(document).ready(function(){
	$(".pagination a").live("click",function(){
	  
	  var date_from = $.queryString(this.href).date_from ? $.queryString(this.href).date_from : "";
	  var date_to = $.queryString(this.href).date_to ? $.queryString(this.href).date_to : "";
	  var domain = $.queryString(this.href).domain ? $.queryString(this.href).domain : "";
	  var service_type_id = $.queryString(this.href).service_type_id ? $.queryString(this.href).service_type_id : "";
	  
	  $.setFragment({
	     "page" : $.queryString(this.href).page,	
	     "date_from" : date_from ,
	     "date_to": date_to,
	     "domain": domain,
	     "service_type_id" : service_type_id
	     }); 	
		return false;
	});
	
	$.fragmentChange(true);
	$(document).bind("fragmentChange.page",function(){
	  $.getScript($.queryString(document.location.href,{
	    "page" : $.fragment().page,
	    "date_from" : $.fragment().date_from,
	    "date_to": $.fragment().date_to,
	    "domain":$.fragment().domain,
	    "service_type_id": $.fragment().service_type_id
	    }));
	 });
	 
	 if ($.fragment().page){
	   $(document).trigger("fragmentChange.page");
	 }
});
