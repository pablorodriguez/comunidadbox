// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var RecaptchaOptions = {
      theme : 'white'
};
var showMenu =false;
jQuery(document).ready( function(){  

  $.datepicker.setDefaults( $.datepicker.regional[ "es" ] );
  
  $(".down_icon").click(function(){
    $("#home_menu").show();
    $(this).css("background","white");
    showMenu = true;
  });


  $(".labelify").labelify({ labelledClass: "labelHighlight" });

  $(".vertical_menu [data-remote='true']").bind('ajax:before', function(){
    $(this).parent().next().show();
  }).bind('ajax:complete',function(){
    $(this).parent().next().hide();
    $(".labelify").labelify({ labelledClass: "labelHighlight" });
  });

  $(document).bind('click', function(e) {
    if (!$(e.target).parent().hasClass("down_icon")){      
      if (showMenu){
        $(".down_icon").css("background","")
        $("#home_menu").hide();  
        showMenu = false;
      }
    }
  });

  $('.brand').live("change",searchModel);
  $("#user_type").live("click",setUserType);
  		
});

function setUserType(){
  if ($("#user_type").val() == "u"){
    $("#user_data").show();
    $("#company_data").hide();
  }else{
    $("#user_data").hide();
    $("#company_data").show();
  }
}

function searchModel(event){
  var brand_id = event.target.id; 
  var token = $("input[name='authenticity_token']")[0];
  //AjaxLoader.enable();
  $.ajax({
    url: "/cars/find_models",
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

function resetStatusMessages(){
  //$("#msgs").fadeOut();
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
		//$('#car_domains :input').each(function(){
		//	$(this).attr("disabled", "disabled");
		//});		
	},
	enable:function(idElement){
		var defaultId="#ajax_loader";
		if (idElement) {
			defaultId = idElement;
		}
		$(defaultId).show();
		//$('#car_domains :input').each(function(){
		//	$(this).attr("disabled", "");
		//});
		//$('#car_domain').val("");
	}
};


function build_amt_graph(data,container,title) {
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
         text: title
      },
      tooltip: {
         formatter: function() {
            return this.point.name +': <b> '+ this.y + '</b>';
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
              return '<b>'+ this.point.name +'</b>'+ this.point.p +' %';
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
            return this.point.name +': <b>$ '+ this.y + '</b>';
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
              return '<b>'+ this.point.name +'</b>'+ this.point.p +' %';
            }
         }
      }]
   });
};


