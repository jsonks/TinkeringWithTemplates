$(document).ready(function() {

// ---------Archival slips 3137 ---------//
  //Adds a button to run the proper template at the top of the report results
  if (window.location.href.indexOf("guided_reports.pl?id=3137") > -1) {
    
    const template_link = $('#runreport_431').attr('href');
    
    $('.report_number:contains("3137")').parent().after('<span><a class="btn btn-primary" style="margin-left:0.5em;" href="' + template_link + '">Generate inserts</a></span>');
  }  

});
