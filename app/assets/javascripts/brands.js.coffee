$ ->

  unless $(".all_brands").exist()
    return

  $(".search_brand").click ->
      $(this).parent().parent().parent().parent().parent().submit()