$(function () {
  // メニューボタン開閉
  $('.menu_btn, .admin_menu_btn').on('click', function() {
    $('.user_menu, .admin_menu').fadeToggle(100);
  });
  $('.sp_menu_btn, .close_sp_menu_btn ').on('click', function() {
    $('.user_menu_in_mobile').toggle();
    $('.sp_menu_btn, .close_sp_menu_btn').toggle();
  })
  // モーダル開閉
  $('#openModal').on('click',function () {
    $('#modalArea').fadeIn();
  });
  $('#closeModal , #modalBg, #score_bg').on('click',function () {
    $('#modalArea, #score_modal_area').fadeOut();
    $('#linearChart, #doughnutsChart, #learningLevel, #coutionm .quiz_title').empty();
  });
  // logInModalの表示
  $('#openLoginModal').on('click', function () {
    $('#modalArea').fadeIn();
    $('#LoginModal').removeClass('hidden');
  });
  // コメント一覧の開閉
  $('.comment_btn').on('click', function () {
    $(this).parent().next().fadeToggle();
  })
  // トップへ戻る
  var back_to_top_btn = $('#back_to_top_btn_wrapper');
  back_to_top_btn.hide();
  $(window).scroll(function () {
    if ($(this).scrollTop() > 100) {
      back_to_top_btn.fadeIn();
    } else {
      back_to_top_btn.fadeOut();
    }
  });
  back_to_top_btn.click(function () {
    $('body, html').animate({ scrollTop: 0 }, 500);
    return false;
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
  });
  // 通知の表示
  // $(function flash(){
    setTimeout("$('#flash').fadeOut('slow')",2000);
  // })
// tab切り替え
$('.tab').on('click', function(){
  $('.is-active').removeClass('is-active');
  $(this).addClass('is-active');
  $('.is-show').removeClass('is-show');
  const index = $(this).index();
  $(".panel").eq(index).addClass('is-show');
})
// quiz-accordion
$('.ac_btn').on('click',function(){
  $(this).next('.accordion .ac-inner').slideToggle();
  $('.ac_btn').not($(this)).next('.accordion ac-inner').slideUp();
  $(this).children('.open_ac_btn, .close_ac_btn').toggle();
})
// 動的セレクト（section）
  $('#select_level').on('change', function () {
    var page = $('#select_level').attr('class');
    var url = $('#select_level').find('option:selected').attr('get-select-list-path');
    var value = $('option:selected').attr('value');
    $('#select_section').find('option').remove();
    $('#select_title').find('option').remove();
    $('#select_title').append(($('<option />')).val(""));
    if(value==0){
        $.ajax({
          url: url,
          type: 'get',
          dataType: "script"
        })
      }else{
      if (url) {
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
          $(sections).each(function () {
            $('#select_section').append($('<option />')
              .attr('get-select-list-path', this.path)
              .val(this.value)
              .text(this.name)
            );
          });
        });
      }
    }
  });
// 動的セレクト（title）
  $('#select_section').on('change', function () {
    var page = $('#select_section').attr('class');
    var url = $('#select_section').find('option:selected').attr('get-select-list-path');
    var value = $('#select_section').find('option:selected').attr('value');
    $('#select_title').find('option').remove();
    if (value == 0) {
      $.ajax({
        url: url,
        type: 'get',
        dataType: "script"
      })
    } else {
      if (url){
        $.ajax({
          url: url,
          type: 'get',
          dataType: "json"
        }).done(function (sections) {
          $(sections).each(function () {
            $('#select_title').append($('<option />')
              .attr('get-select-list-path', this.path)
              .val(this.value)
              .text(this.name)
            );
          });
        });
      }
    }
  });
//  quiz一覧の変更
  $('#select_title').on('change', function () {
    var page = $('#select_title').attr('class');
    if (page == "index_page"){
      var url = $('#select_title').find('option:selected').attr('get-select-list-path');
      $.ajax({
        url: url,
        type: 'get',
        dataType: "script"
      })
    }
  });
  // ドラッグアンドドロップ 並び替え
  $(function () {
    var el, sortable;
    el = document.getElementById("sortable_list");
    if (el !== null) {
      return sortable = Sortable.create(el, {
        delay: 200,
        onUpdate: function (evt) {
          return $.ajax({
            url: '/admin/quiz_categories/' + $("#parent_id").val() + '/sort',
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
  // カレンダー入力共通設定
  $('#creation_date_from, #update_date_from, #start_time_from, #end_time_from, #start_time').datetimepicker({
    format: 'L',
    format: 'YYYY/MM/DD'
  });
  $('#creation_date_to, #update_date_to, #start_time_to, #end_time_to, #end_time').datetimepicker({
    useCurrent: false,
    format: 'L',
    format: 'YYYY/MM/DD'
  });
  // 作成日
  $("#creation_date_from").on("change.datetimepicker", function (e) {
    $('#creation_date_to').datetimepicker('minDate', e.date);
  });
  $("#creation_date_to").on("change.datetimepicker", function (e) {
    $('#creation_date_from').datetimepicker('maxDate', e.date);
  });
  // 更新日
  $("#update_date_from").on("change.datetimepicker", function (e) {
    $('#update_date_to').datetimepicker('minDate', e.date);
  });
  $("#update_date_to").on("change.datetimepicker", function (e) {
    $('#update_date_from').datetimepicker('maxDate', e.date);
  });
  // 開始日
  $("#start_time_from").on("change.datetimepicker", function (e) {
    $('#start_time_to').datetimepicker('minDate', e.date);
  });
  $("#start_time_to").on("change.datetimepicker", function (e) {
    $('#start_time_from').datetimepicker('maxDate', e.date);
  });
// 終了日
  $("#end_time_from").on("change.datetimepicker", function (e) {
    $('#end_time_to').datetimepicker('minDate', e.date);
  });
  $("#end_time_to").on("change.datetimepicker", function (e) {
    $('#end_time_from').datetimepicker('maxDate', e.date);
  });
// event_form
  $("#start_time").on("change.datetimepicker", function (e) {
    $('#end_time').datetimepicker('minDate', e.date);
  });
  $("#end_time").on("change.datetimepicker", function (e) {
    $('#start_time').datetimepicker('maxDate', e.date);
  });
// クリアボタン
  $('#clear_btn').on('click', function () {
    $(".datetimepicker-input, .keyword_search, select").val("");
  });
// ARTICLE tag-form
  $('#form-tags').tagit({
    fieldName: 'article[tag_list]',
    singleField: true,
    availableTags: gon.available_tags
  });
  if (gon.article_tags) {
    for (var i = 0; i < gon.article_tags.length; i++) {
      $('#form-tags').tagit(
        'createTag', gon.article_tags[i]
      )
    }
  }
// COMMUNITY tag-form
  $('#form_tags').tagit({
    fieldName: 'community[tag_list]',
    singleField: true,
    availableTags: gon.available_tags
  });
  if (gon.community_tags) {
    for (var i = 0; i < gon.community_tags.length; i++) {
      $('#form-tags').tagit(
        'createTag', gon.community_tags[i]
      )
    }
  }
  // calendar 詳細表示
  $(".event").on('click', function () {
    event_id = $(this).attr('id');
    event_url = "/events/" + event_id
    $.ajax({
      url: event_url,
      cache: false,
      contentType: false,
      processData: false,
      type: 'get',
      dataType: "script",
      success: function () {
        console.log('display event successfully');
      }
    })
  });
  // information 詳細表示
  $(".announce").on('click', function () {
    announce_id = $(this).attr('id');
    announce_url = "/announcements/" + announce_id
    $.ajax({
      url: announce_url,
      cache: false,
      contentType: false,
      processData: false,
      type: 'get',
      dataType: "script",
      success: function () {
        console.log('display announcement successfully');
      }
    })
  });
  $(".category_sort_btn").on('click', function() {
    $(".category_sort, .open_accordion, .close_accordion").toggle();
  })
});