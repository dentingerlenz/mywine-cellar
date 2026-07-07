-- Drop old table and enum
DROP TABLE IF EXISTS public.bottles CASCADE;
DROP TYPE IF EXISTS public.wine_colour CASCADE;

-- Create wines table
CREATE TABLE public.wines (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  colour text CHECK (colour IN ('sparkling','white','red','orange_rose','dessert_fortified')),
  producer text,
  description text,
  vintage text,
  cl integer,
  variety text,
  residual_sugar_gl numeric,
  dosage text,
  alcohol_pct numeric,
  country text,
  region text,
  sub_region text,
  appellation text,
  ausbau_terroir text,
  notes text,
  occasion text CHECK (occasion IN ('a','t','l','T')),
  quantity integer DEFAULT 1,
  price_chf numeric,
  purchased_from text,
  ready_from integer,
  drink_by integer,
  rating integer CHECK (rating BETWEEN 1 AND 5),
  label_photo_url text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.wines ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view their own wines"
  ON public.wines FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own wines"
  ON public.wines FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own wines"
  ON public.wines FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own wines"
  ON public.wines FOR DELETE
  USING (auth.uid() = user_id);

-- Trigger for updated_at
CREATE TRIGGER set_wines_updated_at
  BEFORE UPDATE ON public.wines
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_wines_user_id ON public.wines(user_id);
CREATE INDEX idx_wines_colour ON public.wines(colour);