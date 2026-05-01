CREATE TABLE public.wine_countries (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL,
  name text NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  UNIQUE (user_id, name)
);

ALTER TABLE public.wine_countries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own wine countries"
  ON public.wine_countries FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own wine countries"
  ON public.wine_countries FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own wine countries"
  ON public.wine_countries FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own wine countries"
  ON public.wine_countries FOR DELETE USING (auth.uid() = user_id);

CREATE TRIGGER set_wine_countries_updated_at
  BEFORE UPDATE ON public.wine_countries
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_wine_countries_user ON public.wine_countries(user_id, sort_order);

CREATE TABLE public.wine_regions (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL,
  country_id uuid NOT NULL REFERENCES public.wine_countries(id) ON DELETE CASCADE,
  name text NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  UNIQUE (user_id, country_id, name)
);

ALTER TABLE public.wine_regions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own wine regions"
  ON public.wine_regions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own wine regions"
  ON public.wine_regions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own wine regions"
  ON public.wine_regions FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own wine regions"
  ON public.wine_regions FOR DELETE USING (auth.uid() = user_id);

CREATE TRIGGER set_wine_regions_updated_at
  BEFORE UPDATE ON public.wine_regions
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_wine_regions_country ON public.wine_regions(user_id, country_id, sort_order);