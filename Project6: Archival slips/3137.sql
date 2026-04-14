SELECT i.itemcallnumber, i.barcode, b.title, i.homebranch
FROM items i
LEFT JOIN biblio b USING (biblionumber)
WHERE i.barcode IN <<Scan barcodes here|list>> 
ORDER by i.itemcallnumber  
