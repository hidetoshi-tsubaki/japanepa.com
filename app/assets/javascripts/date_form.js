// 作成日
function dateInput() {
    $('#creation_date_from, #update_date_from, #start_time_from, #end_time_from, #start_time').datetimepicker({
      format: 'YYYY-MM-DD',
    });
    $('#creation_date_to, #update_date_to, #start_time_to, #end_time_to, #end_time').datetimepicker({
      format: 'YYYY-MM-DD',
      useCurrent: false
    });
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
  // event開始期間
    $("#start_time_from").on("change.datetimepicker", function (e) {
      $('#start_time_to').datetimepicker('minDate', e.date);
    });
    $("#start_time_to").on("change.datetimepicker", function (e) {
      $('#start_time_from').datetimepicker('maxDate', e.date);
    });
  // event終了期間
    $("#end_time_from").on("change.datetimepicker", function (e) {
      $('#end_time_to').datetimepicker('minDate', e.date);
    });
    $("#end_time_to").on("change.datetimepicker", function (e) {
      $('#end_time_from').datetimepicker('maxDate', e.date);
    });
  // event 開始日・終了日
    $("#start_time").on("change.datetimepicker", function (e) {
      $('#end_time').datetimepicker('minDate', e.date);
    });
    $("#end_time").on("change.datetimepicker", function (e) {
      $('#start_time').datetimepicker('maxDate', e.date);
    });
}
dateInput();