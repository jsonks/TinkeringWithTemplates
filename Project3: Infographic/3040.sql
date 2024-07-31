SELECT
  z.branchname, z.date1, z.date2,
  patrons.borrowercount, patrons.newborrowers,
  collectioncount.collectioncount, collectioncount.newitems,
  cbreakdown.AB AS countAB, cbreakdown.AUD AS countAUD, cbreakdown.BLU AS countBLU, cbreakdown.DVD AS countDVD, cbreakdown.JB AS countJB, cbreakdown.LOT AS countLOT, cbreakdown.MUS AS countMUS, cbreakdown.PER AS countPER, cbreakdown.SOF AS countSOF,
  TRIM(TRAILING '/' FROM popular.fulltitle) as fulltitle, TRIM(TRAILING ',' FROM popular.author) AS author, popular.circs AS popcircs, popular.normISBN,
  holdsfilled.holdscount,
  SUM(IF(s.ccode="AB", 1, 0)) AS AB,
  SUM(IF(s.ccode="AUD", 1, 0)) AS AUD,
  SUM(IF(s.ccode="BLU", 1, 0)) AS BLU,
  SUM(IF(s.ccode="DVD", 1, 0)) AS DVD,
  SUM(IF(s.ccode="JB", 1, 0)) AS JB,  
  SUM(IF(s.ccode="LOT", 1, 0)) AS LOT,
  SUM(IF(s.ccode="MUS", 1, 0)) AS MUS,
  SUM(IF(s.ccode="PER", 1, 0)) AS PER,
  SUM(IF(s.ccode="SOF", 1, 0)) AS SOF,
  COUNT(*) AS total,  
  SUM(IF(s.ccode="AB", 1, 0))/COUNT(*) AS slice1,
  SUM(IF(s.ccode IN ("AB", "AUD"), 1, 0))/COUNT(*) AS slice2,
  SUM(IF(s.ccode IN ("AB", "AUD", "BLU"), 1, 0))/COUNT(*) AS slice3,
  SUM(IF(s.ccode IN ("AB", "AUD", "BLU", "DVD"), 1, 0))/COUNT(*) AS slice4,
  SUM(IF(s.ccode IN ("AB", "AUD", "BLU", "DVD"), 1, 0))/COUNT(*) AS slice5,
  SUM(IF(s.ccode IN ("AB", "AUD", "BLU", "DVD",  "JB"), 1, 0))/COUNT(*) AS slice6,
  SUM(IF(s.ccode IN ("AB", "AUD", "BLU", "DVD",  "JB", "LOT"), 1, 0))/COUNT(*) AS slice7,
  SUM(IF(s.ccode IN ("AB", "AUD", "BLU", "DVD",  "JB", "LOT", "MUS"), 1, 0))/COUNT(*) AS slice8,
  SUM(IF(s.ccode IN ("AB", "AUD", "BLU", "DVD",  "JB", "LOT", "MUS", "PER"), 1, 0))/COUNT(*) AS slice9,
  SUM(IF(s.ccode IN ("AB", "AUD", "BLU", "DVD",  "JB", "LOT", "MUS", "PER", "SOF"), 1, 0))/COUNT(*) AS slice10
FROM statistics s
LEFT JOIN borrowers p ON s.borrowernumber=p.borrowernumber
LEFT JOIN deletedborrowers dp ON s.borrowernumber=dp.borrowernumber
LEFT JOIN ( /*-----LIBRARY & DATE INFO-----*/
  SELECT branchname, branchcode, date_format(<<Between|date>>, '%m/%d/%Y') AS date1, date_format(<<and|date>>, '%m/%d/%Y') AS date2
  FROM branches
  WHERE branchcode = <<Choose Library|branches>>
) z ON s.branch = z.branchcode
LEFT JOIN ( /*-----PATRON COUNT INFO-----*/
  SELECT branchcode, COUNT(*) AS borrowercount, SUM(IF(borrowers.dateenrolled BETWEEN <<Between|date>> AND <<and|date>>, 1, 0)) AS newborrowers
  FROM borrowers
  WHERE branchcode = <<Choose Library|branches>>
  GROUP BY branchcode
) patrons ON s.branch = patrons.branchcode
LEFT JOIN ( /*-----HOLDS FILLED COUNT-----*/
  SELECT branchcode, COUNT(*) AS holdscount
  FROM old_reserves
  WHERE branchcode = <<Choose Library|branches>>
  AND found = 'F'
  AND waitingdate BETWEEN <<Between|date>> AND <<and|date>>
) holdsfilled ON s.branch = holdsfilled.branchcode
LEFT JOIN ( /*-----COLLECTION COUNT INFO-----*/
  SELECT homebranch, COUNT(*) AS collectioncount, SUM(IF(items.dateaccessioned BETWEEN <<Between|date>> AND <<and|date>>, 1, 0)) AS newitems
  FROM items
  WHERE homebranch = <<Choose Library|branches>>
  GROUP BY homebranch
) collectioncount ON s.branch = collectioncount.homebranch
LEFT JOIN (/*-----COLLECTION BREAKDOWN-----*/
SELECT homebranch,
  SUM(IF(ccode="AB", 1, 0)) AS AB,
  SUM(IF(ccode="AUD", 1, 0)) AS AUD,
  SUM(IF(ccode="BLU", 1, 0)) AS BLU,
  SUM(IF(ccode="DVD", 1, 0)) AS DVD,
  SUM(IF(ccode="JB", 1, 0)) AS JB,  
  SUM(IF(ccode="LOT", 1, 0)) AS LOT,
  SUM(IF(ccode="MUS", 1, 0)) AS MUS,
  SUM(IF(ccode="PER", 1, 0)) AS PER,
  SUM(IF(ccode="SOF", 1, 0)) AS SOF
FROM items
WHERE homebranch = <<Choose Library|branches>>
GROUP BY homebranch
) cbreakdown ON s.branch = cbreakdown.homebranch
LEFT JOIN ( /*-----MOST POPULAR BOOK-----*/
  SELECT COUNT(*) as circs, CONCAT(biblio.title, ' ', IFNULL(subtitle, ' ')) AS fulltitle, author, s.itemnumber, branch, isbn,
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
  ) AS normISBN
  FROM statistics s
LEFT JOIN items ON (s.itemnumber = items.itemnumber)
LEFT JOIN biblio ON (items.biblionumber = biblio.biblionumber)
LEFT JOIN biblioitems ON (biblio.biblionumber=biblioitems.biblionumber)
  LEFT JOIN borrowers USING (borrowernumber)
  WHERE s.datetime BETWEEN <<Between|date>> AND <<and|date>>
  AND type IN ('issue', 'renew')
  AND s.branch = <<Choose Library|branches>>
  AND items.ccode IN ('AB', 'JB')
  AND borrowers.categorycode <> 'ILL'
  GROUP BY biblio.biblionumber
  ORDER BY circs DESC
  LIMIT 1
) popular ON s.branch = popular.branch
JOIN authorised_values a ON s.ccode=a.authorised_value
WHERE s.datetime BETWEEN <<Between|date>> AND <<and|date>>
    AND s.branch LIKE <<Choose Library|branches>>
    AND s.type IN ('issue', 'renew', 'localuse')
    AND (p.categorycode <> 'ILL' OR dp.categorycode <> 'ILL')
    AND s.ccode IN ('AB', 'AUD', 'BLU', 'DVD', 'GAM', 'JB', 'LOT', 'MUS', 'PER', 'SOF')
    AND a.category = 'CCODE'
