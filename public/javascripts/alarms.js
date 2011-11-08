jQuery(document).ready(function(){
	$('#alarm_date_ini').datetimepicker({
		onSelect: function (selectedDateTime){
			var start = $(this).datetimepicker('getDate');
			$('#alarm_date_end').datetimepicker('option', 'minDate', new Date(start.getTime()) );
		}
	});

	$('#alarm_date_end').datetimepicker({
		onSelect: function (selectedDateTime){
			var end = $(this).datetimepicker('getDate');
			$('#alarm_date_ini').datetimepicker('option', 'maxDate', new Date(end.getTime()) );
		}
	});	

	$('#alarm_date_alarm').datetimepicker();

});