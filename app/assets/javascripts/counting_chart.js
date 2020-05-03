$(function () {
  function showCountingChart(data, chartID, max_count, color) {
    // 最新の数値を表示
    var last_data = data[data.length-1];
    var show_last_data_target = ".last_" + chartID + "_count"
    $(show_last_data_target).text(last_data);
    // chartに表示する空のラベルを生成
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
          pointBackgroundColor: color,
          pointBorderColor: color, //点の周りの色
          pointBorderWidth: 0,//点の周りの線の大きさ
          pointRadius: 1, //点の大きさ
          borderColor: color,
          borderWidth: 3,
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        title: {
          display: true,
          text: chartID,
          fontColor: color,
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
              fontColor: '#ccc',
              beginAtZero: true,
              fontSize: 18,
              fontWeight: 'bold',
              max: max_count
            },
            gridLines: {
              color: '#ccc',
              borderDash: [5, 5], //線の長さ、間隔
              lineWidth: 1,
              zeroLineWidth: 1,
              zeroLineColor: '#ccc', //x軸の最初の線
              drawTicks: false
            }
          }],
          xAxes: [{
            ticks: {
              fontColor: '#ccc',
              fontSize: 18,
              fontWeight: 'bold',
              zeroLineColor: "#ccc"
            },
            gridLines: {
              display: false,
            }
          }],
        }
      }
    });
  }
  showCountingChart(gon.users_counting, 'users', 100, "#F39653");
  showCountingChart(gon.quiz_play_counting, 'quiz_play', 100, "#F2928D");
  showCountingChart(gon.article_views_counting, 'article_views', 100, "#75C2F8");
  showCountingChart(gon.communities_counting, 'communities', 100, "#F8C677");
  showCountingChart(gon.talks_counting, 'talks', 100, "#7FC24E");
});