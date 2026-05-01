-- Drop old table
DROP TABLE IF EXISTS public.wines CASCADE;

-- Wine colour enum
DO $$ BEGIN
  CREATE TYPE public.wine_colour AS ENUM ('red', 'white', 'rose', 'sparkling', 'dessert');
EXCEPTION WHEN duplicate_object THEN null; END $$;

-- Bottles table
CREATE TABLE public.bottles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  producer TEXT,
  vintage INTEGER,
  region TEXT,
  country TEXT,
  appellation TEXT,
  grape TEXT,
  colour public.wine_colour,
  format TEXT DEFAULT '75cl',
  quantity INTEGER NOT NULL DEFAULT 1,
  note TEXT,
  rating INTEGER CHECK (rating BETWEEN 1 AND 5),
  ready_from INTEGER,
  drink_by INTEGER,
  photo_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_bottles_user_id ON public.bottles(user_id);

ALTER TABLE public.bottles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own bottles" ON public.bottles
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own bottles" ON public.bottles
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own bottles" ON public.bottles
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own bottles" ON public.bottles
  FOR DELETE USING (auth.uid() = user_id);

CREATE TRIGGER bottles_updated_at
  BEFORE UPDATE ON public.bottles
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- Storage bucket for wine label photos
INSERT INTO storage.buckets (id, name, public)
VALUES ('wine-photos', 'wine-photos', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Wine photos are publicly readable"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'wine-photos');

CREATE POLICY "Users can upload their own wine photos"
  ON storage.objects FOR INSERT
  WITH CHECK (bucket_id = 'wine-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can update their own wine photos"
  ON storage.objects FOR UPDATE
  USING (bucket_id = 'wine-photos' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can delete their own wine photos"
  ON storage.objects FOR DELETE
  USING (bucket_id = 'wine-photos' AND auth.uid()::text = (storage.foldername(name))[1]);