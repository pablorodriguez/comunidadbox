
function show_notes(){
  var parent = $(this).parent().parent().parent();
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

function new_note(){  
  var parent = $(this).parent().parent().parent();
  parent.find(".notes_container").toggle();
}