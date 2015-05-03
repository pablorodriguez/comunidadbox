$ ->
  if ($(".vehicle_type").notExist())
    return

  $(".vehicle_type").on("change",->
    $(".chassis_row").toggle()
    $('select.fuel option:eq(0)').prop('selected', true)
    select = $('select.fuel')
    select.attr('disabled', !select.attr('disabled'));
    domain = $(".user_domain")
    if ($(this).val() == "Car")
      $(".user_domain").attr("placeholder","XXX999")
    else
      $(".user_domain").attr("placeholder","999XXX")

  )