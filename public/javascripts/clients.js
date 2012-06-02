
jQuery(document).ready( function(){
$(".pagination a").live("click",function(){
      var page = $.queryString(this.href).page
      $("#page").val(page);
      $("#search_client_form").submit(); 
      return false;
    });
})
