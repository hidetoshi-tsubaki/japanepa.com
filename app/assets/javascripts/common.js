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
  $('select').on('change', function () {
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

  // ソート（ajax)
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
