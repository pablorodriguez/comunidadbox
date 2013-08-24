
jQuery(document).ready( function(){
  
  if ($("#clients").length == 0){return;};


  $("#clients").delegate(".new_message","click",function(){
    $(this).parent().parent().parent().find(".message").toggle();
  });

 
})
