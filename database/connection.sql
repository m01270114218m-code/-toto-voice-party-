-- Royal Voice production connection hardening.
DO $$ BEGIN
IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname='public' AND tablename='rooms' AND policyname='rooms_public_read') THEN CREATE POLICY rooms_public_read ON public.rooms FOR SELECT TO anon USING (status='live'); END IF;
IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname='public' AND tablename='gifts' AND policyname='gifts_public_read') THEN CREATE POLICY gifts_public_read ON public.gifts FOR SELECT TO anon USING (active=true); END IF;
END $$;