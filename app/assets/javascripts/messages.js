var eventDetailDialog;
jQuery(document).ready(function(){

  //if ($("#workorders").length == 0){return;}

  //$("#workorders").delegate(".new_message","click",showMessageDialog);

  $(".other_msg > .info_note").click(function(){    
    $(this).parent().find("a.read").click();    
  });

  eventDetailDialog = $(".new_msg_form2").dialog({
  autoOpen: false ,
    modal: true,
    draggable:false,
    resizable:false,
    position: [500,150],
    width:750,
    title:"Nuevo Mensaje",
    close:function(){},

    open: function(){
      

    },

    buttons: [          
          {
            text:"Listo",
            click:function(){
              $(this).dialog("close");
            }
          }
        ]
  });


});

function mark_as_read(url){
    $.ajax({
      url: url,
      dataType:'script',
      type:'POST'
  });
}

function showMessageDialog(){
  var link = $(this);
  var url = link.data("m");
  var name = link.data("r");
  var form = $(".new_msg_form");
  form.find(".receiver").html(name);
  form.find(".message_form").attr("action",url);
  
  eventDetailDialog.dialog("open");
}