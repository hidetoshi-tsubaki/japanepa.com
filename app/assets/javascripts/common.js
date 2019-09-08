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
  
  //  通知の表示
  $(function(){
    setTimeout("$('#flash').fadeOut('slow')",2000);
  })

  $('#select_level').on('change', function () {
    var page = $('#select_section').attr('class');
    var url = $('option:selected').data('quiz-select-path');
    if (url){
      var selectSection = $('#select_section');
      var selectTitle = $('#select_title');
      data = new FormData();
      data.append('page', page);
      var type = 'post'
      
      $.ajax({
        url: url,
        data: data,
        cache: false,
        contentType: false,
        processData: false,
        type: 'get',
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
      $.ajax({
        url: url,
        type: 'get',
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

  // ドラッグアンドドロップ
  $(function () {
    var el, sortable;
    el = document.getElementById("sortable_list");
    if (el !== null) {
      return sortable = Sortable.create(el, {
        delay: 200,
        onUpdate: function (evt) {
          return $.ajax({
            url: '/quiz_category/' + $("#category_id").val() + '/sort',
            type: 'patch',
            data: {
              from: evt.oldIndex,
              to: evt.newIndex
            }
          });
        }
      });
    }
  });
});