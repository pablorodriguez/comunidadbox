$ ->
  if ($(".vehicle_type").notExist())
    return

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