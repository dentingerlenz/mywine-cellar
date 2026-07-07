CREATE TABLE public.wine_colours (
  id uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid NOT NULL,
  name text NOT NULL,
  display_name text NOT NULL,
  sort_order integer NOT NULL DEFAULT 0,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  UNIQUE (user_id, name)
);

ALTER TABLE public.wine_colours ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own wine colours"
  ON public.wine_colours FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own wine colours"
  ON public.wine_colours FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own wine colours"
  ON public.wine_colours FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own wine colours"
  ON public.wine_colours FOR DELETE
  USING (auth.uid() = user_id);

CREATE TRIGGER set_wine_colours_updated_at
  BEFORE UPDATE ON public.wine_colours
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_wine_colours_user ON public.wine_colours(user_id, sort_order);