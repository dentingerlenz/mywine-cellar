-- Add continent column to wine_countries
ALTER TABLE wine_countries ADD COLUMN IF NOT EXISTS continent text;

-- Create wine_sub_regions table
CREATE TABLE IF NOT EXISTS wine_sub_regions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  region_id uuid NOT NULL REFERENCES wine_regions(id) ON DELETE CASCADE,
  name text NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  user_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Enable RLS on wine_sub_regions
ALTER TABLE wine_sub_regions ENABLE ROW LEVEL SECURITY;

-- Policies for wine_sub_regions
CREATE POLICY "Users can view their own wine sub regions"
ON wine_sub_regions
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own wine sub regions"
ON wine_sub_regions
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own wine sub regions"
ON wine_sub_regions
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own wine sub regions"
ON wine_sub_regions
FOR DELETE
USING (auth.uid() = user_id);

-- Create wine_appellations table
CREATE TABLE IF NOT EXISTS wine_appellations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  sub_region_id uuid NOT NULL REFERENCES wine_sub_regions(id) ON DELETE CASCADE,
  name text NOT NULL,
  appellation_type text,
  sort_order integer NOT NULL DEFAULT 0,
  user_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Enable RLS on wine_appellations
ALTER TABLE wine_appellations ENABLE ROW LEVEL SECURITY;

-- Policies for wine_appellations
CREATE POLICY "Users can view their own wine appellations"
ON wine_appellations
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own wine appellations"
ON wine_appellations
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own wine appellations"
ON wine_appellations
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own wine appellations"
ON wine_appellations
FOR DELETE
USING (auth.uid() = user_id);;

-- Add updated_at trigger for the new tables
CREATE TRIGGER update_wine_sub_regions_updated_at
BEFORE UPDATE ON wine_sub_regions
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER update_wine_appellations_updated_at
BEFORE UPDATE ON wine_appellations
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();;