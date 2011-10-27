/**
 * @author Hernan
 */
 var chart;
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
    setSort($(this));
  }); 
  
  $(document).bind('click', function(e) {
    var $clicked = $(e.target);
    if (! $clicked.parents().hasClass("dropdown"))
        $(".dropdown dd ul").hide();
  });
  
  $("#workorder_tabs").tabs();
  $(".contentleft input").labelify({ labelledClass: "labelHighlight" });
  $(".contentright .labelify").labelify({ labelledClass: "labelHighlight" });

  $("form.note_form").bind("ajax:success", function(evt, data, status, xhr){
      var $form = $(this);
      this.reset();
      $form.parent().parent().next().append(xhr.responseText);  
      $form.parent().parent().parent().parent().find(".notes_link").show().parent().show()
      $form.parent().parent().next().find(".note").last().effect("highlight", {color:"#F7DE4F"}, 3000);
    })
  
  
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
