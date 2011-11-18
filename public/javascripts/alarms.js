jQuery(document).ready(function(){

	var dates = $( "#alarm_date_ini, #alarm_date_end" ).datepicker({
      defaultDate: "",
      changeMonth: true,
      numberOfMonths: 3,
      onSelect: function( selectedDate ) {
        var option = this.id == "alarm_date_ini" ? "minDate" : "maxDate",
          instance = $( this ).data( "datepicker" ),
          date = $.datepicker.parseDate(
            instance.settings.dateFormat ||
            $.datepicker._defaults.dateFormat,
            selectedDate, instance.settings );
        dates.not( this ).datepicker( "option", option, date );
      }
    });


	$('#alarm_date_alarm').datetimepicker();

});