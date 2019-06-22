  // モーダル開閉
$(function () {
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

  
});







// ajax通信
// login
// $(function () {
//   $('#login').on('click', function () {
//     var community_id = $(this).val();
//     $.ajax({
//       url: '/users/sign_in',
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
//         $('#modalArea').fadeIn();
//       },
//       error: function () {
//         alert('failed to upload the image.Try again');
//       }
//     });
//   })








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
