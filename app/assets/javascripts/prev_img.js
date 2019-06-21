function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $('#prev_img').attr('src', e.target.result);
    }
    reader.readAsDataURL(input.files[0]);
  }
};

$('#post_img').on('change', function () {
  $('#prev_img').removeClass('hidden');
  $('.present_img').remove();
  readURL(this);
  $('#cancel_img').removeClass('hidden');
});