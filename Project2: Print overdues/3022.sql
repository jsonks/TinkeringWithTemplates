SELECT c.borrowernumber, o.delay1, oo.delay2, ooo.delay3,
  mq.time_queued, mq.message_id, mq.letter_code,
  mq.subject, /* mq.content,*/
  firstname, surname, address, address2, city, state, zipcode, p.phone AS patronphone,
  l.branchname, l.branchaddress1, l.branchaddress2, l.branchaddress3, l.branchcity, l.branchstate, l.branchzip, l.branchphone, l.branchemail,
  date_format(mq.time_queued,'%m/%d/%Y') as noticedate,
  SUM(it.replacementprice) as totalcost,
  CASE WHEN(MIN(DATE(c.date_due))) < DATE(CURDATE()) THEN 'yes' ELSE 'no' END AS hasodues,
(SELECT group_concat(
        concat(
 '<div class="odue" data-callnum="',itemcallnumber,'" style="display: grid; grid-template-columns: 1fr 4fr 2fr 1.5fr 0.5fr;">
<div class="odue-date">',
    ifnull(date_format(date_due,'%m/%d/%Y'),''),
    '</div>',
    '<div class="odue-title" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">',
    concat('<strong>', b.title, '</strong>', ifnull(concat(' ',subtitle),''), ifnull(concat(' ',enumchron),'')),
    '</div>',
    '<div class="odue-callnum" id="',itemcallnumber,'" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">',
    ifnull(itemcallnumber,''),
    '</div>',
    '<div class="odue-bcode">',
    ifnull(barcode,''),
    '</div>',
    '<div class="odue-cost" align="right">',
    ifnull(concat('$',format(replacementprice,2)), '$0.00'),
    '</div></div>')separator ""
        ) FROM issues s LEFT JOIN items a USING (itemnumber) LEFT JOIN biblio b USING (biblionumber) WHERE s.borrowernumber = mq.borrowernumber AND date_due BETWEEN DATE(mq.time_queued) AND DATE(CURDATE()) ) AS lilodue,  
(SELECT group_concat(
        concat(
 '<div class="odue" data-callnum="',itemcallnumber,'" style="display: grid; grid-template-columns: 1fr 4fr 2fr 1.5fr 0.5fr;">
<div class="odue-date">',
    ifnull(date_format(date_due,'%m/%d/%Y'),''),
    '</div>',
    '<div class="odue-title" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">',
    concat('<strong>', b.title, '</strong>', ifnull(concat(' ',subtitle),''), ifnull(concat(' ',enumchron),'')),
    '</div>',
    '<div class="odue-callnum" id="',itemcallnumber,'" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">',
    ifnull(itemcallnumber,''),
    '</div>',
    '<div class="odue-bcode">',
    ifnull(barcode,''),
    '</div>',
    '<div class="odue-cost" align="right">',
    ifnull(concat('$',format(replacementprice,2)), '$0.00'),
    '</div></div>')separator ""
        ) FROM issues s LEFT JOIN items a USING (itemnumber) LEFT JOIN biblio b USING (biblionumber) WHERE s.borrowernumber = mq.borrowernumber AND date_due BETWEEN DATE(DATE_SUB(mq.time_queued, INTERVAL o.delay1 DAY)) AND DATE(mq.time_queued)) AS odue1,
(SELECT group_concat(
        concat(
 '<div class="odue" data-callnum="',i.itemcallnumber,'" style="display: grid; grid-template-columns: 1fr 4fr 2fr 1.5fr 0.5fr;">
<div class="odue-date">',
    ifnull(date_format(date_due,'%m/%d/%Y'),''),
    '</div>',
    '<div class="odue-title" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">',
    concat('<strong>', b.title, '</strong>', ifnull(concat(' ',subtitle),''), ifnull(concat(' ',i.enumchron),'')),
    '</div>',
    '<div class="odue-callnum" id="',itemcallnumber,'" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">',
    ifnull(itemcallnumber,''),
    '</div>',
    '<div class="odue-bcode">',
    ifnull(barcode,''),
    '</div>',
    '<div class="odue-cost" align="right">',
    ifnull(concat('$',format(replacementprice,2)), '$0.00'),
    '</div></div>')separator ""
        ) FROM issues s LEFT JOIN items i USING (itemnumber) LEFT JOIN biblio b USING (biblionumber) WHERE s.borrowernumber = mq.borrowernumber AND date_due BETWEEN DATE(DATE_SUB(mq.time_queued, INTERVAL oo.delay2 DAY)) AND DATE(DATE_SUB(mq.time_queued, INTERVAL o.delay1 DAY))) AS odue2,
(SELECT group_concat(
        concat(
 '<div class="odue" data-callnum="',i.itemcallnumber,'" style="display: grid; grid-template-columns: 1fr 4fr 2fr 1.5fr 0.5fr;">
<div class="odue-date">',
    ifnull(date_format(date_due,'%m/%d/%Y'),''),
    '</div>',
    '<div class="odue-title" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">',
    concat('<strong>', b.title, '</strong>', ifnull(concat(' ',subtitle),''), ifnull(concat(' ',i.enumchron),'')),
    '</div>',
    '<div class="odue-callnum" id="',itemcallnumber,'" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">',
    ifnull(itemcallnumber,''),
    '</div>',
    '<div class="odue-bcode">',
    ifnull(barcode,''),
    '</div>',
    '<div class="odue-cost" align="right">',
    ifnull(concat('$',format(replacementprice,2)), '$0.00'),
    '</div></div>')separator ""
        ) FROM issues s LEFT JOIN items i USING (itemnumber) LEFT JOIN biblio b USING (biblionumber) WHERE s.borrowernumber = mq.borrowernumber AND date_due BETWEEN DATE(DATE_SUB(mq.time_queued, INTERVAL ooo.delay3 DAY)) AND DATE(DATE_SUB(mq.time_queued, INTERVAL oo.delay2 DAY))) AS odue3,
(SELECT group_concat(
        concat(
 '<div class="odue" data-callnum="',i.itemcallnumber,'" style="display: grid; grid-template-columns: 1fr 4fr 2fr 1.5fr 0.5fr;">
<div class="odue-date">',
    ifnull(date_format(date_due,'%m/%d/%Y'),''),
    '</div>',
    '<div class="odue-title" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">',
    concat('<strong>', b.title, '</strong>', ifnull(concat(' ',subtitle),''), ifnull(concat(' ',i.enumchron),'')),
    '</div>',
    '<div class="odue-callnum" id="',itemcallnumber,'" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">',
    ifnull(itemcallnumber,''),
    '</div>',
    '<div class="odue-bcode">',
    ifnull(barcode,''),
    '</div>',
    '<div class="odue-cost" align="right">',
    ifnull(concat('$',format(replacementprice,2)), '$0.00'),
    '</div></div>')separator ""
        ) FROM issues s LEFT JOIN items i USING (itemnumber) LEFT JOIN biblio b USING (biblionumber) WHERE s.borrowernumber = mq.borrowernumber AND date_due < DATE(DATE_SUB(mq.time_queued, INTERVAL ooo.delay3 DAY))) AS vodue,
(SELECT group_concat(
        concat(
 '<div class="odue" data-callnum="',i.itemcallnumber,'" style="display: grid; grid-template-columns: 1fr 4fr 2fr 1.5fr 0.5fr;">
<div class="odue-date">',
    ifnull(date_format(date_due,'%m/%d/%Y'),''),
    '</div>',
    '<div class="odue-title" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">',
    concat('<strong>', b.title, '</strong>', ifnull(concat(' ',subtitle),''), ifnull(concat(' ',i.enumchron),'')),
    '</div>',
    '<div class="odue-callnum" id="',itemcallnumber,'" style="overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">',
    ifnull(itemcallnumber,''),
    '</div>',
    '<div class="odue-bcode">',
    ifnull(barcode,''),
    '</div>',
    '<div class="odue-cost" align="right">',
    ifnull(concat('$',format(replacementprice,2)), '$0.00'),
    '</div></div>')separator ""
        ) FROM issues s LEFT JOIN items i USING (itemnumber) LEFT JOIN biblio b USING (biblionumber) WHERE s.borrowernumber = mq.borrowernumber AND date_due > DATE(CURDATE())) AS notdueyet        
FROM issues c
LEFT JOIN message_queue mq ON (c.borrowernumber=mq.borrowernumber)
LEFT JOIN borrowers p ON (mq.borrowernumber=p.borrowernumber)
LEFT JOIN items it ON (c.itemnumber = it.itemnumber)
LEFT JOIN biblio b ON  (it.biblionumber = b.biblionumber)
LEFT JOIN branches l ON (mq.from_address = l.branchemail)
INNER JOIN (SELECT DISTINCT delay1, branchcode FROM overduerules) o ON (o.branchcode=l.branchcode)
INNER JOIN (SELECT DISTINCT delay2, branchcode FROM overduerules) oo ON (oo.branchcode=l.branchcode)
INNER JOIN (SELECT DISTINCT delay3, branchcode FROM overduerules) ooo ON (ooo.branchcode=l.branchcode)
WHERE mq.message_transport_type = 'print'
  AND mq.letter_code LIKE <<Choose Library|branches>> 'OD%'
  AND DATE(mq.time_queued) BETWEEN <<Notices for|date>> AND <<and|date>>
  AND c.branchcode = <<Choose Library|branches>>
GROUP BY mq.borrowernumber
