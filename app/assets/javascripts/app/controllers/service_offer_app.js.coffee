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


  $scope.add_day = (day) ->   
    if day.can_no_ad_add
      return false

    if $scope.can_add_advertisement day
      $scope.add_advertisement day
    else
      $scope.remove_my_advertisement day
      
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

  $scope.destroy = (service_type) ->
    if service_type.id
      service_type.show = false
      service_type.destroy = 1
    else
      $scope.service_offer.offer_service_types.splice(service_type, 1)  
  
  $scope.get_ads_spots = (day) ->
    (ad for ad in day.ads when !ad.has_ad)

  $scope.get_no_ads_spots = (day) ->
    (ad for ad in day.ads when ad.has_ad)

  $scope.is_new = ->
    $scope.service_offer.id == null

  $scope.can_add_advertisement = (day) ->
    unless $scope.get_my_ad(day)
      $scope.get_no_ads_spots(day).length < 3
    else
      false

  $scope.add_advertisement = (day) ->
    ad_spot = $scope.get_ads_spots(day)[0]
    ad_spot.has_ad = true
    ad_spot.so = $scope.service_offer.id
    day.ad_nro += 1   
    $scope.add_advertisement_entity(day,ad_spot)

  $scope.remove_advertisement_entity = (day,ad_spot) ->
    day_entity = (ad for ad in $scope.service_offer.advertisement.advertisement_days when ad.published_on == day.date)[0]
    if day_entity.advertisement_id
      day_entity.destroy = 1
    else
      $scope.service_offer.advertisement.advertisement_days.splice(day_entity,1)

  $scope.add_advertisement_entity = (day,ad_spot) ->
    $scope.service_offer.advertisement ||= {}
    $scope.service_offer.advertisement.advertisement_days ||= []
    ads_days = 
      "id":null
      "so": $scope.service_offer.id
      "published_on": day.date

    $scope.service_offer.advertisement.advertisement_days.push ads_days
  
  $scope.remove_advertisement = (day) ->
    ad_spot = $scope.get_no_ads_spots(day)[0]
    ad_spot.has_ad = false
    ad_spot.so = null
    day.ad_nro -= 1
    $scope.remove_advertisement_entity(day,ad_spot)
  
  $scope.get_my_ad = (day) ->
    (ad for ad in day.ads when ad.has_ad && (ad.so == null || ad.so == $scope.service_offer.id))[0]

  $scope.remove_my_advertisement = (day) ->
    ad_spot = (ad for ad in day.ads when ad.has_ad && (ad.so == null || ad.so == $scope.service_offer.id))
    if ad_spot.length > 0
      ad= ad_spot[0]
      ad.has_ad = false
      ad.so = null
      day.ad_nro -= 1 
      $scope.remove_advertisement_entity(day,ad)
    


@serviceOfferCtrl.$inject = ['$scope']