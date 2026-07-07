-- 1. Re-point wines.country_id from legacy (continent NULL or 'Others') rows
--    to canonical countries (continent IS NOT NULL AND continent <> 'Others')
--    via case-insensitive match on the wine's country text field.
UPDATE public.wines w
SET country_id = canonical.id
FROM public.wine_countries legacy
JOIN public.wine_countries canonical
  ON lower(trim(canonical.name)) = lower(trim(legacy.name))
 AND canonical.continent IS NOT NULL
 AND canonical.continent <> 'Others'
WHERE w.country_id = legacy.id
  AND (legacy.continent IS NULL OR legacy.continent = 'Others');

-- 1b. Also try to re-point any wines that still reference a legacy row but
--     whose country text matches a canonical country directly.
UPDATE public.wines w
SET country_id = canonical.id
FROM public.wine_countries legacy, public.wine_countries canonical
WHERE w.country_id = legacy.id
  AND (legacy.continent IS NULL OR legacy.continent = 'Others')
  AND canonical.continent IS NOT NULL
  AND canonical.continent <> 'Others'
  AND lower(trim(canonical.name)) = lower(trim(coalesce(w.country, '')));

-- 1c. For wines still pointing at a legacy row, null out country_id so they
--     don't break the foreign-key-like reference after deletion.
UPDATE public.wines w
SET country_id = NULL
WHERE country_id IN (
  SELECT id FROM public.wine_countries
  WHERE continent IS NULL OR continent = 'Others'
);

-- 2. Delete legacy countries (cascades to wine_regions via FK ON DELETE CASCADE).
DELETE FROM public.wine_countries
WHERE continent IS NULL OR continent = 'Others';

-- 3. Delete any orphaned wine_regions whose country_id no longer exists.
DELETE FROM public.wine_regions r
WHERE NOT EXISTS (
  SELECT 1 FROM public.wine_countries c WHERE c.id = r.country_id
);

-- 4. Null out wines.region_id values that now reference deleted regions.
UPDATE public.wines w
SET region_id = NULL
WHERE region_id IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM public.wine_regions r WHERE r.id = w.region_id);
