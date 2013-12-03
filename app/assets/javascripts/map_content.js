function buildControlPanelChart(service_names,data,title){
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
              text: title
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
                        location.href = url + "?st=" + st+"&et=all";
                    }
                }
            }
           }
        },
        series: data,
        colors: [
          '#33CC00', 
          '#FFFF33', 
          '#F70C47', 
        ]
     });
     return chart1;
}