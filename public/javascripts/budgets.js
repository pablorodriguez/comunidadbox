jQuery(document).ready( function(){
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


  $("#service_types :checkbox[id!='all_service_type']").change(function(){
    $(this).parent().parent().parent().find(":checkbox[id='all_service_type']").attr("checked",'');
  })
  
  $("#service_types #all_service_type").change(function(){
  if ($("#all_service_type").attr("checked")){
    $("#service_types :checkbox[id!='all_service_type']").attr("checked",'checked');  
  }else{
    $("#service_types :checkbox[id!='all_service_type']").attr("checked",'');  
  }
})

});

function show_notes(element){
  $(element).parent().parent().parent().parent().find(".notes").slideToggle();
}

function new_note(element){
  $(element).parent().parent().parent().parent().find(".new_notes").slideToggle();
}