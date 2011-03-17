var chart;
$(document).ready(function() {
   chart = new Highcharts.Chart({
      chart: {
         renderTo: 'graph_container',
         defaultSeriesType: 'bar'
      },
      title: {
         text: ''
      },
      xAxis: {
         categories: ['Cambio de Aceite', 'Mantenimiento General', 'Alineación y Balanceo', 'Amortiguación', 'Tren Delantero']
      },
      yAxis: {
         min: 0,
         title: {
            text: 'Cantidad de Eventos Futuros'
         }
      },
      legend: {         
         backgroundColor: '#FFFFFF',
         reversed: true
      },
      tooltip: {
         formatter: function() {
            return ''+
                this.series.name +': '+ this.y +'';
         }
      },
      plotOptions: {
         series: {
            stacking: 'normal'
         }
      },
           series: [{
         name: '> 2 Meses',
         data: [5, 3, 4, 7, 2]
      }, {
         name: ' 1 < Meses < 2',
         data: [2, 2, 3, 2, 1]
      }, {
         name: 'Meses < 1',
         data: [3, 4, 4, 2, 5]
      }]
   });
   
});
   