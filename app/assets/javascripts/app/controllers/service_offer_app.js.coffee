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

  $scope.destroy = (service_type,index) ->
    if service_type.id
      service_type.show = false
      service_type.destroy = 1
    else
      $scope.service_offer.offer_service_types.splice(index,1)
  
  $scope.get_ads_spots = (day) ->
    (ad for ad in day.ads when (!ad.has_ad && !ad.other_ad))

  $scope.get_no_ads_spots = (day) ->
    (ad for ad in day.ads when ad.has_ad)

  $scope.is_new = ->
    $scope.service_offer.id == null

  $scope.can_add_advertisement = (day) ->
    if $scope.get_my_ad day
      return false

    if ($scope.get_no_ads_spots(day).length < 3)
      true 
    else
      false
    
  $scope.add_advertisement = (day) ->
    ad_spot = $scope.get_ads_spots(day)[0]
    ad_spot.has_ad = true
    ad_spot.my_ad = true
    ad_spot.so = $scope.service_offer.id
    day.ad_nro += 1

    day_entity = ad_day for ad_day in $scope.service_offer.advertisement.advertisement_days when ad_day.published_on == day.date
    if day_entity
      day_entity.destroy = ""
    else
      $scope.add_advertisement_entity(day,ad_spot)

  $scope.remove_advertisement_entity = (day,ad) ->    
    day_entity = ad_day for ad_day in $scope.service_offer.advertisement.advertisement_days when ad_day.published_on == day.date
    if ad.advertisement_id
      day_entity.destroy = 1
    else      
      $scope.service_offer.advertisement.advertisement_days = $scope.service_offer.advertisement.advertisement_days.filter (x) ->
        x.published_on != day.date

  $scope.add_advertisement_entity = (day) ->
    $scope.service_offer.advertisement ||= {}
    $scope.service_offer.advertisement.advertisement_days ||= []
    day_ad = 
      "id":null
      "so": $scope.service_offer.id
      "published_on": day.date

    $scope.service_offer.advertisement.advertisement_days.push day_ad
  
  $scope.remove_advertisement_old = (day) ->
    ad_spot = $scope.get_my_ad(day)[0]
    ad_spot.has_ad = false
    ad_spot.so = null
    day.ad_nro -= 1
    $scope.remove_advertisement_entity(day,ad_spot)
  
  $scope.get_my_ad = (day) ->
    (ad for ad in day.ads when ad.my_ad && (ad.so == null || ad.so == $scope.service_offer.id))[0]

  $scope.remove_my_advertisement = (day) ->
    ad = $scope.get_my_ad(day)
    if ad      
      $scope.remove_advertisement_entity(day,ad)
      ad.has_ad = false
      ad.so = null
      ad.my_ad = false
      day.ad_nro -= 1 
    


@serviceOfferCtrl.$inject = ['$scope']