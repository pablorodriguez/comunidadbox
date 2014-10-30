$ ->
  if $("#materials_index").notExist()
    return

  $("a#import_export").click ->
    $("#materials").slideToggle()
    $(".upload_file").slideToggle()

  $("a#material_list").click ->
    $("#materials").slideToggle()
    $(".upload_file").slideToggle()

  show_form = ->
    $(@).parent().parent().parent().hide().next().show()

  hide_form = ->
    $(@).parent().parent().parent().hide().prev().show()

  confirm_form = ->
    $(@).parent().parent().submit()

  $("#materials").delegate(".material_view .edit","click",show_form)
  $("#materials").delegate(".material_form .delete","click",hide_form)
  $("#materials").delegate(".material_form .confirm","click",confirm_form)
