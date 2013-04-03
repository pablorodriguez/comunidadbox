$ ->

  if ($("#task_form").notExist())
    return

  $("#service_type_tasks").change ->
      $(this).parent().submit()