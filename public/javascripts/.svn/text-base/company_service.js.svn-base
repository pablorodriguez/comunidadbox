jQuery(document).ready( function(){
	$(".service_type_id").change(function(){
		var element = $(this);
		var checked = element.attr("checked");
		var ser_type= element.val();
		element.parent().next().show();
		if (checked){
			addServiceType(ser_type);
		}else{
			removeService(ser_type);	
		}	
	});
});

function removeService(ser_type_id){
		$.ajax({
			url: "/companies/remove_service_type",
			data: {
				'id':ser_type_id
			},
		dataType:'script',
		type:'POST'
	});
	
}

function addServiceType(ser_type_id){
		$.ajax({
			url: "/companies/add_service_type",
			data: {
				'id':ser_type_id
			},
		dataType:'script',
		type:'POST'
	});
}