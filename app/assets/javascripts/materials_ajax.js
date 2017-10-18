function initMaterialAutocomplete(material_input){
  var autoOpts ={
    appendTo: "#services_list",
    source: searchMaterialAjax,
    close: function(e,ui){
      var ele = $(this);
      ele.prev().prev().hide();
    },
    search:function(){
      var ele = $(this);
      ele.parent().prev().find("input").val("");
      ele.prev().prev().show();
      ele.prev().hide();
    },
    open:function(){
      var ele = $(this);
      ele.prev().prev().hide();
      ele.prev().hide();
    },
    select:function(e,ui){
      var ele = $(this);

      ele.val(ui.item.value);
      ele.next().val(ui.item.value);
      ele.parent().parent().find(".material_service_type_id").val(ui.item.code);
      ele.parent().next().next().find(".price").val(ui.item.price).blur();
      ele.parent().next().find("input").focus(function(){
        this.select();
      }).focus();
    }
  };

  var autoComp= material_input.autocomplete(autoOpts).data("autocomplete");
  autoComp._renderItem=function(ul,item){
    return $("<li></li>").data("item.autocomplete", item).append("<a>"+ item.label + (item.protected ? "(P)":"") + "</a>").appendTo(ul);
  };

  autoComp._renderMenu=function( ul, items ) {
    var self = this;
    $.each( items, function( index, item ) {
        self._renderItem( ul, item );
    });
    $("<li></li>").append("").appendTo(ul);
  };

  material_input.blur(checkDetails);

}

function checkDetails(){
  var ele = $(this);
  if ((ele.val().trim() != "") && (ele.val() == ele.next().val())) {
    ele.prev().show();
    ele.prev().prev().show();
  }else{
    ele.prev().hide();
    ele.prev().prev().hide();
  }
}

function searchMaterialAjax(req,resp){
  var ele = this.element;
  var st = ele.parent().parent().parent().prev().find(".service_type_id").val();
  req["service_type"] = st;
  req["authenticity_token"] = encodeURIComponent($("input[name='authenticity_token']").val());

  $.getJSON("/materials/details",req,function(materials){
    var data = [];
    var regEx = new RegExp(req.term.toUpperCase(),"i");
    $.each(materials,function(i,val){
        var obj = {};
        obj.protected = val.material_detail.protected;
        obj.code = val.material_detail.material_service_type_id;
        obj.value = val.material_detail.detail;
        obj.label = val.material_detail.detail.replace(regEx,"<span>" + req.term.toUpperCase() + "</span>") + "<label id='pr'>" + val.material_detail.price_fmt + "</label>";
        obj.price = val.material_detail.price;
        data.push(obj);
    });
    if (data.length == 0){
      ele.prev().prev().hide().prev().hide();
    }
    resp(data);
  })
}