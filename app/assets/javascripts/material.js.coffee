$ ->
  if $("#material_show").notExist()
    return

  $(".service_type_id").live "change", ->
    $(@).parent().submit()