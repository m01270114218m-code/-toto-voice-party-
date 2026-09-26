-- VoiceRoom external control center linkage.
-- This migration is already applied to the connected Supabase project.
create table if not exists public.admin_control_assets (
 id text primary key, type text not null, name_ar text not null, image_url text,
 animation_url text, video_url text, is_3d boolean default false, active boolean default true,
 data jsonb not null default '{}', created_at timestamptz default now(), updated_at timestamptz default now()
);
create table if not exists public.admin_app_updates (
 id bigint generated always as identity primary key, version text not null, title text not null,
 notes text default '', android_url text, ios_url text, web_url text, force_update boolean default false,
 min_supported_version text, active boolean default true, created_at timestamptz default now()
);
create table if not exists public.admin_user_overrides (
 public_id bigint primary key, frame_asset_id text, entry_asset_id text, mic_skin_id text,
 custom_id text, vip_level integer, level integer, coins bigint, diamonds bigint,
 data jsonb not null default '{}', updated_at timestamptz default now()
);