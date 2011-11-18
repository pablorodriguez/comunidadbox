var priceNumberPattern = /[0-9]+\.*[0-9]+$/;
var materialCodePattern = /\[\S*\]/;
var numberPattern = /[0-9]/;
var commentDialog;
var materialDialog;
var comment;
serviceRow=0;
jQuery(document).ready( function(){

	$(".text_lable").each(function(){
		$(this).disable();
	});

	$('#workorder_performed').datepicker({
      showOn: 'button',
      buttonImage: '/images/calendar.png',
      buttonImageOnly: true
    });

	initMaterialItems();
	$("#maxim").click(maxim);
	var url_km = $("#url_update_km").val();
	var url_km_avg = $("#url_update_km_avg").val();

	var domain = $.trim($("#domain").html());
	var param_values ="domain=" + domain;

	$("#km_actual").editInPlace({
 		url:url_km,
		params:param_values
 	});

	$("#km_avg").editInPlace({
 		url:url_km_avg,
		params:param_values
 	});

	$("#service_type_id").change(function(){
		$("#materials_list").html("");
		if ($("#detail").val() != ""){
		  autoCompleteMaterial();
		}
	});

	$(".status").change(updateWorkOrderTotalPrice);

	$("#materials_list table tbody tr").live("click",selectMaterialHandler);
	$("#materials_list table tbody tr").live("dblclick",addMaterialServiceTypeHandler);
	$("#materials_list .checkbox").live("click",checkMaterialHandler);
	$(".comment").live("click",showModalComment);
	$("#material_dialog").click(showMaterialDialog);
	$("#new_service_type").change(addNewServiceType);

	materialDialog = $("#materials").dialog({
	  autoOpen: false ,
    modal: true,
    draggable:false,
    resizable:false,
    position: [500,150],
    width:650,
    title:"Buscador de Materiales",
    close:function(){
      $("#materials_list").html("");
      $("#material_erros").hide();
      $("#new_material").val("");
      $("#service_type_id").val("");
      $("#detail").val("");
    },
    buttons: [
          {
            text: "Agregar Material",
            click: function() {
              if (($("#service_type_id").val() == "")
                    && ($("#new_material").val() != "")){
                $("#material_erros").show();
              }else{
                add_material_service_type();

                if ($("#new_material").val() != ""){
                  add_new_material_service_type();
                }


                $("#material_erros").hide();
              }
            }
          },
          {
            text:"Listo",
            click:function(){$(this).dialog("close");}
          }
        ]
	});

	commentDialog = $("#comment_modal").dialog({
	  autoOpen: false ,
	  modal: true,
	  draggable:false,
	  resizable:false,
	  title:"Comentario",
	  open: function(event, ui) {
	    $("#comment").val("");
	    $("#comment").val(comment.val());
	  },
	});

	$("#save_comment").click(function(){
		comment.val($("#comment").val());
	    if (comment.val() != ""){
	      comment.parent().prev().toggleClass("add_comment edit_comment").attr("title","Agregar Comentario");
	    }else{
	      comment.parent().prev().toggleClass("edit_comment add_comment").attr("title","Modificar Comentario");
	    }
	    commentDialog.dialog("close");
	});

	$(".pagination a").live("click",function(){
    $.getScript(this.href);
    return false;
  });

  $(document).keypress(function(e) {
    if (e.ctrlKey && e.which == 109){
      showMaterialDialog();
    }
    });

  $("#detail").keyup(function(e){
    autoCompleteMaterial();
  });

});

function autoCompleteMaterial(){
  $("#material_erros").hide();
    var detail = $.trim($("#detail").val());
    if (detail != ""){
      //$("#detail").val(detail);
      $("#material_form").submit();
    }
}

function showMaterialDialog(){
  materialDialog.dialog("open");
}

function checkMaterialHandler(event){
  event.stopPropagation();
}

function addMaterialServiceTypeHandler(){
  addMaterialServiceType($(this));
}

function addMaterialServiceType(element){
 selectMaterial(element);
 var check = element.find(":checkbox");
 add_materials_service_types(check);
}

function selectMaterialHandler(){
  selectMaterial($(this));
}

function selectMaterial(element){
  var check = element.find(":checkbox");
  check.attr('checked', !check.attr('checked'));
}

function update_km_avg(event){
  var url_km = $("#url_update_km").val();
  var domain = $("#domain").html().trim();
  var value = $(this).html().trim();
  url_km = url_km + "?domain=" + domain + "&update_value=" + value;
  $.getScript(url_km);
}


function addEmptyMaterial(element){
	var div = $(element).parent().parent().parent().parent().parent().parent();
	div.find("#material_services_link").click();
	var tr = div.find("table tr:last");
	tr.find("td:eq(2)").find("input").val("1");
	tr.find("td:eq(3)").find("input").val("0.0");
	tr.find(".material").show();
}


function maxim(element){
	if ($("#header").is(":visible")){
		$(element.target).html("Min");
		$("#header").slideUp();
		$("#menu").slideUp();
		$("#wrapmenu").slideUp();
		$("#footer").slideUp('slow',function(){
			$("body").removeClass("background");
		});

		$("#material_per_page").val(15);
	}else{
		$(element.target).html("Max");
		$("#header").slideDown();
		$("#menu").slideDown();
		$("#wrapmenu").slideDown();
		$("#footer").slideDown('slow',function(){
			$("body").addClass("background");
		});

		$("#material_per_page").val(10);
	}
}

function initMaterialItems(){
	$(".amount").blur(updateItemTotalPrice);
	$(".price").blur(updateItemTotalPrice);

}

function updateItemTotalPrice(element){
	var amount=0;
	var price=0;
	var totalLabel ;
	var ele = $(element.target);

	if (ele.hasClass("amount")){
	  if (ele.val().trim() == ""){
	    ele.val("1");
	  }
		amount = ele.asNumber();
		price = ele.parent().next().find("input").val();
		totalLabel = ele.parent().next().next().find(".total_item");
	}else{
	  if (ele.val().trim() == ""){
	    ele.val("0.0");
	  }
		amount = ele.parent().prev().find("input").val();
		price =  ele.val();
		totalLabel = ele.parent().next().find(".total_item");
	}
	var serviceDiv = ele.parent().parent().parent().parent().parent();
	totalLabel.html(amount * price);
	totalLabel.formatCurrency();
	updateTotalService(serviceDiv);
	updateWorkOrderTotalPrice();
}

function updateTotalService(service_element){
	var total= 0;
	var element =$(service_element);
	var st_id = parseInt(element.find(".service_type_id").val());
	var so_id = parseInt($("#st_id_" + st_id).val());
	var cso_id = parseInt($("#cso_ids_" + st_id).val());

	if ((so_id == st_id)){
	 total = $("#so_p_" + st_id).val();
	}else{
  	element.find(".total_item").each(function(){
  		var elem = $(this).parent().parent()[0];
  		if(elem.style.display != 'none'){
  			total += $(this).asNumber();
  		}

  	});
	}
	element.find(".total_service").html(total).formatCurrency();
}

function updateWorkOrderTotalPrice(){
	var total= 0;
	$(".total_service").each(function(){
		var div = $(this).parent().parent().parent().parent().parent();
		if (div.is(':visible')){
			if (div.find("table tr:first").find("select :selected").text() != "Cancelado") {
				total += $(this).asNumber();
			}
		}

	});
	$("#total_work_order").html(total).formatCurrency();
}

function search_sub_category(){
	var category = $('#category_id').val();
	var action =$('#search_sub_category_url').val();
	$.ajax({
		url:action,
		data:{'id':category},
		type:'POST',
		dataType:'script'
	});
}


function task_list(){
	$('#service_type_task').html("");
	var service_type=$('#service_type_id').val();
	var action="/service_types/" + service_type + "/task_list.js";
	var token = $("input[name='authenticity_token']")[0];
	showServiceTypeAjaxLoader();
	jQuery.ajax({
		data:'authenticity_token=' + encodeURIComponent(token),
		dataType:'script',
		type:'get',
		url:action});
}

function showServiceTypeAjaxLoader(element){
	$("#search_task").show();
	$("#st_ajax_loader").show();
}

function hideServiceTypeAjaxLoader(){
	$("#search_task").hide();
	$("#st_ajax_loader").hide();
}

function remove_fields(link,association){
	if (association=="services"){
		//$(link).prev("input[type=hidden]").attr("value", '1');
		var trs = $(link).parent().parent().parent().parent().parent().find("tbody tr");
		trs.each(function(){
		  var tr = $(this);
		  tr.find("a").prev().attr("value", '1');
		  tr.hide();
		});
		$(link).parent().parent().parent().parent().parent().parent().hide();
	}else{
		$(link).prev("input[type=hidden]").attr("value", '1');
		$(link).parent().parent().hide()
	}
	var serviceDiv = $(link).parent().parent().parent().parent().parent();
	updateTotalService(serviceDiv);
	updateWorkOrderTotalPrice();

}

function add_fields(link, association, content){
	var msg="";
	var new_id = new Date().getTime();
	var regexp = new RegExp("new_" + association, "g");
	if (association =="material_services"){
		var div = $(link).parent().parent();
		var lastTr = div.find('table tr:last');
		lastTr.after(content.replace(regexp, new_id));
	}else if (association =="services"){
		$("#services").find("#services_list").append(content.replace(regexp, new_id));
	}
	initMaterialItems();
}

function initMaterialsPagination(){
  $("#materials .pagination a").click(function(){
    $.get(this.href,null,null,"script");
    return false;
  });
};

function add_new_material_service_type(){
  var serviceTypeDiv= null;

  var serviceTypeId = $("#service_type_id").val();
  var serviceType = $("#service_type_id option:selected").text();
  var material =$("#new_material").val();

  $(".service_type_id").each(function(){
    if($(this).val()== serviceTypeId){
      serviceTypeDiv = $(this).parent().parent().parent().parent().parent().parent();
    }
  });

  if (serviceTypeDiv==null){
    $("#services_link").click();
    var serviceTypes = $(".service_type");
    serviceTypeDiv = $(serviceTypes[serviceTypes.length-1])
    serviceTypeDiv.find("#serviceType").text(serviceType);
  }
  serviceTypeDiv.show();
  var table = serviceTypeDiv.find("table");
  table.find("tr a.new_material").click();
  table.find("tr:first").find("td:last").find("input").val("0");
  serviceTypeDiv.find(".service_type_id")[0].value=serviceTypeId;
  var tr = table.find("tr:last");
  tr = $(tr[0]);
  tr.find("td:eq(1) input").val(material);
  tr.find("td:eq(2) :input").val(1)
  tr.find(".text_lable").each(function(){
    $(this).disable();
  });

  initMaterialItems();
}

function addNewServiceType(){
  getServiceTypeDiv("#new_service_type").show();
  $("#new_service_type").val("");
}

function addTaskList(service_type_id){
    $.ajax({
      url: "/workorders/task_list",
      data: {
        'service_type_id':service_type_id
      },
    dataType:'script',
    type:'POST'
  });
}

function add_material_service_type(){
  var checks = $("#materials_list").find("input[type=checkbox]:checked");
  add_materials_service_types(checks);
}

function getServiceTypeDiv(serviceTypeIdElement){

  var serviceTypeId = $(serviceTypeIdElement).val();
  var serviceType = $(serviceTypeIdElement +" option:selected").text();

  var serviceTypeDiv = null;
  $(".service_type_id").each(function(){
      if($(this).val()== serviceTypeId){
        $(this).first().parent().parent().parent().find(".remove_service").children().first().val("false");
        serviceTypeDiv =  $(this).parent().parent().parent().parent().parent().parent();
        if (serviceTypeDiv.is("visible") == false){
          serviceTypeDiv.show();
          serviceTypeDiv.find("table tr:first").show();
        }
      }
    });

  if (serviceTypeDiv==null){
      $("#services_link").click();
      var serviceTypes = $(".service_type");
      serviceTypeDiv = $(serviceTypes[serviceTypes.length-1])
      serviceTypeDiv.find("#serviceType").text(serviceType);
      serviceTypeDiv.find(".service_type_id")[0].value=serviceTypeId;
  }

  addTaskList(serviceTypeId)

  return serviceTypeDiv;
}

function add_materials_service_types(elements){
	var serviceTypeDiv= null;
	elements.each(function(){
		var ele = $(this);
		ele.attr("checked",false)
		var tr0 = ele.parent().parent();

		var serviceTypeId = $("#service_type_id").val();

		var serviceType = $("#service_type_id option:selected").text();
		var materialServiceTypeId = this.id;
		var material =$.trim(tr0.find("td:eq(1)").html());
		var price = tr0.find("td:eq(2)").asNumber();

		serviceTypeDiv = getServiceTypeDiv("#service_type_id");

		serviceTypeDiv.show();
		serviceTypeDiv.find("table thead th:last").find("input").attr("value","0");
		var materialButton = serviceTypeDiv.find("#material_services_link");
		materialButton.click();

		var tr = serviceTypeDiv.find("table tr:last");
		tr = $(tr[0]);

    if (materialServiceTypeId != null){
      tr.find("td:eq(1) :input").hide();
    }


		tr.find("td:eq(0) :input").val(materialServiceTypeId);
		tr.find("td:eq(1)").append("<label>"+ material + "</label>");
		tr.find("td:eq(2) :input").val(1)
		tr3 = tr.find("td:eq(3) :input");
		tr3.val(price);
		//tr3.formatCurrency(tr3);
		//tr3.toNumber();
		var total = tr.find("td:eq(4)").find(".total_item").html(price);
		total.formatCurrency(total);
		tr.find(".text_lable").each(function(){
			$(this).disable();
		});

	});
	initMaterialItems();
	updateTotalService(serviceTypeDiv);
	updateWorkOrderTotalPrice();
	$("#materials_list").find("input[type=checkbox][checked]").each(function(){
		$(this).attr('checked',false);
	});
}

function showModalComment(link){
	comment = $(this).next().children().first();
	commentDialog.dialog("open");
}

function searchServiceTypeMaterial(link){
  materialDialog.dialog("open");
  $("#service_type_id").val($(link).parent().prev().find("input").val());
}

