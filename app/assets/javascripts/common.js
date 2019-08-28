  // モーダル開閉
$(function () {
  $('.user').on('click',function(){
  $('.user_menu').fadeToggle(100);
  // $('.user').toggleClass('active');
  });
  $('#openModal').on('click',function () {
    $('#modalArea').fadeIn();
  });
  $('#closeModal , #modalBg').on('click',function () {
    $('#modalArea').fadeOut();
  });
  //  logInModalの表示
  $('#openLoginModal').on('click', function () {
    $('#modalArea').fadeIn();
    $('#LoginModal').removeClass('hidden');
  });

  //sortフォームの送信
  $('.select_sort').on('change', function () {
    var target = $('[name="sort"] option:selected').val();
    var url = $('#formSort').attr('action');
    data = new FormData();
    data.append('sort', target);
    $.ajax({
      url: url,
      data: data,
      cache: false,
      contentType: false,
      processData: false,
      type: 'post',
      dataType: "script"
    });
  });

  // ソート
  $(function () {
    $('#submit').on('click', function () {
      var url = $('#formSort').attr('action');
      $.ajax({
        url: url,
        cache: false,
        contentType: false,
        processData: false,
        type: 'get',
        success: function () {
          alert('')
        },
        error: function () {
          alert('failed ....');
        }
      });
    })
  });
  
  //  通知の表示
  $(function(){
    setTimeout("$('#notice').fadeOut('slow')",2000);
    setTimeout("$('#alert').fadeOut('slow')", 2000);
  })

  $('#select_level').on('change', function () {
    var page = $('#select_section').attr('class');
    var url = $('option:selected').data('quiz-select-path');
    if (url){
      var selectSection = $('#select_section');
      var selectTitle = $('#select_title');
      data = new FormData();
      data.append('page', page);
      $.ajax({
        url: url,
        data: data,
        cache: false,
        contentType: false,
        processData: false,
        type: 'post',
        dataType: "json"
      }).done(function (sections) {
        selectSection.find('option').remove();
        selectTitle.find('option').remove();
        $(sections).each(function () {
          selectSection.append($('<option />')
            .attr('quiz-select-path', this.path)
            .val(this.value)
            .text(this.name)
          );
        });
      });
    }
  });

  $('#select_section').on('change', function () {
    var page = $('#select_section').attr('class');
    var url = $('#select_section').find('option:selected').attr('quiz-select-path');
    if (url){
      var selectTitle = $('#select_title');
      data = new FormData();
      data.append('page', page);
      $.ajax({
        url: url,
        data: data,
        cache: false,
        contentType: false,
        processData: false,
        type: 'post',
        dataType: "json"
      }).done(function (sections) {
        selectTitle.find('option').remove();
        $(sections).each(function () {
          selectTitle.append($('<option />')
            .attr('quiz-select-path', this.path)
            .val(this.value)
            .text(this.name)
          );
        });
      });
    }
  });

  $('#select_title').on('change', function () {
    var page = $('#select_section').attr('class');
    if (page == "index_page"){
      var url = $('#select_title').find('option:selected').attr('quiz-select-path');
      var selectTitle = $('#select_title');
      $.ajax({
        url: url,
        type: 'get',
        dataType: "script"
      })
    }
  });
});



// create_community

// $(function () {
//   $('#form_community').on('click', function () {
//     //送信したいものを取得する communityのidとか。htmlをみて値を取得する
//     var val = $(this).val();
    
//     $.ajax({
//       url: '/create_community',
//       // data: {
//       //   fruit: {
//       //     id: val
//       //   }
//       // },
//       cache: false,
//       contentType: false,
//       processData: false,
//       type: 'get',
//       success: function () {
//         // コントローラーでモーダルの中_form_communityをrenderingする


//         $('#modalArea').fadeIn();
//       },
//       error: function () {
//         alert('failed to "create community" form.Try again');
//       }
//     });
//   })
// })
