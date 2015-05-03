$ ->
  if ($("#user_type").notExist())
    return
  $("#user_type").live("change",setUserType);
  setUserType();