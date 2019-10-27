$(function (){
  function getLevel(arr) {
    var scoreArray = arr;
    var length = scoreArray.length;
    if (length >= 10) {
      scoreArray.slice(-10);
      var sum = 0;
      for (let i = 0; i < 10; i++) {
        sum += scoreArray[i];
      }
      var level = Math.floor(sum / 10);
    }else if(1 <= length){
      var sum = 0;
      for (let i = 0; i < length; i++) {
        sum += scoreArray[i];
      }
      var level = Math.floor(sum / length);
    }else if(length === 0){
      var level = "-";
    }
    return level;
  }
  $('.chart_button').on('click', function(){
    var id = $(this).attr('id');
    var chart1 = "linearChart";
    var chart2 = "doughnutsChart";
    if (typeof myChart2 != "undefined") {
      myChart2.destroy();
    }
    $.ajax({
      type: 'get',
      url: `/score_records/${id}`,
      dataType: "json"
    }).done(function (data) {
      var score_records = data["score_record"];
      var level = getLevel(score_records);
      showLinearChart(score_records, chart1);
      if (level != 0) {
        $('#learningLevel').text(level);
        showDoughnutChart(score_records, chart2, level);
        $('#current_level').text(data["current_level"]);
        $('#needed_experience').text(data["needed_experience"]);
      } else {
        showDoughnutChart([], chart2, level);
        mychart2.destroy();
        var count = 10 - score_records.length;
        $('#coution').text(`To measure your learinig level,please play ${count} times at least`);
      }
      $('.quiz_title').text(data["quiz_category"]["name"]);
    })
    $('#modalArea').fadeIn('show');
    $('#score_modal').addClass('show');

  })
});