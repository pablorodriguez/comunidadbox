jQuery(document).ready(function(){
	$(".pagination a").live("click",function(){
	  
	  var date_from = $.queryString(this.href).date_from ? $.queryString(this.href).date_from : "";
	  var date_to = $.queryString(this.href).date_to ? $.queryString(this.href).date_to : "";
	  var domain = $.queryString(this.href).domain ? $.queryString(this.href).domain : "";
	  var wo_status_id = $.queryString(this.href).wo_status_id ? $.queryString(this.href).wo_status_id : "";
	  var service_type_ids = $.queryString(this.href).service_type_ids ? $.queryString(this.href).service_type_ids : "";
	  
	  $.setFragment({
	     "page" : $.queryString(this.href).page,	
	     "date_from" : date_from ,
	     "date_to": date_to,
	     "domain": domain,
	     "wo_status_id":wo_status_id,
	     "service_type_ids" : service_type_ids
	     }); 	
		return false;
	});

	4(window).bind('haschange',function(e){
		
	})
	
	//$.fragmentChange(true);
	
	$(document).bind("fragmentChange.page",function(){
	  $.getScript($.queryString(document.location.href,{
	    "page" : $.fragment().page,
	    "date_from" : $.fragment().date_from,
	    "date_to": $.fragment().date_to,
	    "domain":$.fragment().domain,
	    "wo_status_id":$.fragment().wo_status_id,
	    "service_type_id": $.fragment().service_type_id
	    }));
	 });
	 
	 if ($.fragment().page){
	   $(document).trigger("fragmentChange.page");
	 }
});
