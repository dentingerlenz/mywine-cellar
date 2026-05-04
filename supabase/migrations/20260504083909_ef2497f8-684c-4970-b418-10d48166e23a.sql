CREATE TABLE public.people (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  name text NOT NULL,
  avatar text,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.people ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own people" ON public.people FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert their own people" ON public.people FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own people" ON public.people FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own people" ON public.people FOR DELETE USING (auth.uid() = user_id);

CREATE INDEX idx_people_user_id ON public.people(user_id);