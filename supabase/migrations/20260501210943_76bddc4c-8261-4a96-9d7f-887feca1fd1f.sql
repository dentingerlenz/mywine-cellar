-- Step 1: Add new FK columns (nullable, so existing rows are preserved)
ALTER TABLE public.wines
  ADD COLUMN country_id uuid,
  ADD COLUMN region_id uuid;

-- Step 2: Backfill country_id by matching wines.country to wine_countries.name (per user)
UPDATE public.wines w
SET country_id = c.id
FROM public.wine_countries c
WHERE c.user_id = w.user_id
  AND c.name = w.country
  AND w.country IS NOT NULL;

-- Step 3: Backfill region_id by matching wines.region to wine_regions.name (per user)
UPDATE public.wines w
SET region_id = r.id
FROM public.wine_regions r
WHERE r.user_id = w.user_id
  AND r.name = w.region
  AND w.region IS NOT NULL;

-- Step 4: Add foreign key constraints
ALTER TABLE public.wines
  ADD CONSTRAINT wines_country_id_fkey
    FOREIGN KEY (country_id) REFERENCES public.wine_countries(id) ON DELETE SET NULL,
  ADD CONSTRAINT wines_region_id_fkey
    FOREIGN KEY (region_id) REFERENCES public.wine_regions(id) ON DELETE SET NULL;

-- Step 5: Indexes for join/filter performance
CREATE INDEX IF NOT EXISTS idx_wines_country_id ON public.wines(country_id);
CREATE INDEX IF NOT EXISTS idx_wines_region_id ON public.wines(region_id);
