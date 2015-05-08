@serviceRequestCtrl = ($scope)->

    $scope.services_types = window.services_types
    $scope.cars = window.cars
    $scope.service_request = window.service_request
    if window.service_request_edit
      for item in $scope.service_request.item_service_requests
        for st in $scope.services_types
          if item.service_type.id == st.id
            item.service_type = st        
    else
      $scope.service_request.item_service_requests = [   
        id: ""
        name: "shipping[shipping_items_attributes][0][product]"
        description: ""      
        show: true      
      ]


    $scope.add_item = ->
      prd =
        id: ""
        name: ""      
        show: true
        description:""

      $scope.service_request.item_service_requests.push prd    

    $scope.destroy = (item_service_requests,index) ->
      if item_service_requests.id
        item_service_requests.show = false
        item_service_requests.destroy = 1
      else
        $scope.service_request.item_service_requests.splice(index, 1)
    
@serviceRequestCtrl.$inject = ['$scope']