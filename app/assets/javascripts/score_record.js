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
    showLinearChart(data["score_records"], chart1);
    showDoughnutChart(data["score_records"], chart2, data["learning_level"]);
    $('#learning_level').text(data["learning_level"]);
    $('#current_level').text(data["current_level"]);
    $('#needed_experience').text(data["needed_experience"]);
    $('.quiz_title').text(data["quiz_category"]);
    $('#score_modal_area').fadeIn('show');
    $('#score_modal').addClass('show');
  })
});