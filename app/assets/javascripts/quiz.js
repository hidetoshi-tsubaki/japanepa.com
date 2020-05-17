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
      $(li).addClass('correct_answer');
      $('#correct_circle').removeClass('hidden');
      correct_ids.push(quizSet[currentNum].id)
      score++;
    } else {
      $(li).addClass('wrong_answer');
      $(`li:contains(${quizSet[currentNum].choices[0]})`).addClass('correct_answer');
      $('#wrong_cross').removeClass('hidden');
      mistake_ids.push(quizSet[currentNum].id)
    }
    $('#quiz_btn').removeClass('disabled');
  }

  function setQuiz() {
    isAnswered = false;
    $('#quiz_count').text(`${currentNum+1} / ${totalQuizNum}`);
    $('#question').html(quizSet[currentNum].question);
    $('#choices').empty();
    const shuffledChoices = shuffle([...quizSet[currentNum].choices]);
    shuffledChoices.forEach(function(value, index) {
      $('#choices').append(`<li id='choice_${index+1}'><p></p></li>`);
      $(`#choice_${index+1} p`).text(value);
      $(`#choice_${index+1}`).on('click', function () {
        checkAnswer(this);
      });
      if (currentNum === quizSet.length - 1) {
        $('#quiz_btn').text('Show Score');
      }
    })
  }

  $('#replay_btn').on('click', function () {
    $('#modalArea').fadeOut();
    $('#linearChart, #doughnutsChart, #learningLevel').empty();
    currentNum = 0;
    score = 0;
    correct_ids = [];
    mistake_ids = [];
    shuffle(quizSet);
    setQuiz();
  });

  shuffle(quizSet);
  setQuiz();

  $('#quiz_btn').on('click', function () {
    $('#correct_circle, #wrong_cross').addClass('hidden');
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
        showLinearChart(data["score_records"], chart1);
        showDoughnutChart(data["score_records"], chart2, data["learning_level"]);
        $('#learning_level').text(data["learning_level"]);
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