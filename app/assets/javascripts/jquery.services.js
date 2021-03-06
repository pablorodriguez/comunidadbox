var priceNumberPattern = /[0-9]+\.*[0-9]+$/;
var materialCodePattern = /\[\S*\]/;
var numberPattern = /[0-9]/;
var commentDialog;
var materialDialog;
var comment;
serviceRow=0;
var SERVICE_PROTECTED = ["15","16","2","8","7","5","12"];

jQuery(document).ready( function(){

  if ($("#work_order_form").length == 0){return;};

  $("#work_order_form").delegate(".service_offer_select","change",set_service_offer);

  $(".text_lable").each(function(){
    $(this).disable();
  });

  $('.date').datepicker({
      showOn: 'button',
      buttonImage: '/images/calendar.png',
      buttonImageOnly: true
    });

  $('.date_time').datetimepicker();


  initMaterialItems();
  $("#maxim").click(maxim);
  var url_km = $("#url_update_km").val();
  var url_km_avg = $("#url_update_km_avg").val();

  var domain = $.trim($("#domain").html());
  var param_values ="domain=" + domain;


  $("#service_type_id").change(function(){
    $("#materials_list").html("");
    if ($("#detail").val() != ""){
      autoCompleteMaterial();
    }
  });

  $(".status").change(updateWorkOrderTotalPrice);

  $("#services").delegate(".add_fields","click",add_fields);
  $("#services").delegate(".delete-button",'click',remove_fields);


  $(".new_material").live('click',addEmptyMaterial);
  $("#materials_list table tbody tr").live("click",selectMaterialHandler);
  $("#materials_list table tbody tr").live("dblclick",addMaterialServiceTypeHandler);
  $("#materials_list .checkbox").live("click",checkMaterialHandler);
  $("#wo-actions .add_comment").live("click",showWorkOrderComment);
  $(".service_status .add_comment").live("click",showServiceComment);

  $(".notes_link").click(function(){
    $("#wo_note").slideToggle();
  });

  $(".add_alarm").click(function(){
    $("#wo_alarm").slideToggle();
  });

  $("#material_dialog").click(showMaterialDialog);
  $("#new_service_type").change(addNewServiceType);

  materialDialog = $("#materials").dialog({
    autoOpen: false ,
    modal: true,
    draggable:false,
    resizable:false,
    position: [500,150],
    width:650,
    title: search_material_title,
    close:function(){
      $("#materials_list").html("");
      $("#term").val("");
      $("#material_erros").hide();
      $("#new_material").val("");
      $("#service_type_id").val("");
      $("#detail").val("");
      $("#service_type").val("");
    },
    buttons: [
          {
            text:search_title,
            click:function(){$("#material_form").submit();}
          },
          {
            text: add_material_title,
            click: function() {
              if (($("#service_type").val() == "")
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
            text: done_title,
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
        comment.parent().prev().find(".comment").toggleClass("add_comment edit_comment").attr("title","Agregar Comentario");
      }else{
        comment.parent().prev().find(".comment").toggleClass("edit_comment add_comment").attr("title","Modificar Comentario");
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

    if (e.ctrlKey && e.shiftKey && e.which == 78){
      var ele = $(e.target);
      if (ele.hasClass("material")){
        ele.parent().parent().parent().parent().find("a.new_material").click();
      }
    }
    });

  $("#term").keyup(function(e){
    autoCompleteMaterial();
  });

  $(".material").each(function(){
    initMaterialAutocomplete($(this))
  });

});

function set_service_offer(){
  var ele = $(this);
  var opt = ele.children(':selected');
  var id = opt.val();
  var text = opt.text();
  ele.next().val(id);
  var tr = ele.parent().parent();
  tr.find(".vehicle_service_offer_price").html(text);
  tr.find(".vehicle_service_offer_link").attr("href","/vehicle_service_offers/" + id);
}

function showTask(ele){
  $(ele).parent().parent().parent().parent().parent().parent().find(".task_list").slideToggle();
}

function autoCompleteMaterial(){
  $("#material_erros").hide();
  var detail = $.trim($("#term").val());
  if (detail != ""){
    var action = $("#material_form").attr("action");
    var service_type_id = $("#service_type").val();
    $.ajax({
      url: action,
      data: {
        'service_type':service_type_id,
        'term':detail
      },
      dataType:'script',
      type:'GET'
    });
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


function addEmptyMaterial(){
  var element = $(this);
  var div = $(element).parent().parent().parent().parent().parent().parent().parent().parent();
  div.find("#material_services_link").click();
  var tr = div.find("table tr:last");
  tr.find("td:eq(1)").find("input").focus();
  tr.find("td:eq(2)").find("input").val("1").blur();
  tr.find("td:eq(3)").find("input").val("0.0");
  var ele = tr.find(".material");
  ele.show();
  initMaterialAutocomplete(ele);
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

function remove_fields(){
  var link = $(this);
  var association = link.data("association");
  if (association=="services"){
    //$(link).prev("input[type=hidden]").attr("value", '1');
    var trs = $(link).parent().parent().parent().parent().parent().find("thead tr");
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

function add_fields(){
  var link = $(this);
  var association = link.data("association");
  var content = link.data("content");
  var msg="";
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  if (association =="material_services"){
    var div = $(link).parent().parent();
    div.find('table tbody').append(content.replace(regexp, new_id));
  }else if (association =="services"){
    content = content.replace("task_list_","task_list_" + $("#new_service_type").val());
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

  var serviceTypeId = $("#service_type").val();
  var serviceType = $("#service_type option:selected").text();
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

  var m_input = tr.find(".material");
  m_input.val(material);
  initMaterialAutocomplete(m_input);

  tr.find("td:eq(2) :input").val(1)
  tr.find(".text_lable").each(function(){
    $(this).disable();
  });

  initMaterialItems();
  $("#new_material").val("");
  $("#term").val("")
}

function addNewServiceType(){
  var ele = $(this);
  if (ele.find("option:selected").val() != ""){
    getServiceTypeDiv("#new_service_type").show();
    ele.val("");
  }
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

function getServiceTypeDiv(serviceTypeIdElement,addEmptyMaterial){

  if (addEmptyMaterial == null) addEmptyMaterial = true;

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

  if (serviceTypeDiv == null){
      $("#services_link").click();
      var serviceTypes = $(".service_type");
      serviceTypeDiv = $(serviceTypes[serviceTypes.length-1])
      serviceTypeDiv.find("#serviceType").text(serviceType);
      serviceTypeDiv.find(".service_type_id")[0].value=serviceTypeId;
      if (SERVICE_PROTECTED.indexOf(serviceTypeId) != -1){
        serviceTypeDiv.find("label.warranty").show();
      }

      if (addEmptyMaterial){
        serviceTypeDiv.find("a.new_material").click();
      }
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

    var serviceTypeId = $("#service_type").val();
    var serviceType = $("#service_type option:selected").text();

    var materialServiceTypeId = this.id;
    var material =$.trim(tr0.find("td:eq(1)").html());
    var price = tr0.find("td:eq(2)").asNumber();

    serviceTypeDiv = getServiceTypeDiv("#service_type",false);

    serviceTypeDiv.show();
    var materialButton = serviceTypeDiv.find("#material_services_link");
    materialButton.click();

    var tr = serviceTypeDiv.find("table tr:last");
    tr = $(tr[0]);

    tr.find("td:eq(0) :input").val(materialServiceTypeId);
    var input = tr.find("td:eq(1) .material");
    input.val(material);
    input.prev().show();
    input.next().val(material);
    initMaterialAutocomplete(input);

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
  $("#materials_list").find(":checked").each(function(){
    $(this).attr('checked',false);
  });
}

function showWorkOrderComment(link){
  $(this).parent().parent().parent().parent().parent().parent().parent().find(".comment_div").first().slideToggle();
}

function showServiceComment(link){
  $(this).parent().parent().parent().parent().parent().parent().parent().parent().find(".comment_div").first().slideToggle();
}

function searchServiceTypeMaterial(link){
  materialDialog.dialog("open");
  $("#service_type_id").val($(link).parent().prev().find("input").val());
}

