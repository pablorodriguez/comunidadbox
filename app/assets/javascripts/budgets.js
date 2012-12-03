jQuery(document).ready( function(){

  $(".new_note_link").click(new_note);

  $('#brand_id').change(searchModel);
  
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

  $(".material").each(function(){
    initMaterialAutocomplete($(this))
  });
  
});

function searchModel(event){
  var brand_id = event.target.id; 
  var token = $("input[name='authenticity_token']").val();
  AjaxLoader.enable();
  $.ajax({
    url: "/control_panels/find_models",
      data: {
        'id':brand_id,
        'brand_id':$("#"+brand_id).val(),
        'authenticity_token':encodeURIComponent(token)
      },
    dataType:'script',
    type:'POST'
  });  
}

