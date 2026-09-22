create table if not exists public.payment_events (
  id uuid primary key default gen_random_uuid(),
  provider text not null,
  provider_event_id text not null,
  topup_id uuid references public.wallet_topups(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique(provider, provider_event_id)
);
alter table public.payment_events enable row level security;
