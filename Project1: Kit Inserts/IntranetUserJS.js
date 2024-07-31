// --------- Kit sheet insert 3039 ---------//

  //Print kit sheet from a template
  if (window.location.href.indexOf("guided_reports.pl?reports=3039") > -1) {
      //Print single button
    $('.print-one-button').click( function() {
	let orderWindow2 = window.open('','');
	orderWindow2.document.write(`
        <style>
        .no-print {display: none;}
        </style>`
     );	
     $(this).next('.notice').each(function() {
        orderWindow2.document.write( '<div style="font-family: arial; font-size: large; width:8.5in; height:11in; margin: 0 auto; display: grid; grid-gap: 10px; grid-template-rows: 2in 2in 5.45in 1.5in;">' + $(this).html() + '</div>' );
     });
  
    orderWindow2.document.close();
    orderWindow2.focus();
    orderWindow2.print();
    orderWindow2.close();
    });  
  }  
