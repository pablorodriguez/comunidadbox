function buildControlPanelChart(service_names,data){
     chart1 = new Highcharts.Chart({
        chart: {
           renderTo: 'graph_container',
           defaultSeriesType: 'bar',
           height:600,
        },
        title: {
           text: ''
        },
        xAxis: {
           categories: service_names
        },
        yAxis: {
           min: 0,
           title: {
              text: 'Cantidad de Eventos Futuros'
           }
        },
        legend: {         
           backgroundColor: '#F2F2F2',
           reversed: true
        },
        tooltip: {
           formatter: function() {
              return ''+
                  this.series.name +': <b>'+ this.y +'</b>';
           }
        },
        plotOptions: {
           series: {
              cursor: 'pointer',
              stacking: 'normal',
              pointWidth:30,              
              point: {
                events: {
                    click: function() {               
                        var st = this.options.st;         
                        location.href = url + "?st=" + st;
                    }
                }
            }
           }
        },
        series: data,
        colors: [
          '#62F76F', 
          '#FEFF8F', 
          '#FF795F', 
        ]
     });
     return chart;
}