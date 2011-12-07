var materialDialog;
jQuery(document).ready( function(){

    $("#new_service_type").change(addNewServiceType);
    $("#detail").keyup(function(e){
      autoCompleteMaterial();
    });

    $(".pagination a").live("click",function(){
      $.getScript(this.href);
      return false;
    });

    $("#material_form").bind('ajax:before', function(){
      $(this).find(".ajax_loader").show();
    }).bind('ajax:complete',function(){
      $(this).find(".ajax_loader").hide();
      
    });

    $("#material_dialog").click(showMaterialDialog);
    $("#materials_list table tbody tr").live("click",selectMaterialHandler);
    $("#materials_list table tbody tr").live("dblclick",addMaterialServiceTypeHandler);
    $("#materials_list .checkbox").live("click",checkMaterialHandler);

    $('.brand').change(searchModel);

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
});

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

function searchServiceTypeMaterial(link){
  materialDialog.dialog("open");
  $("#service_type_id").val($(link).parent().prev().find("input").val());
}

function showMaterialDialog(){
  materialDialog.dialog("open");
}

function autoCompleteMaterial(){
  $("#material_erros").hide();
    var detail = $.trim($("#detail").val());
    if (detail != ""){
      //$("#detail").val(detail);
      $("#material_form").submit();
    }
}

function addNewServiceType(){
  getServiceTypeDiv("#new_service_type").show();
  $("#new_service_type").val("");
}

function getServiceTypeDiv(serviceTypeIdElement){

  var serviceTypeId = $(serviceTypeIdElement).val();
  var serviceType = $(serviceTypeIdElement +" option:selected").text();

  var serviceTypeDiv = null;
  $(".service_type_id").each(function(){
      if($(this).val()== serviceTypeId){
        $(this).first().parent().parent().parent().find(".remove_service").children().first().val("false");
        serviceTypeDiv =  $(this).parent().parent().parent().parent().parent().parent().parent();
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

  return serviceTypeDiv;
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
        content = content.replace("task_list_","task_list_" + $("#new_service_type").val());
        $("#services").find("#services_list").append(content.replace(regexp, new_id));
        
    }
    initMaterialItems();
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
    updateBudgetsTotalPrice();
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
    updateBudgetsTotalPrice();

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

function updateBudgetsTotalPrice(){
    var total= 0;
    $(".total_service").each(function(){
        var div = $(this).parent().parent().parent().parent().parent();
        if (div.is(':visible')){
            if (div.find("table tr:first").find("select :selected").text() != "Cancelado") {
                total += $(this).asNumber();
            }
        }

    });
    $("#total_budget").html(total).formatCurrency();
}

function addEmptyMaterial(element){
    var div = $(element).parent().parent().parent().parent().parent().parent();
    div.find("#material_services_link").click();
    var tr = div.find("table tr:last");
    tr.find("td:eq(2)").find("input").val("1");
    tr.find("td:eq(3)").find("input").val("0.0");
    tr.find(".material").show();
}

function add_material_service_type(){
  var checks = $("#materials_list").find("input[type=checkbox]:checked");
  add_materials_service_types(checks);
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
  updateBudgetsTotalPrice();
    
  $("#materials_list").find("input[type=checkbox]:checked").attr('checked',false);

}