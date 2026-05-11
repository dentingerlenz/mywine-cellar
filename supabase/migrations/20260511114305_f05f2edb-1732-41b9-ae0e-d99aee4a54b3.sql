-- Extend wine_appellations to support full classification hierarchy
-- 1. Add nullable FK columns for country and region, plus level indicator
ALTER TABLE wine_appellations
  ADD COLUMN IF NOT EXISTS country_id uuid REFERENCES wine_countries(id) ON DELETE CASCADE,
  ADD COLUMN IF NOT EXISTS region_id uuid REFERENCES wine_regions(id) ON DELETE CASCADE,
  ADD COLUMN IF NOT EXISTS level text NOT NULL DEFAULT 'appellation';

-- 2. Partial unique index to prevent duplicate appellations at the same hierarchy level
CREATE UNIQUE INDEX IF NOT EXISTS wine_appellations_unique
  ON wine_appellations (
    name,
    level,
    COALESCE(country_id::text, ''),
    COALESCE(region_id::text, ''),
    COALESCE(sub_region_id::text, '')
  );

-- 3. RLS note: the existing SELECT policy "Authenticated users can view wine appellations"
--    uses USING (true), which already covers all columns including the new ones.
--    No RLS changes required.

COMMENT ON COLUMN wine_appellations.level IS
  'Hierarchy level: country, region, or appellation';
COMMENT ON COLUMN wine_appellations.country_id IS
  'Set when level = country or region or appellation (nullable for appellation-level rows linked only via sub_region_id)';
COMMENT ON COLUMN wine_appellations.region_id IS
  'Set when level = region or appellation (nullable for country-level rows)';

-- Back-fill existing rows: they all represent appellation-level entries
UPDATE wine_appellations SET level = 'appellation' WHERE level IS NULL;

-- Drop and recreate the unique index to ensure it matches the intended columns exactly
DROP INDEX IF EXISTS wine_appellations_unique;
CREATE UNIQUE INDEX wine_appellations_unique
  ON wine_appellations (
    name,
    level,
    COALESCE(country_id::text, ''),
    COALESCE(region_id::text, ''),
    COALESCE(sub_region_id::text, '')
  );

-- Validate the allowed values for level with a trigger (not a CHECK constraint, per guidelines)
CREATE OR REPLACE FUNCTION public.validate_appellation_level()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  IF NEW.level NOT IN ('country', 'region', 'appellation') THEN
    RAISE EXCEPTION 'Invalid level: %. Must be country, region, or appellation', NEW.level;
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS validate_appellation_level_trigger ON wine_appellations;
CREATE TRIGGER validate_appellation_level_trigger
  BEFORE INSERT OR UPDATE ON wine_appellations
  FOR EACH ROW
  EXECUTE FUNCTION public.validate_appellation_level();

-- Also validate hierarchy consistency with a trigger
CREATE OR REPLACE FUNCTION public.validate_appellation_hierarchy()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  IF NEW.level = 'country' AND (NEW.region_id IS NOT NULL OR NEW.sub_region_id IS NOT NULL) THEN
    RAISE EXCEPTION 'country level appellation must have null region_id and sub_region_id';
  END IF;
  IF NEW.level = 'region' AND (NEW.sub_region_id IS NOT NULL OR NEW.country_id IS NULL) THEN
    RAISE EXCEPTION 'region level appellation must have country_id set and null sub_region_id';
  END IF;
  IF NEW.level = 'appellation' AND NEW.country_id IS NULL AND NEW.region_id IS NULL AND NEW.sub_region_id IS NULL THEN
    RAISE EXCEPTION 'appellation level appellation must have at least one of country_id, region_id, or sub_region_id set';
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS validate_appellation_hierarchy_trigger ON wine_appellations;
CREATE TRIGGER validate_appellation_hierarchy_trigger
  BEFORE INSERT OR UPDATE ON wine_appellations
  FOR EACH ROW
  EXECUTE FUNCTION public.validate_appellation_hierarchy();

-- Set updated_at trigger if not already present
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$function$;

DROP TRIGGER IF EXISTS set_wine_appellations_updated_at ON wine_appellations;
CREATE TRIGGER set_wine_appellations_updated_at
  BEFORE UPDATE ON wine_appellations
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

-- Clean up: drop old index names that might conflict
DROP INDEX IF EXISTS idx_wine_appellations_name_level;
DROP INDEX IF EXISTS idx_wine_appellations_unique;

-- Recreate the unique index with the correct name
CREATE UNIQUE INDEX IF NOT EXISTS wine_appellations_unique
  ON wine_appellations (
    name,
    level,
    COALESCE(country_id::text, ''),
    COALESCE(region_id::text, ''),
    COALESCE(sub_region_id::text, '')
  );

-- Add non-unique indexes for common lookups
CREATE INDEX IF NOT EXISTS idx_wine_appellations_country_id ON wine_appellations(country_id);
CREATE INDEX IF NOT EXISTS idx_wine_appellations_region_id ON wine_appellations(region_id);
CREATE INDEX IF NOT EXISTS idx_wine_appellations_level ON wine_appellations(level);

-- Ensure RLS read policy is permissive (it should already be USING true)
-- Recreate to be explicit about the new columns being covered
DROP POLICY IF EXISTS "Authenticated users can view wine appellations" ON wine_appellations;
CREATE POLICY "Authenticated users can view wine appellations"
  ON wine_appellations
  FOR SELECT
  TO authenticated
  USING (true);

-- Keep existing write policies untouched
-- INSERT: Users can insert their own wine appellations (WITH CHECK auth.uid() = user_id)
-- UPDATE: Users can update their own wine appellations (USING auth.uid() = user_id)
-- DELETE: Users can delete their own wine appellations (USING auth.uid() = user_id)

-- Add helpful comment on the table
COMMENT ON TABLE wine_appellations IS
  'Wine appellations across full hierarchy: country, region, and appellation levels. Shared read access via RLS.';
