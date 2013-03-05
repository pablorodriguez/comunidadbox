jQuery(document).ready( function(){
   
  $("#rank_form").delegate(".star","click",setRank);
  $("#rank_form").delegate(".star_select","click",setRank);

  $("a.rank").click(function(){
    $(".rank_form").slideToggle();
  });

  $("a.send_msg").click(function(){
    $("#msg_container").slideToggle();
  });

});

function setRank(){
  var ele = $(this);
  var rank = ele.attr("id");
  var parent= ele.parent();
  parent.next().html(ele.attr("title"));
  $("#rank_form #rank_cal").val(rank);
  var stars = parent.find(".cal");
  stars.removeClass("star_select").addClass("star");
  for(var i=1;i <= rank;i++){
    parent.find("#"+i).addClass("star_select");
  }

}
