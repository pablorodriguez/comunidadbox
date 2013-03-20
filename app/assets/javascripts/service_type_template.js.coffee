$ ->
  unless $("#service_type_templates").exist()
      return

  add_fields = ->    
    content = $(@).data("content")     
    $("#materials table").append(content) 
    ele = $("#materials table tr:last").find("input.material")
    initMaterialAutocomplete(ele)

  searchMaterialAjax = (req,resp) ->
    ele = this.element
    st = $("#service_type_template_service_type_id").val()
    req["service_type"] = st
    req["authenticity_token"] = encodeURIComponent($("input[name='authenticity_token']").val())

    $.getJSON("/materials/details",req,(materials)->
      data = [];
      regEx = new RegExp(req.term.toUpperCase(),"i");
      for material in materials
        obj = {}
        obj.code = material.material_detail.material_service_type_id
        obj.value = material.material_detail.detail
        obj.label = material.material_detail.detail.replace(regEx,"<span>" + req.term.toUpperCase() + "</span>") + "<label id='pr'>" + material.material_detail.price_fmt + "</label>"
        obj.price = material.material_detail.price
        data.push(obj)
        
      
      if (data.length == 0)
        ele.prev().prev().hide().prev().hide()
      
      resp(data);    
    )


  initMaterialAutocomplete = (material_input) ->
    autoOpts = {
      appendTo: "#materials",  
      source: searchMaterialAjax,
      close: (e,ui)->
        ele = $(this)
        ele.prev().prev().hide()
      
      search: ->
        ele = $(this)
        ele.parent().parent().parent().find(".service_type_id").val("")
        ele.parent().parent().parent().find(".code").hide()
      
      open: ->
        ele = $(this)
        ele.prev().prev().hide()
        ele.prev().hide()
      
      select:(e,ui)->
        ele = $(this);
        ele.val($.trim(ui.item.value))
        ele.parent().next().val($.trim(ui.item.value))
        ele.next().val($.trim(ui.item.value))

        row = ele.parent().parent().parent()
        row.find(".service_type_id").val(ui.item.code)
        row.find(".amount").focus()
        row.find(".code").show()      
    }

    autoComp= material_input.autocomplete(autoOpts).data("autocomplete")
    autoComp._renderItem= (ul,item)->
      return $("<li></li>").data("item.autocomplete", item).append("<a>"+ item.label + "</a>").appendTo(ul)    

    autoComp._renderMenu=(ul,items)->
      self = this;
      for item in items
        self._renderItem(ul,item)
      
      $("<li></li>").append("").appendTo(ul)

    material_input.blur(checkDetails)

  checkDetails = ->
    ele = $(this)
    if ((ele.val().trim() != "") && (ele.val() == ele.next().val()))
      ele.prev().show()
    else
      ele.prev().hide()    

  checkMaterial = ->
      ele = $(@)
      if (ele.parent().next().val() != ele.val())
        row = ele.parent().parent().parent()
        row.find(".code").hide()
        row.find(".service_type_id").val("")

  remove_fields = ->
    link = $(@)
    row = link.parent().parent()
    row.find("input.delete_input").val("1")
    row.hide()

  for material in $(".material")
    initMaterialAutocomplete $(material)

  $(".new").click ->
    $("#material_service_type_templates_link").click()    

  $(".add_fields").click(add_fields)
  $("#materials").delegate(".material","blur",checkMaterial)
  $("#materials").delegate("a.delete","click",remove_fields)