function showLinearChart(data, chartID){
  var scoreLabels = Array(data.length);
  scoreLabels.fill("");
  var labelArray = scoreLabels;
  var dataArray = data;
  var ctx = document.getElementById(chartID).getContext('2d');
  if (myChart) {
    myChart.destroy();
  }

  var myChart = new Chart(ctx, {
    data: {
      labels: labelArray,
    datasets: [{
      data: dataArray,
      type: 'line',
      fill: false,
      lineTension: 0,// 点の設定
      pointBackgroundColor: '#F29073',
      pointBorderColor: '#F29073', //点の周りの色
      pointBorderWidth: 0,//点の周りの線の大きさ
      pointRadius: 2, //点の大きさ
      borderColor: '#F29073',
      borderWidth: 3,
    }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      title:{
        display: true,
        text: "Score Board",
        fontColor: "#808080",
        fontSize: 30
      },
      legend: {
      display: false
      },
      animation: {
        easing: 'linear'
      },
      scales: {
        yAxes: [{
          ticks: {
            fontColor: '#808080',
            beginAtZero: true,
            fontSize: 18,
            fontWeight: 'bold',
            max: 100
          },
          gridLines: {
            color: '#808080',
            borderDash: [5,5], //線の長さ、間隔
            lineWidth: 1,
            zeroLineWidth: 1,
            zeroLineColor: '#808080', //x軸の最初の線
            drawTicks: false
          }
        }],
        xAxes: [{
          ticks: {
            fontColor: '#fff',
            fontSize: 18,
            fontWeight: 'bold',
            zeroLineColor: '#fff'
          },
          gridLines: {
            display: false,
          }
        }],
      }
    }
  });
}
function showDoughnutChart(data, chartID, learning_level){
  var space = 100 - learning_level;
  var ctx2 = document.getElementById(chartID).getContext('2d');
  if (myChart2) {
    myChart2.destroy();
  }
  var myChart2 = new Chart(ctx2,{
    type: 'doughnut',//データの設定
    data: {
      labels: ["",""],//データセット
      datasets: [{
        data: [learning_level, space],
        backgroundColor:[
          "#F29073",
          "#FEF5E1",
        ],
        borderColor: "#F29073"
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      legend: {
        display: false
      },
      title:{
        display:true,
        text: 'Learing Level',
        fontColor: "#808080",
        fontSize: 30
      },
      animation: {
        easing: 'easeOutBounce'
      },
      cutoutPercentage:75,
    }
  });
}