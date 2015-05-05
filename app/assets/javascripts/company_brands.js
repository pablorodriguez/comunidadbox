jQuery(document).ready(function(){
  $('#select_all_models').click(function(){
    $('#models_checkboxs').find(':checkbox').each(function(){

        $(this).prop('checked', true);

    });
  });
})
