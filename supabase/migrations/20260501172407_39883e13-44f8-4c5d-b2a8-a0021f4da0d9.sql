CREATE TABLE public.wines (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  wine_id TEXT,
  producer TEXT,
  wine_name TEXT NOT NULL,
  vintage INTEGER,
  bottle_size TEXT,
  grape_variety TEXT,
  dosage TEXT,
  alcohol_volume NUMERIC,
  country TEXT,
  region TEXT,
  sub_region TEXT,
  aging TEXT,
  tasting_notes TEXT,
  occasion TEXT,
  in_stock INTEGER DEFAULT 0,
  price NUMERIC,
  purchase_source TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

ALTER TABLE public.wines ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view wines" ON public.wines FOR SELECT USING (true);
CREATE POLICY "Anyone can insert wines" ON public.wines FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can update wines" ON public.wines FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete wines" ON public.wines FOR DELETE USING (true);

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

CREATE TRIGGER update_wines_updated_at
BEFORE UPDATE ON public.wines
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();