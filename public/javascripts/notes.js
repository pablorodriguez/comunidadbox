jQuery(document).ready(function(){
  
  $(".note_form[data-remote='true']").bind('ajax:success',function(){
    $(this)[0].reset();    
    var link = $(this).parent().parent().parent().parent().parent().find(".notes_link");
    if (link) {
      link.parent().show();
    }
  });

});

function createNewNote_old(){
  $("#new_note_form").slideToggle();
  
}

function show_notes(element){
  var parent = $(element).parent().parent().parent().parent().parent();
  // si el container esta visible
  if (parent.find(".notes_container").is(":visible")){
    // toggle de las notas
    parent.find(".notes").toggle();

    // si el form y notes estan ocultos
    if ((!(parent.find(".new_note_form").is(":visible"))) && 
      (!(parent.find(".notes").is(":visible")))){
      // oculto el notes container
      parent.find(".notes_container").hide();
    }

  }else{
    //el container esta oculto
    parent.find(".notes_container").show();
    parent.find(".notes").show();
  }
}

function new_note(element){  
  var parent = $(element).parent().parent().parent().parent().parent();
  if (parent.find(".notes_container").is(":visible")){
    parent.find(".new_note_form").toggle();

    // si el form y notes estan ocultos
    if ((!(parent.find(".new_note_form").is(":visible"))) && 
      (!(parent.find(".notes").is(":visible")))){
      // oculto el notes container
      parent.find(".notes_container").hide();
    }

  }else{
    parent.find(".notes_container").show();
    parent.find(".new_note_form").show();
  }
  
}