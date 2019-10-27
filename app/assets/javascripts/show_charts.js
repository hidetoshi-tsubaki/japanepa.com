{
  function showLinearChart(data,chartID){
    // chartに表示するからのラベルを生成
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
        fill:false,
        lineTension: 0,// 点の設定
        pointBackgroundColor: '#59D3EB',
        pointBorderColor: '#59D3EB', //点の周りの色
        pointBorderWidth: 0,//点の周りの線の大きさ
        pointRadius: 3, //点の大きさ
        borderColor: '#59D3EB',
        borderWidth: 3,
      }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        title:{
          display:true,
          text:"Score Board",
          fontColor:"#fff",
          fontSize:30
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
            fontColor: '#fff',
            beginAtZero:true,
            fontSize: 18,
            fontWeight: 'bold',
            max: 100
          },
          gridLines: {
            color:'rgb(255,255,255,0.5)',
            borderDash: [5,5], //線の長さ、間隔
            lineWidth: 1,
            zeroLineWidth: 1,
            zeroLineColor: 'rgb(255,255,255,0.5)', //x軸の最初の線
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
  function showDoughnutChart(data,chartID,level){
    var space = 100 - level;
    var ctx2 = document.getElementById(chartID).getContext('2d');
    if (myChart2) {
      myChart2.destroy();
    }
    var myChart2 = new Chart(ctx2,{
      type: 'doughnut',//データの設定
      data: {
        labels: ["",""],//データセット
        datasets: [{
          data: [level,space],
          backgroundColor:[
            "#02c8a7",
            "#303E58",
          ],
          borderColor:"#303E58"
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
        fontColor: "#fff",
        fontSize: 30
        },
        animation: {
          easing: 'easeOutBounce'
        },
        cutoutPercentage:75,
      }
    });
  }
}