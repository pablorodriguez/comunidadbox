/**
 * @author pablo
 */
jQuery(document).ready( function(){

    var dates = $( "#service_offer_since, #service_offer_until" ).datepicker({
      defaultDate: "",
      changeMonth: true,
      numberOfMonths: 3,
      onSelect: function( selectedDate ) {
        var option = this.id == "service_offer_since" ? "minDate" : "maxDate",
          instance = $( this ).data( "datepicker" ),
          date = $.datepicker.parseDate(
            instance.settings.dateFormat ||
            $.datepicker._defaults.dateFormat,
            selectedDate, instance.settings );
        dates.not( this ).datepicker( "option", option, date );
      }
    });

	
  initDaysColumn();
	$('#todos').click(function(){checkAll(this);});
	$("#service_offer_final_price").blur(calculateValues);
	$("#service_offer_percent").blur(calculateValues);
	//$(".service_offer_row").live("click",viewRow).live("mouseover",showActionButtons).live("mouseleave",hideActionButtons);
	
});

function initDaysColumn(){
  $(".days").each(function(){
    if ($(this).find("li").size() > 3){
      $(this).columnize({ columns: 2 });
    }else{
      $(this).addClass("days_col1");
    }    
  });
}

function viewRow(){
  var href = $(this).find(".view").attr("href");
  window.location=href;
}

function showActionButtons(){
  $(this).children().last().show();
  $(this).addClass("row_over");  
}

function hideActionButtons(){
  $(this).children().last().hide();
  $(this).removeClass("row_over");
}

function checkAll(element){	
	var value = element.checked;
	$(".day").each(function(){
		this.checked = value;
	});
}

function calculateValues(element){
	var id = element.target.id;
	var finalPriceE = $("#service_offer_final_price");
	var percentajeE = $("#service_offer_percent");
	var priceE =$("#service_offer_price");
	var	price = Number(priceE.val());
	if (id=="service_offer_percent"){		
		var percentaje = Number(percentajeE.val());
		var finalPrice = price * (1-(percentaje/100));
		finalPriceE.val(finalPrice);	
	}else{
		var finalPrice = Number(finalPriceE.val());
		var price = Number(priceE.val());
		var percentaje = ((price - finalPrice) / price) * 100;
		percentajeE.val(percentaje);
	}
}
