var RecaptchaOptions = {
      theme : 'white'
};

var showMenu =false;
var all_company = null;
var change_company = false;

$.fn.exist = function(){
    return jQuery(this).length > 0;
};

$.fn.notExist = function(){
    return jQuery(this).length == 0;
};

jQuery(document).ready( function(){

  $("#msgs .close").click(function(){
    $(this).parent().hide();
  });

  $(".cruz").live("click",function(){
    $(this).parent().parent().hide();
  });

  $(".back").click(function(){
    history.back(-1);
  });

  $("form[data-remote='true']").live('ajax:success',function(){
    if (!$(this).data("no-reset")){
      this.reset();
    }
  });


  $.datepicker.setDefaults( $.datepicker.regional[ "es" ] );

  $(".down_icon").click(function(e){
    $("#home_menu").show();
    $(this).css("background","white");
    e.stopPropagation();
    showMenu = true;
  });

  $("#company_id ").click(function(event){
    $("#all_companies").show();
  });

  $("#all_companies .checkbox").click(function(event){
    change_company=true;
    var all = true;
    $("#all_companies .checkbox").each(function(){
      if (!$(this).attr("checked")){
        all = false;
      }
    });

    $("#all_company_check").attr("checked",all);

    event.stopPropagation();
  });

  $("#all_companies").click(function(event){
    event.stopPropagation();
  });

  $("#all_company_check").click(function(event){
    $("#all_companies :checkbox").attr("checked",$(this).attr("checked"));
    event.stopPropagation();
    change_company=true;
  });

  $(".labelify").labelify({ labelledClass: "labelHighlight" });

  $("[data-remote='true']").live('ajax:before', function(){
    $(this).parent().parent().find(".ajax_loader").show();
  }).live('ajax:complete',function(){
    $(this).parent().parent().find(".ajax_loader").hide();
    $(".labelify").labelify({ labelledClass: "labelHighlight" });
  }).live('ajax:error',function(evt,xhr,status,error){
    var $form = $(this),
          errors,
          errorText;

      try {
        // Populate errorText with the comment errors
        errors = $.parseJSON(xhr.responseText);
      } catch(err) {
        // If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
        errors = {message: "Por favor intente de nuevo y carge la pagina nuevamente"};
      }

      // Build an unordered list from the list of errors
      errorText = "Hubo un error en la aplicaci??n \n<ul>";

      for ( error in errors ) {
        errorText += "<li>" + error + ': ' + errors[error] + "</li> ";
      }

      errorText += "</ul>";

      //Chequero que exista el div para mostrar errores
      if ($("#msgs .alert").size() == 0){
        $("#msgs").html("<div class='alert'></div>")
      }
      $("#msgs .alert").html(errorText);
  });

  all_company = $("#all_companies");

  $(document).bind('click', function(e) {
    if (!$(e.target).hasClass("down_icon")){
      if (showMenu){
        $(".down_icon").css("background","")
        $("#home_menu").hide();
        showMenu = false;
      }
    }


    if ($(e.target).parent().attr("id") != "company_id"){
      if (all_company.is(":visible")){
        if (change_company){
          $("#comp_form").submit();
        }
        all_company.hide();
      }
    }

  });


  $('.brands').live("change",searchModel);
  //$('.company_brand').live("change",searchModelByCompany);
  $('.vehicle_type').live("change",searchBrands);

});

function set_link_to_function(links,func){
  if (links.length > 0){
    links.click(func);
  }
}


function setUserType(){
  if ($("#user_type").val() == 1){
    $("#user_data").show();
    $("#company_data").hide();
    $("#autopartist_data").hide();
    $("tr.close_system").hide().find("input[type=checkbox]").attr("checked",false)
  }else if($("#user_type").val() == 2){
    $("#user_data").hide();
    $("#company_data").show();
    $("#autopartist_data").hide();
    $("tr.close_system").show();
  }else{
    $("#autopartist_data").show();
    $("#user_data").hide();
    $("#company_data").hide();
  }
}

function searchModel(event){
  var brand_id = event.target.id;
  $.ajax({
    url: "/vehicles/find_models",
      data: {
        'id':brand_id,
        'brand_id':$("#"+brand_id).val()
      },
    dataType:'script',
    type:'GET'
  });
}

function searchBrands(event){
  var vehicle_type =$(event.target).val();
  var token = $("input[name='authenticity_token']")[0];
  //AjaxLoader.enable();
  $.ajax({
    url: "/vehicles/find_brands",
      data: {
        'type':vehicle_type
      },
    dataType:'script',
    type:'GET'
  });
}

function searchModelByCompany(event){
  var brand_id = event.target.id;
  var token = $("input[name='authenticity_token']")[0];
  //AjaxLoader.enable();
  $.ajax({
    url: "/vehicles/find_models",
      data: {
        'id':brand_id,
        'brand_id':$("#"+brand_id).val(),
        'authenticity_token':encodeURIComponent(token)
      },
    dataType:'script',
    type:'POST'
  });
}

function showHideContent(link,data){
  $(".contentright_s .data").hide();
  //$("#menu_options .selected").removeClass("selected");
  //link.addClass("selected");

  $(data).show();
  //$("#menu_actions").animate({'left':'210px'});

  //$(".menu_data.showed").hide().removeClass("showed");
  $(data + "_menu").show().addClass("showed");

  //$("#menu_actions").animate({'left':'0px'});
}

function showGRAvatar(){
  window.open("http://www.gravatar.com");
  return false;
}

function beforeSubmit(form){
  $(form).find("input[type=submit]").disable();
}

function afterSubmit(form){
  $(form).find("input[type=submit]").enable();
}

function toggleLogin(){
  $("#login").toggle();
}

var AjaxLoader={};

AjaxLoader={
  disable:function(idElement){
    var defaultId="#ajax_loader";
    if (idElement) {
      defaultId = idElement;
    }

    $(defaultId).hide();
    //$('#vehicle_domains :input').each(function(){
    //  $(this).attr("disabled", "disabled");
    //});
  },
  enable:function(idElement){
    var defaultId="#ajax_loader";
    if (idElement) {
      defaultId = idElement;
    }
    $(defaultId).show();
    //$('#vehicle_domains :input').each(function(){
    //  $(this).attr("disabled", "");
    //});
    //$('#vehicle_domain').val("");
  }
};


function build_amt_graph(data,container) {
   $("#" + container).html("");
   chart = new Highcharts.Chart({
      chart: {
         renderTo: container,
         margin: [50, 10, 0, 0],
         plotBackgroundColor: 'none',
         plotBorderWidth: 0,
         plotShadow: false
      },
      title: {
         text: ''
      },
      tooltip: {
         formatter: function() {
            return this.point.name +': <b> '+ this.y + ' % </b>';
         }
      },
       series: [{
         type: 'pie',
         name: '',
         size: '65%',
         innerSize: '40%',
         data: data,
         dataLabels: {
            enabled: true,
            formatter: function() {
              return '<b>'+ this.point.name +'</b>'+ this.point.p +' ';
            }
         }
      }]
   });
};


function build_price_graph(data,container,title) {
   $("#" + container).html("");
   chart = new Highcharts.Chart({
      chart: {
         renderTo: container,
         margin: [50, 10, 0, 0],
         plotBackgroundColor: 'none',
         plotBorderWidth: 0,
         plotShadow: false
      },
      title: {
         text: ''
      },
      tooltip: {
         formatter: function() {
            return this.point.name +': <b> '+ this.y + ' % </b>';
         }
      },
       series: [{
         type: 'pie',
         name: '',
         size: '65%',
         innerSize: '40%',
         data: data,
         dataLabels: {
            enabled: true,
            formatter: function() {
              return '<b>'+ this.point.name +'</b> $ '+ this.point.p +'';
            }
         }
      }]
   });
};


