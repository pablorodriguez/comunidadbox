$ ->

  unless $(".car_service_offer").exist()
    return

  $(".new_message").click ->
      $(this).parent().parent().parent().parent().parent().find(".message_container").toggle()