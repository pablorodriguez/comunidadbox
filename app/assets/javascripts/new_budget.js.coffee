$ ->
  if $("#new_budget").notExist()
    return
  

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
    else
      $(".validation_email").html("")

  validate_domain = ->
    ele = $(this)
    ajax_ele = ele.parent().parent().find(".ajax_loader")

    value =ele.val().trim()
    if value != ""
      $.ajax({
        url: "/users/validate_domain"
        data: { 
            'domain':value
          }
        beforeSend: -> 
          ajax_ele.show()
          $(".validation_domain").html("")
        complete: -> ajax_ele.hide()
        dataType:'script'
        type:'GET'
      })
    else
      $(".validation_domain").html("")
  
  $("#budget_email").blur(validate_email) 
  $("#budget_domain").blur(validate_domain) 