// 画像アップロード プレ画像
function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $('#new_img, #new_user_img').attr('src', e.target.result);
    }
    reader.readAsDataURL(input.files[0]);
  }
};
$(function () {
  $('#input_img').on('change', function () {
    $('#new_img, #new_user_img').removeClass('hidden');
    $('#present_img, #present_user_img, #no_img, #no_user_img').remove();
    readURL(this);
    $('#cancel_img_btn, #delete_img_btn, #new_img, #present_img, #new_user_img').removeClass('hidden');
    $('input[type="checkbox"]').removeAttr('checked').prop('checked', false).change();
  });
  $('#cancel_img_btn, #delete_img_btn').on('click', function () {
    $('#input_img').val("");
    $('#new_img, #new_user_img, #present_img').attr('src', "");
    $('#cancel_img_btn, #delete_img_btn, #new_img, #present_img, #new_user_img').addClass('hidden');
    $('input[type="checkbox"]').attr('checked', true).prop('checked', true).change();
  })
});