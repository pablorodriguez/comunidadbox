jQuery(document).ready( function(){
   
  $("#rank_form").delegate(".star","click",setRank);
  $("#rank_form").delegate(".star_select","click",setRank);

  
});

function setRank(){
  var ele = $(this);
  var rank = ele.attr("id");
  var parent= ele.parent();
  parent.next().html(ele.attr("title"));
  $("#rank_form #rank_cal").val(rank);
  var stars = parent.find(".star");
  stars.removeClass("star_select").addClass("star");
  for(var i=1;i <= rank;i++){
    parent.find("#"+i).addClass("star_select");
  }

}
