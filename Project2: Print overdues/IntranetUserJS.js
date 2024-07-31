  //Add link to print notices
  var today = new Date();
  var date = today.toISOString().split('T')[0];
  var yesterday = new Date(today);
  yesterday.setDate(today.getDate() - 1);
  var yesterdate = yesterday.toISOString().split('T')[0];
  var pnTemplateID = 303;
  var pnReportNumber = 3022;
  var pnBranch = libcode;
  var pnDate1 = yesterdate;
  var pnDate2 = date;
  var dayOfWeek = today.getDay(); //Sunday = 0; Saturday = 6
  var pnLink = '/cgi-bin/koha/reports/guided_reports.pl?reports=' + pnReportNumber +'&phase=Run%20this%20report&template=' + pnTemplateID + '&sql_params=' + pnBranch +'&sql_params=' + pnDate1 +'&sql_params=' + pnDate2 +'&param_name=Choose%20Library%7Cbranches&param_name=Notices%20for%7Cdate&param_name=and%7Cdate';
    var pnLink2 = '/cgi-bin/koha/reports/guided_reports.pl?reports=' + pnReportNumber +'&phase=Run%20this%20report&template=' + pnTemplateID + '&sql_params=' + pnBranch +'&sql_params=' + pnDate2 +'&sql_params=' + pnDate2 +'&param_name=Choose%20Library%7Cbranches&param_name=Notices%20for%7Cdate&param_name=and%7Cdate';
  
 if (dayOfWeek == 1){ //Monday
  $("#circ_circulation-home h3:contains('Overdues')").next().append('<fieldset class="brief" id="oduePrintDate"><span style="font-size: 110%; font-weight: bold;"><i class="fa fa-print"></i> Print notices for: </span><div><a class="btn btn-primary btn-sm" style="width: 100%; font-weight: bold; margin-top: 10px;" href="'+ pnLink + '" title="Includes Sunday and Monday">Today</a></div><hr><div><span >Or choose a specific date:</span><input id="pnFlatpickr" size="12"> <a type="submit" id="pnDatePickGo" class="btn btn-primary btn-sm" style="margin-bottom: 4px; font-weight: bold;" href="'+ pnLink + '">Go</a></div></fieldset>');
  } else {
  $("#circ_circulation-home h3:contains('Overdues')").next().append('<fieldset class="brief" id="oduePrintDate"><span style="font-size: 110%; font-weight: bold;"><i class="fa fa-print"></i> Print notices for: </span><div><a class="btn btn-primary btn-sm" style="width: 100%; font-weight: bold; margin-top: 10px;" href="'+ pnLink2 + '">Today</a></div><hr><div><span >Or choose a specific date:</span><input id="pnFlatpickr" size="12"> <a type="submit" id="pnDatePickGo" class="btn btn-primary btn-sm" style="margin-bottom: 4px; font-weight: bold;" href="'+ pnLink2 + '">Go</a></div></fieldset>');
  }

  flatpickr("#pnFlatpickr", {
    defaultDate: new Date(today),
    dateFormat: 'Y-m-d',
    altInput: true,
    altFormat: 'Y-m-d',
    allowInput: true,
  });
     
  $("#pnFlatpickr").change(function(){
    var chosenDate = $("#pnFlatpickr").attr('value');
    var pnLink3 = '/cgi-bin/koha/reports/guided_reports.pl?reports=' + pnReportNumber +'&phase=Run%20this%20report&template=' + pnTemplateID + '&sql_params=' + pnBranch +'&sql_params=' + chosenDate +'&sql_params=' + chosenDate +'&param_name=Choose%20Library%7Cbranches&param_name=Notices%20for%7Cdate&param_name=and%7Cdate'; 
   
    $('#pnDatePickGo').attr('href', pnLink3);
  });

  }
 }
