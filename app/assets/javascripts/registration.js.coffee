$ ->
  if ($(".generate_email").notExist())
    return

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
          $(".validation_vehicle_domain").html("")
        complete: -> ajax_ele.hide()
        dataType:'script'
        type:'GET'
      });

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

  generate_email = ->
    ele = $(this)
    ajax_ele = ele.parent().parent().find(".ajax_loader")
    $.ajax({
      url: "/users/generate_email"
      beforeSend: ->
        ajax_ele.show()
        $(".validation_email").html("").fadeOut()
      complete: -> ajax_ele.hide()
      dataType:'script'
      type:'GET'
    });

  $("#user_email").blur(validate_email)
  $(".user_domain").blur(validate_domain)
  $(".generate_email").click(generate_email)
  
  $(".vehicle_type").on("change",->
    $(".chassis_row").toggle()
    $('select.fuel option:eq(1)').prop('selected', true)
    select = $('select.fuel')
    select.attr('disabled', !select.attr('disabled'));
  
    $(this).toggle (->
      $(".user_domain").attr("placeholder","999XXX")
    ), ->
      $(".user_domain").attr("placeholder","XXX999")

  )

