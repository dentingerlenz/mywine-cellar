
-- wine_countries
DROP POLICY IF EXISTS "Users can view their own wine countries" ON public.wine_countries;
CREATE POLICY "Authenticated users can view wine countries"
  ON public.wine_countries FOR SELECT
  TO authenticated
  USING (true);

-- wine_regions
DROP POLICY IF EXISTS "Users can view their own wine regions" ON public.wine_regions;
CREATE POLICY "Authenticated users can view wine regions"
  ON public.wine_regions FOR SELECT
  TO authenticated
  USING (true);

-- wine_sub_regions
DROP POLICY IF EXISTS "Users can view their own wine sub regions" ON public.wine_sub_regions;
CREATE POLICY "Authenticated users can view wine sub regions"
  ON public.wine_sub_regions FOR SELECT
  TO authenticated
  USING (true);

-- wine_appellations
DROP POLICY IF EXISTS "Users can view their own wine appellations" ON public.wine_appellations;
CREATE POLICY "Authenticated users can view wine appellations"
  ON public.wine_appellations FOR SELECT
  TO authenticated
  USING (true);
