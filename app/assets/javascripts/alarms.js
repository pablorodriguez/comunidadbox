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

  $("#repit").change(function(){
    if($(this).attr("checked")){
      $("#repit_container").show();
    }else{
      $("#repit_container").hide();
      $("#repit_container :text").val("");
      $("#repit_container :checkbox").attr("checked","");
    }    
  });

  if ($("#repit_container :checkbox:checked").size() > 0){
    $("#repit_container").show();
    $("#repit").attr("checked","checked");
  }
  

  $("#no_end").change(function(){
    if($(this).attr("checked")){
      $("#repit_container .date_range").attr('disabled','disabled').val("");
    }else{
      $("#repit_container .date_range").attr('disabled','').val("");
    }
  }).change();

  $("#all").change(function(){
    if($(this).attr("checked")){
      $("#repit_container .day").attr("checked",true);
    }else{
      $("#repit_container .day").attr('checked',false);
    }

  });


});