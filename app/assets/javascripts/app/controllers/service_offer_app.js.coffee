@serviceOfferCtrl = ($scope)->

  $scope.services_types = window.services_types
  
  if window.service_offer
    $scope.service_offer = window.service_offer
  else
    $scope.service_offer =
      percent: 0,
      price: 0,
      final_price: 0
  
    $scope.service_offer.offer_service_types = []
    $scope.service_offer.weeks = window.weeks


      

  $scope.add_service_type = (st) ->    
    offer_service_type =
      id:"",
      service_type_id: st.service_type.id,
      show:true,
      name: st.service_type.name
    
    $scope.service_offer.offer_service_types.push offer_service_type
  
  $scope.update_final_price = ->
    $scope.service_offer.final_price = $scope.service_offer.price * (1-($scope.service_offer.percent / 100))

  $scope.update_percent = ->    
    $scope.service_offer.percent = (($scope.service_offer.price - $scope.service_offer.final_price) / $scope.service_offer.price) * 100

  $scope.destroy = (offer_service_type) ->
    if offer_service_type.id
      offer_service_type.show = false
      offer_service_type.destroy = 1
    else
      $scope.offer_service_types.splice(offer_service_type, 1)  
  
@serviceOfferCtrl.$inject = ['$scope']