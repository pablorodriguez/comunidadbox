$ ->
  window.templates = {}

  searchTemplate = ->
    serviceTypeId = parseInt($(@).val())
    $.ajax({
      url:"/service_type_templates.json",
      data:{'id':serviceTypeId},
      type:'GET',
      dataType:'json',
      success: (data)->
          window.templates[serviceTypeId] = data
          populateTemplateCombo(data,serviceTypeId)
    })

  populateTemplateCombo = (templates,serviceTypeId) ->    
    combo = $(".service_type_id[value=#{serviceTypeId}]").parent().parent().find(".template")
    if templates.length > 0
      combo.show()
      combo.empty().append('<option selected="selected" value="">-- Template --</option>')
      for temp in templates
        combo[0].options[combo[0].options.length] = new Option(temp.name,temp.id)
    else
      combo.hide()

  populateMaterialRow = (row,material) ->    
    row.find("input:text.amount").val(material.amount)
    row.find("input:hidden.material_service_type_id").val(material.material_service_type_id)
    row.find("input:text.copy_detail").val(material.material)
    row.find("input:text.material").val(material.material).blur()    
    row.find("input:text.price").val(material.price).focus()

  getEmptyRow = (st_table) ->
    empty_material = st_table.find('tbody tr input:text.material[value=""]').parent().parent().first()
    unless empty_material.exist()
      st_table.find("a.new_material").click()
      empty_material = st_table.find('tbody tr input:text.material[value=""]').parent().parent()

    empty_material

  populateServices = (template) ->
    st_table = getServiceType(template.service_type_id)
    for material in template.materials
      emptyRow = getEmptyRow(st_table)
      populateMaterialRow(emptyRow,material)

  getServiceType = (service_type_id) ->    
    $("#services_list table .service_type_id[value='#{service_type_id}']").parent().parent().parent().parent().parent()

  applayTemplate = ->
    templateId = parseInt($(@).val())
    serviceTypeId = $(@).parent().parent().find(".service_type_id").val()
    if templateId != ""
      template
      for temp in window.templates[serviceTypeId]
        if templateId == temp.id
          template = temp
      populateServices(template)
      $(@).val("")

  $("#new_service_type").change(searchTemplate)
  $(".template").live("change",applayTemplate)