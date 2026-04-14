$(document).ready(function() {
//Makes the print buttons on the template target the label for the specific row
let reportNum = '3093'; //report number
if (window.location.href.indexOf("guided_reports.pl?id=" + reportNum) > -1) {
  $('#libraries tbody tr').each(function () {
    let this_row = $(this);
    let branch = this_row.find('.library').attr('id');
  
    $('#print-label-' + branch).on('click', function() {
      $('#label-' + branch).removeClass('hide');
      printLabel('#label-' + branch);
      $('#label-' + branch).addClass('hide');
    });
  });  
}

});                  
