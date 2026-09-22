create policy reports_admin_select on public.reports for select to authenticated using (
  exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin = true)
);
