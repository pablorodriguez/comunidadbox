
jQuery(document).ready(function(){

  if ($("#clients_msg").length == 0){return;}

  $("#clients_msg .row").click(function(event){
    var href = $(this).find("a.new_message").attr("href");
    window.location=href;
  });

});
