CREATE TABLE public.drinking_log (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  wine_id uuid,
  date date NOT NULL DEFAULT CURRENT_DATE,
  note text,
  people_ids uuid[] NOT NULL DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.drinking_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own drinking log"
  ON public.drinking_log FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own drinking log"
  ON public.drinking_log FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own drinking log"
  ON public.drinking_log FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own drinking log"
  ON public.drinking_log FOR DELETE USING (auth.uid() = user_id);

CREATE INDEX idx_drinking_log_user_id ON public.drinking_log(user_id);
CREATE INDEX idx_drinking_log_wine_id ON public.drinking_log(wine_id);