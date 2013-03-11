$ ->
  if ($(".generate_email").exist())
    $("#user_email").blur(validate_email)  

validate_email = ->
  ele = $(this)
  ajax_ele = ele.parent().parent().find(".ajax_loader")

  value =ele.val().trim()
  if value != ""
    $.ajax({
      url: "/users/validate_email"
      data: { 
          'email':value
        }
      beforeSend: -> 
        ajax_ele.show()
        $(".validation_email").html("")
      complete: -> ajax_ele.hide()
      dataType:'script'
      type:'GET'
    });