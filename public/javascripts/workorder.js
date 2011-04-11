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
	initAjaxPagination();
});

function submitForm(sort_column,direction){
	$("#sort").val(sort_column);
	$("#direction").val(direction);
	$("#filter").submit();
}

function initAjaxPagination(){
  $(".pagination a").click(function(){
    $.get(this.href,null,null,"script");
    return false;
  });
};

