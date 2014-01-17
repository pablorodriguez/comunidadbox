$ ->
  if ($("#user_type").notExist())
    return
  $("#user_type").live("click",setUserType);
  setUserType();