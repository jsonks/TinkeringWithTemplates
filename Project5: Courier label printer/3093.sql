SELECT branches.*,
  MAX(CASE WHEN afv.field_id = '1' THEN afv.value END) AS couriercode,
  MAX(CASE WHEN afv.field_id = '5' THEN afv.value END) AS courierroute
FROM branches
LEFT JOIN additional_field_values afv ON (branches.branchcode = afv.record_id)
GROUP BY branches.branchcode
