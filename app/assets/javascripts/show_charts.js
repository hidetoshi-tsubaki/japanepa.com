{
    // ドーナッツchart用の値を作る
    
    // これをonclickで発動させる
    function showLinearChart(data,chartID,level){
         
        // chartに表示するからのラベルを生成
        var scoreLabels = Array(data.length);
        scoreLabels.fill("");
        var labelArray = scoreLabels;
        var dataArray = data;
        var ctx = document.getElementById(chartID).getContext('2d');
        ctx.canvas.height = 300;
        var myChart = new Chart(ctx, {
            data: {
                labels: labelArray,
            datasets: [{
                data: dataArray,
                type: 'line',
                fill:false,
                lineTension: 0,
                // 点の設定
                pointBackgroundColor: '#fff',
                pointBorderColor: '#fff', //点の周りの色
                pointBorderWidth: 1,  //点の周りの線の大きさ
                pointRadius: 4, //点の大きさ
                borderColor: '#fff',
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
        //ドーナツグラフ
        var ctx2 = document.getElementById(chartID).getContext('2d');
        
        var myChart2 = new Chart(ctx2, {
            //グラフの種類
            type: 'doughnut',
            //データの設定
            data: {
                //データ項目のラベル
                labels: ["",""],
                //データセット
                datasets: [{
                    data: [level,space],
                    //背景色
                    backgroundColor:[
                        "#fff",
                        "#02c8a7",
                    ],
                    borderColor:"#02c8a7"
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