SELECT
    biblio.biblionumber,
    items.dateaccessioned,
    items.barcode,
    items.itemcallnumber,
    biblio.author,
    concat(biblio.title, ' ', ExtractValue((
        SELECT metadata 
        FROM biblio_metadata
        WHERE biblio.biblionumber = biblio_metadata.biblionumber),
         '//datafield[@tag="245"]/subfield[@code="b"]')) AS FullTitle,
    biblioitems.isbn,
    biblio.copyrightdate,
    COALESCE(CONCAT('<img src="https://images-na.ssl-images-amazon.com/images/P/',
  IF
  (LEFT(TRIM(biblioitems.isbn), 3) = '978',
    CONCAT(SUBSTR(TRIM(biblioitems.isbn), 4, 9),
    REPLACE(MOD(11 - MOD
        (CONVERT(SUBSTR(TRIM(biblioitems.isbn), 4, 1), UNSIGNED INTEGER)*10 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 5, 1), UNSIGNED INTEGER)*9 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 6, 1), UNSIGNED INTEGER)*8 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 7, 1), UNSIGNED INTEGER)*7 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 8, 1), UNSIGNED INTEGER)*6 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 9, 1), UNSIGNED INTEGER)*5 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 10, 1), UNSIGNED INTEGER)*4 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 11, 1), UNSIGNED INTEGER)*3 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 12, 1), UNSIGNED INTEGER)*2, 11
	  ), 11), '10', 'X')
	),
    LEFT(TRIM(biblioitems.isbn), 10)
  ),
     '.01.MZZZZZZZZZ.jpg">'),'<img src="https://dl.dropboxusercontent.com/s/nkun7xeysbqp4q9/noImageAvailable.png?dl=0">') AS Render,
 
  IF
  (LEFT(TRIM(biblioitems.isbn), 3) = '978',
    CONCAT(SUBSTR(TRIM(biblioitems.isbn), 4, 9),
    REPLACE(MOD(11 - MOD
        (CONVERT(SUBSTR(TRIM(biblioitems.isbn), 4, 1), UNSIGNED INTEGER)*10 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 5, 1), UNSIGNED INTEGER)*9 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 6, 1), UNSIGNED INTEGER)*8 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 7, 1), UNSIGNED INTEGER)*7 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 8, 1), UNSIGNED INTEGER)*6 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 9, 1), UNSIGNED INTEGER)*5 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 10, 1), UNSIGNED INTEGER)*4 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 11, 1), UNSIGNED INTEGER)*3 +
         CONVERT(SUBSTR(TRIM(biblioitems.isbn), 12, 1), UNSIGNED INTEGER)*2, 11
	  ), 11), '10', 'X')
	),
    LEFT(TRIM(biblioitems.isbn), 10)
  ) AS cleanISBN
FROM items
LEFT JOIN biblio ON (biblio.biblionumber = items.biblionumber)
LEFT JOIN biblioitems ON (biblio.biblionumber = biblioitems.biblionumber)
LEFT JOIN biblio_metadata ON (biblio.biblionumber = biblio_metadata.biblionumber)
WHERE items.barcode IN <<Enter 6 barcodes|list>> 
ORDER BY biblio.author
LIMIT 6
