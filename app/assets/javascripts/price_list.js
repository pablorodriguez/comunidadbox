jQuery(document).ready(function(){
  $('#percentage').blur(updatePrice);
  if ($("#percentage").asNumber() > 0){
    updatePrice();
  }

  $("a#update_from_file").on('click',function(){
    $("#price_list_container").slideToggle();
    $(".upload_file").slideToggle();
  });

  $("a#price_list_items").on('click',function(){
    $("#price_list_container").slideToggle();
    $(".upload_file").slideToggle();
  });
});

function updatePrice(){
  var percentaje = 1 + ($("#percentage").asNumber() / 100);
  $(".currency").each(function(){
    var element = $(this);
    var newPriceEle = $(this).next().find("input");
    var value = element.asNumber();
    if (value == 0){
      value = newPriceEle.val();
    }
    var newValue = (value * percentaje).toFixed(2);
    
    newPriceEle.val(newValue);
    //newPriceEle.formatCurrency();
    //newPriceEle.toNumber();
    newPriceEle.next().html(newValue - value);
    newPriceEle.next().formatCurrency();
    
  });
  updatePaginationLinks();
}
function updatePaginationLinks(){
  var param = "&percentage=" + $("#percentage").val();
  jQuery(".pagination").find("a").each(function(){
    var link = $(this);
    var href = link.attr("href");
    link.attr("href",href + param);
  });
}

function savePriceList(){
  var newCheckBox =$(".service_type_id:checked").clone();
  $("#service_types_ids").append(newCheckBox);
  var material = $("#service_types").find("#material").val();
  $("#service_types_ids").find("#material").val(material);
  $("#price_list_form").submit();
  //return true;
}
