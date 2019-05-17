'use strict';

{
    // 要素取得
    const question = document.getElementById('question');
    const btn = document.getElementById('btn');
    const choices = document.getElementById('choices');
    const window = document.getElementById('window');
    const learningLevel = document.getElementById('learningLevel');
    const coution = document.getElementById('coution');
    const quizCount = document.getElementById('quizCount');
    const chart1 = "linearChart";
    const chart2 = "doughnutsChart";

   
    // css記述で指定より複雑な指定ができる
    // const scoreLabel = document.querySelector('#window > p');
    const scoreLabel = document.getElementById('scoreLabel');
    const quizSet = gon.quizSet;
    const totalQuizNum = Object.keys(quizSet).length;

    let currentNum = 0;
    let isAnswered;
    let score = 0;
    
    // canvasの表示設定
    var w = $('.chart').width();
    var h = $('.chart').height();
    $('#rader_result').attr('width', w);
    $('#rader_result').attr('height', h);




    question.textContent = quizSet[currentNum].q;

    
    function getLevel(arr){
        if (arr.length >=10){
        var scoreArray = arr.slice(-10);
        var scoreLength = scoreArray.length;
        let sum = 0;
        for (let i = 0;i < 10; i++){
            sum += scoreArray[i];   
        }
        var level = Math.floor(sum / scoreLength);
            return  level;
        }else{
         return false;
        }
    }

    function shuffle(arr) {
        // 例えば３×０〜１未満で小数点を切ると１か２がでる。
        for (let i = arr.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [arr[j], arr[i]] = [arr[i], arr[j]];
        }
        return arr;
    }

  

    function checkAnswer(li) {
        // if (isAnswered === true) {
        if (isAnswered) {
            return;
        }
        isAnswered = true;

        if (li.textContent === quizSet[currentNum].c[0]) {
            // console.log('correct');
            // クラスを取りのぞくときはaddをremoveにするだけ
            li.classList.add('correct');
            score++;
        } else {
            // console.log('wrong');
            li.classList.add('wrong');
        }
        // nextボタン
        btn.classList.remove('disabled');
    }

    function setQuiz() {
        isAnswered = false;
        quizCount.textContent = `${currentNum+1} / ${totalQuizNum}`;
        question.textContent = quizSet[currentNum].q;


        // クイズをセットする前にすでにある問題を削除する
        while (choices.firstChild) {
            choices.removeChild(choices.firstChild);
        }

        // 選択肢をシャッフルする
        const shuffledChoices = shuffle([...quizSet[currentNum].c]);
        // console.log(quizSet[currentNum].c);

        shuffledChoices.forEach(choice => {
            const li = document.createElement('li');
            // liタグを作る
            btn.classList.add('disabled')
            li.textContent = choice;
            // liタグの内容を入れる
            li.addEventListener('click', () => {
                checkAnswer(li);
            });
            choices.appendChild(li);
            // ulタグのchoicesにliを入れる
        });
            
        //最後の問題だった場合の設定
        if (currentNum === quizSet.length - 1) {

            btn.textContent = 'Show Score';
        }
    }

    setQuiz();

    // nextボタンを押したら、次の添え字を増やし、それに対応するクイズをセット
    btn.addEventListener('click', () => {
        // disabled（押せない表示）が出ていたら、即returnで何もしない
        if (btn.classList.contains('disabled')) {
            return;
        }
        btn.classList.add('disabled');

        // 最後の問題なら新問題をセットせず、スコアをだす。
        if (currentNum === quizSet.length - 1) {
            score = Math.floor(score / quizSet.length * 100)
            // ここにajax通信で結果をdbに保存する記述をする

        //    スコアを保存して、配列を受け取る
           $.ajax({
               type: 'POST',
               url: '/score_record/create',
               data: {score_record:{
                                        score: score,
                                        quizTitle: gon.title,
                                        user_id: gon.user_id
                                    }
               },
               dataType: 'json'
           }).done(function(data){
               var level = getLevel(data);
               showLinearChart(data,chart1);
               if (level){
                   learningLevel.textContent = `${level}`;
                   
                   showDoughnutChart(data,chart2,level);
                    }else{
                        coution.textContent = "To measure your learinig level,please play 10 times at least"
                   }
               

           }).fail(function(){
               alert('score was not saved ......');
           })
            

            // 「’」これでは式が展開しない、「`」だと式が展開する
            scoreLabel.textContent = `Score:  ${score} `;
            window.classList.add('show');
        } else {
            currentNum++;
            setQuiz();
        }
    })
}