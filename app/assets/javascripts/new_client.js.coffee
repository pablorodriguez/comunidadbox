$ ->
   if $("#clients").notExist()
      return
  
  $("#clients").delegate ".new_message","click",->
    $(this).parent().parent().parent().find(".message").toggle()


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
  
  $("#user_email").blur(validate_email) 