$ ->

  unless $(".all_models").exist()
    return

  $(".search_model").click ->
      $(this).parent().parent().parent().parent().parent().submit()
