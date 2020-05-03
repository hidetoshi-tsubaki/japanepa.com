// 動的セレクト（section）
$(function () {
  $('#select_level').on('change', function () {
    var page = $('#select_level').attr('class');
    var url = $('#select_level').find('option:selected').attr('get-select-list-path');
    var value = $('option:selected').attr('value');
    $('#select_section').find('option').remove();
    $('#select_title').find('option').remove();
    $('#select_title').append(($('<option />')).val(""));
    if (value == 0) {
      $.ajax({
        url: url,
        type: 'get',
        dataType: "script"
      })
    } else {
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
  // 動的セレクト（section, title）
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
      if (url) {
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
});