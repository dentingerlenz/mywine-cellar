-- Re-link country_id from text country field
UPDATE wines w
SET country_id = wc.id
FROM wine_countries wc
WHERE lower(trim(w.country)) = lower(trim(wc.name))
  AND (w.country_id IS NULL OR w.country_id NOT IN (SELECT id FROM wine_countries));

-- Re-link region_id from text region field, scoped to matched country
UPDATE wines w
SET region_id = wr.id
FROM wine_regions wr
WHERE lower(trim(w.region)) = lower(trim(wr.name))
  AND wr.country_id = w.country_id
  AND (w.region_id IS NULL OR w.region_id NOT IN (SELECT id FROM wine_regions));