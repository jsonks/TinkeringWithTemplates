SELECT i.itemcallnumber, b.title, bi.pages, CONCAT( 
        '<img src="/cgi-bin/koha/svc/barcode?barcode=',
         CONCAT('A', i.barcode, 'A'),
        '&type=NW7&notext=1',
        '"></img>') AS bcodepic, i.barcode as bcodetext
FROM items i
LEFT JOIN biblio b USING (biblionumber)
LEFT JOIN biblioitems bi USING (biblionumber)
WHERE i.barcode = <<Barcode>>
