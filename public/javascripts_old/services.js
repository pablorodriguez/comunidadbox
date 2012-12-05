var priceNumberPattern = /[0-9]+\.[0-9]+$/;
var materialCodePattern = /\[\S*\]/;
var numberPattern = /[0-9]/;

jQuery(document).ready( function(){
    $('material_detail_auto_complete').observe('click', updatePrice);
    $('material_detail_auto_complete').observe('keyup', updatePrice);
    $('material_amount').observe('keyup', updateTotalPrice);
    $('material_detail').observe('keyup', updatePrice);	 
    $('material_price').observe('keyup', updateTotalPrice);	
    $('material_service_type_id').observe('change', updateItemServiceMaterial);

    var dates = $( "#service_offer_since, #service_offer_until" ).datepicker({
      defaultDate: -60,
      changeMonth: true,
      numberOfMonths: 3,
      onSelect: function( selectedDate ) {
        var option = this.id == "service_offer_until" ? "minDate" : "maxDate",
          instance = $( this ).data( "datepicker" ),
          date = $.datepicker.parseDate(
            instance.settings.dateFormat ||
            $.datepicker._defaults.dateFormat,
            selectedDate, instance.settings );
        dates.not( this ).datepicker( "option", option, date );
      }
    }); 
});



function updateItemServiceMaterial(event){
  $('material_detail').value = "";
	$('material_row').value = "";
	$('material_amount').value = "";
    updatePrice(event);
}

function updatePrice(event){
	var value = $('material_detail').value;
    var price = value.match(priceNumberPattern);

    if (price) {
		price = price[0];
    }
    else {
		price="";
		if ($('material_row').value != ''){		
			toggleEditMaterialRow($('material_row').value);
			$('material_row').value='';
			$('add_material').value="Agregar Material";
		}
    }
    $('material_price').value = price;
    updateTotalPrice();
}

function updateTotalPrice(event){
    var amount = parseFloat($('material_amount').value);
    var price = parseFloat($('material_price').value.replace("$ ", ""));
    var totalPrice = amount * price;
    if (!isNaN(totalPrice)) {
        $('total_price').update("$ " + totalPrice);
    }
    else {
        $('total_price').update("");
    }
}

function editMaterialRow(row,detail,amount,price,totalPrice,serviceType){
	if ($('material_row').value != ''){		
		toggleEditMaterialRow($('material_row').value);
	}
	
    $('material_row').value = row;
    $('material_detail').value = detail;
    $('material_amount').value = amount;
    $('material_price').value = price;
    $('total_price').update("$ " + totalPrice);
    $('material_service_type_id').value = serviceType;
	$('material_service_type_id').disable()
	$('add_material').value="Actualizar Material";
	toggleEditMaterialRow(row);
}

function toggleEditRow(row_name,row){
	var actualColor = $(row_name + row).getStyle('backgroundColor');
	var newColor ='white';
	if (actualColor != 'rgb(255, 255, 187)')
		newColor = 'rgb(255, 255, 187)';
	
    $(row_name + row).setStyle({
		backgroundColor: newColor
	});
	
}

function toggleEditMaterialRow(row){
	toggleEditRow('material_detail_',row);
}

function toggleEditServiceRow(row){
	toggleEditRow('service_',row);
}

function removeMaterials(){
	var materials = $('materials_table').childElements();
	$('material_service_type_id').enable();
	$('material_service_type_id').selectedIndex=0;
	$('material_row').value="";
	var i=1;
	var m = materials.length;
	while(i < m ){
		materials[i].fade();
		materials[i].remove();
		i++;
	} 	
}


