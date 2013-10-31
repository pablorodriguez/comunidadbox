@app.factory 'dataService', ->
	
	if window.shipping
    $scope.data = dataService.data  
  else
    id = new Date().getTime()
    $scope.data = [   
      id: id
      name: "shipping[shipping_items_attributes][#{id}][product]"
      description: ""
      amt: 1
      price: 0
      show: true
    ]
