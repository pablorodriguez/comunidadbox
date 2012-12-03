jQuery(document).ready(function(){

  $(".info_note").click(function(){
    var url = $(this).prev().html();    
    mark_as_read(url);
  });

});

function mark_as_read(url){
    $.ajax({
      url: url,
      dataType:'script',
      type:'POST'
  });
}