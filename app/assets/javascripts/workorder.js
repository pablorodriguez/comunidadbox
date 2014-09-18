
function changeSort() {
  var order = $("#order_by").find("dt a span.order").html();
  var by = $("#order_by").find("dt a span.value").html();
  submitForm(by,order);
}

function setSort(element){
    var text = element.html();
    $(".dropdown dt a span").html(text);
    $(".dropdown dd ul").hide();
    changeSort();
}


function submitForm(sort_column,direction){
	$("#sort").val(sort_column);
	$("#direction").val(direction);
	$("#filter").submit();
}

function new_message_wo(){  
  $(this).parent().parent().parent().find(".message").toggle();
  return false;
}

function submit_message_form(){
  $(this).submit();
  return false;
}

/**
 * @author Hernan
 */
 var chart;
jQuery(document).ready( function(){

  if ($("#all-workorder").notExist()){return;};

  
  $("#all-workorder").delegate(".new_note_link","click",new_note);
  $("#all-workorder").delegate(".new_message","click",new_message_wo);

    var dates = $( "#date_from, #date_to" ).datepicker({
      defaultDate: -60,      
      changeMonth: true,
      numberOfMonths: 3,
      onSelect: function( selectedDate ) {
        var option = this.id == "date_from" ? "minDate" : "maxDate",
          instance = $( this ).data( "datepicker" ),
          date = $.datepicker.parseDate(
            instance.settings.dateFormat ||
            $.datepicker._defaults.dateFormat,
            selectedDate, instance.settings );
        dates.not( this ).datepicker( "option", option, date );
      }
    });

  $(".new_msg_form[data-remote='true']").bind('ajax:success',function(){
    $(this)[0].reset();
  });

    
  $(".dropdown dt a").live("click",function() {
    $(".dropdown dd ul").toggle();
  });
  
  
  $(".dropdown dd ul li a").live("click",function() {
    setSort($(this));
  }); 
  
  $(document).bind('click', function(e) {
    var $clicked = $(e.target);
    if (! $clicked.parents().hasClass("dropdown"))
        $(".dropdown dd ul").hide();
  });
    
  $(".contentleft input").labelify({ labelledClass: "labelHighlight" });
  $(".labelify").labelify({ labelledClass: "labelHighlight" });  

  $("form1.note_form").bind("ajax:success", function(evt, data, status, xhr){
      var $form = $(this);
      this.reset();
      $form.parent().parent().next().append(xhr.responseText);  
      $form.parent().parent().parent().parent().find(".notes_link").show().parent().show()
      $form.parent().parent().next().find(".note").last().effect("highlight", {color:"#F7DE4F"}, 3000);
    })

  $("#service_done").click(function(){showHideContent($(this),"#workorders_c");});
  $("#report_amount").click(function(){showHideContent($(this),"#price_graph_c");});
  $("#report_quantity").click(function(){showHideContent($(this),"#amt_graph_c");});
  $("#report_material").click(function(){showHideContent($(this),"#amt_material_graph_c");});
  $("#report_detail").click(function(){showHideContent($(this),"#report_data");});

  $("#service_types :checkbox[id!='all_service_type']").change(function(){
    $(this).parent().parent().parent().find(":checkbox[id='all_service_type']").attr("checked",false);
  })

  $("#service_types #all_service_type").change(function(){
    if ($("#all_service_type").attr("checked")){
      $("#service_types :checkbox[id!='all_service_type']").attr("checked",true);  
    }else{
      $("#service_types :checkbox[id!='all_service_type']").attr("checked",false);  
    }
  })

  $(".wo_info_detail").live("click",function(){
      $(this).parent().next().toggle();
    });

  $("#export_price_report").click(function(){exportTableToCSV.apply(this, [$('#price_report table'), 'PriceReport.csv', ["Tipo de Servicio","Importe"]]);});
  $("#export_amount_report").click(function(){exportTableToCSV.apply(this, [$('#amt_report table'), 'AmountReport.csv', ["Tipo de Servicio","Cantidad"]]);});
  $("#export_material_report").click(function(){exportTableToCSV.apply(this, [$('#amt_material_graph table'), 'AmountMaterial.csv', ["Material","Total Facturado","Cantidad","Porcentaje"]]);});
  $("#export_detail_report").click(function(){exportTableToCSV.apply(this, [$('#report_data table'), 'DetailReport.csv', ["Detalle", "Valor"]]);});


  /*
  function export_price_report_to_csv(){
    exportTableToCSV.apply(this, [$('#price_report table'), 'PriceReport.csv']);
  }
  */

  function exportTableToCSV($table, filename, titles) {

    var $rows = $table.find('tr:has(td)'),

      // Temporary delimiter characters unlikely to be typed by keyboard
      // This is to avoid accidentally splitting the actual contents
      tmpColDelim = String.fromCharCode(11), // vertical tab character
      tmpRowDelim = String.fromCharCode(0), // null character

      // actual delimiter characters for CSV format
      colDelim = '","',
      rowDelim = '"\r\n"',

      // Grab text from table into CSV formatted string
      csv = '"';
      
      //agrego los titulos
      for(var index=0; index < titles.length; index++){
        csv += titles[index];
        if(index < (titles.length -1)){
          csv += colDelim;
        }else{
          csv += rowDelim;
        }
      }
      
      csv += $rows.map(function (i, row) {
          var $row = $(row),
              $cols = $row.find('td');

          return $cols.map(function (j, col) {
              var $col = $(col),
                  text = $col.text().trim();

              //verifico si es numero y lo formateo
              var colClasses = $(col).attr('class')
              if(colClasses != undefined && colClasses != null && colClasses.indexOf("number") > -1){
                text = text.replace("$","");
                text = text.replace("%","");

                while(text.match(/,/g) != null && text.match(/,/g).length > 1){text = text.replace(",","");}

                text = text.replace(/\./g, "");
                text = text.replace(",", ".");
                //text = parseFloat(text).toFixed(2).toLocaleString();

              }
              

              return text.replace('"', '""'); // escape double quotes

          }).get().join(tmpColDelim);


      }).get().join(tmpRowDelim)
          .split(tmpRowDelim).join(rowDelim)
          .split(tmpColDelim).join(colDelim) + '"',

    // Data URI
    csvData = 'data:application/csv;charset=utf-8,' + encodeURIComponent(csv);

    $(this)
      .attr({
      'download': filename,
        'href': csvData,
        'target': '_blank'
    });
  }
});
