
jQuery(document).ready( function(){
$("#clients").delegate(".pagination a","click",function(){
      var page = $.queryString(this.href).page
      $("#page").val(page);
      $("#search_client_form").submit(); 
      return false;
    });
})
