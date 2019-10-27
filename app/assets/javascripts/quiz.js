'use strict';
{
  const chart1 = "linearChart";
  const chart2 = "doughnutsChart";
  const quizSet = gon.quizSet;
  const totalQuizNum = Object.keys(quizSet).length;
  var currentNum = 0;
  var isAnswered;
  var score = 0;
  var correct_ids = []
  var mistake_ids = []
  var correct_answer_ids = []
  
  question.textContent = quizSet[currentNum].question;

  function shuffle(arr) {
    for (var i = arr.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [arr[j], arr[i]] = [arr[i], arr[j]];
    }
    return arr;
  }

  function checkAnswer(li) {
    if (isAnswered) {
      return;
    }
    isAnswered = true;
    if ($(li).text() === quizSet[currentNum].choices[0]) {
      $(li).addClass('correct');
      correct_ids.push(quizSet[currentNum].id)
      score++;
    } else {
      mistake_ids.push(quizSet[currentNum].id)
      $(li).addClass('wrong');
    }
    $('#quiz_btn').removeClass('disabled');
  }

  function setQuiz() {
    isAnswered = false;
    $('#quizCount').text(`${currentNum+1} / ${totalQuizNum}`);
    $('#question').html(quizSet[currentNum].question);
    $('#choices').empty();
    const shuffledChoices = shuffle([...quizSet[currentNum].choices]);
    shuffledChoices.forEach(function(value, index) {
      $('#choices').append(`<li id='choice_${index+1}'></li>`);
      $(`#choice_${index+1}`).text(value);
      $(`#choice_${index+1}`).on('click', function () {
        checkAnswer(this);
      });
    //最後の問題だった場合の設定
      if (currentNum === quizSet.length - 1) {
        $('#quiz_btn').text('Show Score');
      }
    })
  }

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
    } else if (1 <= length) {
      var sum = 0;
      for (let i = 0; i < length; i++) {
        sum += scoreArray[i];
      }
      var level = Math.floor(sum / length);
    } else if (length === 0) {
      var level = "-";
    }
    return level;
  }

  $('#replay_btn').on('click', function () {
    $('#modalArea').fadeOut();
    $('#linearChart, #doughnutsChart, #learningLevel').empty();
    currentNum = 0;
    score = 0;
    mistake_ids = [];
    setQuiz();
  });
  setQuiz();

  $('#quiz_btn').on('click', function () {
    if ($('#quiz_btn').hasClass('disabled')) {
        return;
    }
    $('#quiz_btn').addClass('disabled');
    if (currentNum === quizSet.length - 1) {
      score = Math.floor(score / quizSet.length * 100)
    $.ajax({
      type: 'post',
      url: '/score_records/',
      data: {
        score_record:{
          score: score,
          title_id: gon.title_id,
          mistake_ids: mistake_ids,
          correct_ids: correct_ids
        },
      },
      dataType: 'json'
      }).done(function(data){
        var score_records = data["score_record"];
        var level = getLevel(score_records);
        showLinearChart(score_records,chart1);
        $('#learningLevel').text(level);
        showDoughnutChart(data["score_record"],chart2,level);
        $('#current_level').text(data["current_level"]);
        $('#got_experience').text(data["new_experience"]);
        $('#needed_experience').text(data["needed_experience"]);
      }).fail(function(){
        alert('score was not saved ......');
      })
      $('#scoreLabel').text(`Score:  ${score} `);
      $('#modalArea').fadeIn('show');
      $('#score_modal').addClass('show');
      $('#replay_btn').on('click', function () {
      })
    } else {
      currentNum++;
      setQuiz();
    }
  })
}