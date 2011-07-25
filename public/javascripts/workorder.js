/**
 * @author Hernan
 */
jQuery(document).ready( function(){
   
	$('#date_from').datepicker({
			showOn: 'button',
			buttonImage: '/images/calendar.png',
			buttonImageOnly: true
		});
	$('#date_to').datepicker({
			showOn: 'button',
			buttonImage: '/images/calendar.png',
			buttonImageOnly: true
		});
		
	$(".dropdown dt a").live("click",function() {
    $(".dropdown dd ul").toggle();    
  });
  
  
  $(".dropdown dd ul li a").live("click",function() {
    var text = $(this).html();
    $(".dropdown dt a span").html(text);
    $(".dropdown dd ul").hide();
    changeSort();
  }); 
  
  $(document).bind('click', function(e) {
    var $clicked = $(e.target);
    if (! $clicked.parents().hasClass("dropdown"))
        $(".dropdown dd ul").hide();
  });
  
});

function changeSort() {
  var order = $("#order_by").find("dt a span.order").html();
  var by = $("#order_by").find("dt a span.value").html();
  submitForm(by,order);
}


function submitForm(sort_column,direction){
	$("#sort").val(sort_column);
	$("#direction").val(direction);
	$("#filter").submit();
}

