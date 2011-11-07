/**
 * @author Hernan
 */
 var chart;
jQuery(document).ready( function(){
   
    var dates = $( "#date_from, #date_to" ).datepicker({
      defaultDate: "",
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

		
	$(".dropdown dt a").live("click",function() {
    $(".dropdown dd ul").toggle();    
  });
  
  
  $(".dropdown dd ul li a").live("click",function() {
    setSort($(this));
  }); 
  
  $(document).bind('click', function(e) {
    var $clicked = $(e.target);
    if (! $clicked.parents().hasClass("dropdown"))
        $(".dropdown dd ul").hide();
  });
  
  $("#workorder_tabs").tabs();
  $(".contentleft input").labelify({ labelledClass: "labelHighlight" });
  $(".labelify").labelify({ labelledClass: "labelHighlight" });  

  $("form.note_form").bind("ajax:success", function(evt, data, status, xhr){
      var $form = $(this);
      this.reset();
      $form.parent().parent().next().append(xhr.responseText);  
      $form.parent().parent().parent().parent().find(".notes_link").show().parent().show()
      $form.parent().parent().next().find(".note").last().effect("highlight", {color:"#F7DE4F"}, 3000);
    })

  $("#service_done").click(function(){showHideContent($(this),"#workorders_c");});
  $("#report_amount").click(function(){showHideContent($(this),"#price_graph_c");});
  $("#report_quantiy").click(function(){showHideContent($(this),"#amt_graph_c");});
  $("#report_detail").click(function(){showHideContent($(this),"#report_data");});

  $("#service_types :checkbox[id!='all_service_type']").change(function(){
    $(this).parent().parent().parent().find(":checkbox[id='all_service_type']").attr("checked",'');
  })

  $(".wo_info_detail").live("mouseenter",function(){
      $(this).parent().parent().parent().parent().next().show();
    }).live("mouseleave",function(){
      $(this).parent().parent().parent().parent().next().hide();
    });

  
});

function changeSort() {
  var order = $("#order_by").find("dt a span.order").html();
  var by = $("#order_by").find("dt a span.value").html();
  submitForm(by,order);
}

function setSort(element){
    var text = element.html();
    $(".dropdown dt a span").html(text);
    $(".dropdown dd ul").hide();
    changeSort();
}


function submitForm(sort_column,direction){
	$("#sort").val(sort_column);
	$("#direction").val(direction);
	$("#filter").submit();
}

function show_notes(element){
  $(element).parent().parent().parent().find(".notes").slideToggle();
}

function new_note(element){
  $(element).parent().parent().parent().find(".new_note").slideToggle();
}
