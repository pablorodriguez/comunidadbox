jQuery(document).ready( function(){
   
  $(".star.link").live("click",setRank);
  $(".star_select.link").live("click",setRank);
  
});

function setRank(){
  var cal = $(this).attr("id");

  $(this).parent().parent().find("#rank_cal").val(cal);
  $(this).parent().parent().find("form").submit();
  
  $(this).parent().html("<img src='/images/ajax-loader.gif' alt='Ajax-loader' class='ajax'>");
}
