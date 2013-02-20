
jQuery(document).ready( function(){

  $("#clients").delegate(".new_message","click",function(){
    $(this).parent().parent().parent().parent().find(".message").toggle();
  });


  $("#clients").delegate(".pagination a","click",function(){
      var page = $.queryString(this.href).page
      $("#page").val(page);
      $("#search_client_form").submit(); 
      return false;
    });
})
