
jQuery(document).ready(function(){
  $( "#company_data" ).accordion();
  $(".usr_menu_link").click(changeAccountTabs);
});

function changeAccountTabs(){
  var item = $(this)
  var ul = item.parent();
  ul.find(".usr_menu_selected").each(function(){
    $(this).removeClass("usr_menu_selected");
  });
  item.addClass("usr_menu_selected");
  var a = item.find("a");
  var tabId = parseInt(a.attr("id"));
  $( "#company_data" ).accordion({ active: tabId });
}