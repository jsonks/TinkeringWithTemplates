 if ($('body').is('#circ_circulation-home')) {
//  var printOdueTesters = ['IOLA', 'PARSONS'];
//  if ($.inArray(libcode, printOdueTesters) !== -1) {   
  
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
  var pnLink = '/cgi-bin/koha/reports/guided_reports.pl?id=' + pnReportNumber +'&op=run&template=' + pnTemplateID + '&sql_params=' + pnBranch +'&sql_params=' + pnDate1 +'&sql_params=' + pnDate2 +'&param_name=Choose%20Library%7Cbranches&param_name=Notices%20for%7Cdate&param_name=and%7Cdate';
  var pnLink2 = '/cgi-bin/koha/reports/guided_reports.pl?id=' + pnReportNumber +'&op=run&template=' + pnTemplateID + '&sql_params=' + pnBranch +'&sql_params=' + pnDate2 +'&sql_params=' + pnDate2 +'&param_name=Choose%20Library%7Cbranches&param_name=Notices%20for%7Cdate&param_name=and%7Cdate';
  
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
    var pnLink3 = '/cgi-bin/koha/reports/guided_reports.pl?id=' + pnReportNumber +'&op=run&template=' + pnTemplateID + '&sql_params=' + pnBranch +'&sql_params=' + chosenDate +'&sql_params=' + chosenDate +'&param_name=Choose%20Library%7Cbranches&param_name=Notices%20for%7Cdate&param_name=and%7Cdate'; 
   
    $('#pnDatePickGo').attr('href', pnLink3);
  });

//  }
 }


// --------- Print overdue notices 3022 ------------- //  
//Print notices from a template
  if (window.location.href.indexOf("guided_reports.pl?id=3022") > -1) {
// Sort overdues in each notice   
    var duelist = $('.odue-list');
    
    duelist.each(function(){
      $(this).find('.odue').sort(function(a, b) {
        return String.prototype.localeCompare.call($(a).data('callnum').toLowerCase(), $(b).data('callnum').toLowerCase());
      }).appendTo($(this));
    });
    
    //Content editable button
    $('.edit-notice-button').click( function() {
      $(this).find('.fa').toggleClass('fa-lock').toggleClass('fa-unlock');
      $(this).find('span').text(function(i, text) {
        return text === "Unlock editing" ? "Lock editing" : "Unlock editing";
      });
      $('.notice').attr('contenteditable', function(index, attr){
          return attr == 'true' ? null : 'true';
      });
      $('.panel-body').toggleClass('panel-highlight');
  });
    
    //exclude from print button
    $(".exclude-from-print-button").click(function(){
      $(this).next('.notice').toggleClass('print');
      $(this).next('.notice').toggle();
      $(this).find('.fa').toggleClass('fa-remove').toggleClass('fa-plus');
      $(this).find('span').text(function(i, text) {
        return text === "Exclude from batch print" ? "Include in batch print" : "Exclude from batch print";
      });
    });  

    //Print single button
    $('.print-one-button').click( function() {
	let orderWindow2 = window.open('','');
	orderWindow2.document.write(`
        <style>
        .odue:nth-child(odd)  {background-color: #eee;}
        .no-print {display: none;}
        .odue-list:not(:last-child) {border-bottom: 1px dotted;}
        </style>`
     );	
     $(this).next().next('.notice').each(function() {
        console.log($(this).html());
     	orderWindow2.document.write( '<div style="font-family: arial; padding: 12mm 28mm 0; page-break-before:always; width:8.5in;">' + $(this).html() + '</div>' );
     });
  
    orderWindow2.document.close();
    orderWindow2.focus();
    orderWindow2.print();
    orderWindow2.close();
    });
    
    //Print batch button
    $('#printnoticesbutton').click( function() {
	let orderWindow = window.open('','');
	orderWindow.document.write(`
        <style>
        .odue:nth-child(odd)  {background-color: #eee;}
        .no-print {display: none;}
        .odue-list:not(:last-child) {border-bottom: 1px dotted;}
        </style>`
     );	
     $('.print').each(function() {
        //console.log($(this).html())
     	orderWindow.document.write( '<div style="font-family: arial; padding: 12mm 28mm 0; page-break-before:always; width:8.5in;">' + $(this).html() + '</div>' );
     });
  
    orderWindow.document.close();
    orderWindow.focus();
    orderWindow.print();
    orderWindow.close();
    });
    

    

  }
