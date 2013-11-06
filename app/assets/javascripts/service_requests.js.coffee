$ ->

  if ($("#service_offer").notExist())
    return

  $("a#make_an_offer").click ->
      $("#service_offer_form").slideToggle()