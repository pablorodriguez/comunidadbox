
jQuery(document).ready( function(){
  
  if ($("#clients").length == 0){return;};


  $("#clients").delegate(".new_message","click",function(){
    $(this).parent().parent().parent().find(".message").toggle();
  });

  var dates = $( "#date_from, #date_to" ).datepicker({
    defaultDate: -60,      
    changeMonth: true,
    numberOfMonths: 3,
    onSelect: function( selectedDate ) {
      var option = this.id == "date_from" ? "minDate" : "maxDate",
        instance = $( this ).data( "datepicker" ),
        date = $.datepicker.parseDate(
          instance.settings.dateFormat ||
          $.datepicker._defaults.dateFormat,
          selectedDate, instance.settings );
      dates.not( this ).datepicker( "option", option, date );
    }
  });
})
