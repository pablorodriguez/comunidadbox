
jQuery(document).ready(function(){

  if ($(".messages").length == 0){return;}


  $(".other_msg > .info_note").click(function(){    
    $(this).parent().find("a.read").click();    
  });


});


