$ ->
    
  $("#company_big_image").dialog
    height: 515
    width:650
    autoOpen: false
    draggable: false
    resizable:false
    modal: true


  $(".company_image").click (ele)->
    $("#company_big_image img").attr("src",$(ele.target).parent().data("image-url"))
    $("#company_big_image").dialog('open')