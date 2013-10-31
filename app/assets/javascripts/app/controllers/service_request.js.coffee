@serviceRequestCtrl = ($scope) ->
    
  if window.shipping && window.shipping.items.length > 0
    $scope.items = window.shipping.items
  else    
    $scope.items = [   
      id: ""
      name: "shipping[shipping_items_attributes][0][product]"
      description: ""            
      show: true      
    ]

  $.scope.service_types = windows.service_types  
  $scope.add_item = ->
    prd =
      id: ""
      name: ""      
      show: true
      description:""

    $scope.items.push prd    

  $scope.total_price = ->
    sum = 0
    for product in $scope.data
      if product.show && product.price && !isNaN(product.price)
        if !isNaN(product.amt)
          sum += parseFloat(product.price) * parseFloat(product.amt)
    sum  

  $scope.total_amt = ->
    sum = 0
    for product in $scope.data
      if product.show && product.amt && !isNaN(product.amt) 
        sum += parseFloat(product.amt)
    sum  

  $scope.search = (req,resp)->    
    ele = @element    
    req["authenticity_token"] = encodeURIComponent($("input[name='authenticity_token']").val())
    $.getJSON "/products/details", req, (materials) ->
      data = []
      
      regEx = new RegExp(req.term,"i")

      $.each materials, (i, val) ->
        obj = {}
        obj.product_id = val.id        
        obj.value = val.description
        #obj.label = val.description + " " + val.price_fmt
        new_value = val.description.replace(regEx, "<span>#{req.term}</span>")
        obj.label = "#{new_value} <label> #{val.price_fmt} </label>"          
        obj.price = val.price
        obj.price_fmt = val.price_fmt
        data.push obj

      resp data
      
  $scope.select = (e, ui) ->
    i = parseInt($(e.target).parent().find(".index").text())
    prd = $scope.data[i]
    prd.price = ui.item.price
    prd.price_fmt = ui.item.price_fmt
    prd.detail = ui.item.value
    prd.prd_id = ui.item.product_id
    prd.amt = 1
    $scope.$apply()


  $scope.autoCompleteOption =
    appendTo: "#services_list"
    minLenght: 2
    source: $scope.search
    select: $scope.select

  $scope.destroy = (prd) ->    
    if prd.prd_id
      prd.show = false
      prd.destroy = 1
    else
      $scope.data.splice(prd, 1)
  

app.directive "autocomplete", ->
  link: (scope,ele) ->    
    autoComp = ele.autocomplete(scope.autoCompleteOption)
    autoComp.data( "uiAutocomplete")._renderItem = (ul,item) ->
      return $("<li></li>").data("ui-autocomplete-item", item).append("<a>"+ item.label + "</a>").appendTo(ul)
    
    scope.$watch('data',scope.total_price,true)

@serviceRequestCtrl.$inject = ['$scope'];
