
{
  const scoreRecords = gon.scoreRecords;
  var learningLevel;
  var coution;
  var chart1;
  var chart2;

  function getLevel(arr) {
    if (arr.length >= 10) {
      var scoreArray = arr.slice(-10);
      var scoreLength = scoreArray.length;
      var sum = 0;
      for (var i = 0; i < 10; i++) {
        sum += scoreArray[i];
      }
      var level = Math.floor(sum / scoreLength);
      return level;
    } else {
      return false;
    }
  }

  function getLevelComment(level){
    if (level === 100){
      return "Level: Amazing!Fantastic!Superb! you mastered completely "
    }else if(level > 90){
      return "Oh! Great! we say again this. You are Great!" 
    }else if(level > 60){
      return "Yeah! You're doing GOOD! Keep it up!"
    }else if(level >40){
      return "We know You can do it! Let`s go!"
    }else if(level >= 0){
      return "it`s OK! just started! try it out again!"
    }
  }

  function setChart(arr) {
    var level = getLevel(arr);
    showLinearChart(arr, chart1);
    if (level) {
      learningLevel.textContent = `${level}`;

      showDoughnutChart(arr, chart2, level);
    } else {
      coution.textContent = "To measure your learinig level,please play 10 times at least";
      level.textContent = "Level: unknown"
    }
  }

  function showChart(hash) {
    console.log(hash);
    for (var key in hash) {
      for (var i = 0; i < Object.keys(hash).length; i++) {
        var scoreArr = hash[key][i]['score'];
        console.log(i);
        var quizTitle = hash[key][i]['quizTitle'];
        chart1 = quizTitle + "LinearChart";
        chart2 = quizTitle + "DoughnutsChart";
        var idLearningLevel = quizTitle + "learningLevel";
        var idCoution = quizTitle +"coution";
        learningLevel = document.getElementById(idLearningLevel)
        coution = document.getElementById(idCoution);

        console.log(chart1);
        console.log(scoreArr);
        console.log(quizTitle);
        setChart(scoreArr);

      }
    }
  }
  showChart(scoreRecords);
    
}
