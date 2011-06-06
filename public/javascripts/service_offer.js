/**
 * @author pablo
 */
jQuery(document).ready( function(){

	$('#service_offer_since').datepicker({
			showOn: 'button',
			buttonImage: '/images/calendar.png',
			buttonImageOnly: true
		});
	$('#service_offer_until').datepicker({
			showOn: 'button',
			buttonImage: '/images/calendar.png',
			buttonImageOnly: true
		});
		
	$('#todos').click(function(){checkAll(this);});
	$("#service_offer_final_price").blur(calculateValues);
	$("#service_offer_percent").blur(calculateValues);
	$(".service_offer_row").live("mouseover",showActionButtons).live("mouseleave",hideActionButtons);
	$(".row").live("click",viewRow);
});

function viewRow(){
  var href = $(this).find(".view").attr("href");
  window.location=href;
}

function showActionButtons(){
  $(this).find(".serivce_offer_actions").show();
  $(this).addClass("link").addClass("row_over");  
}

function hideActionButtons(){
  $(this).find(".serivce_offer_actions").hide();
  $(this).removeClass("link").removeClass("row_over");
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
