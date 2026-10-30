-- Run this in your Supabase SQL Editor to set up the public.books table and storage buckets

create table if not exists public.books (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  author text default 'Drovexra',
  category text default 'Strategy & Business',
  description text,
  cover_path text,
  pdf_path text,
  created_at timestamptz default now()
);

alter table public.books enable row level security;

create policy "Allow public read access on books"
  on public.books
  for select
  to anon, authenticated
  using (true);

insert into storage.buckets (id, name, public)
values
  ('book-covers', 'book-covers', true),
  ('book-pdfs', 'book-pdfs', true)
on conflict (id) do update set public = true;

create policy "Public read access for book-covers"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'book-covers');

create policy "Public read access for book-pdfs"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'book-pdfs');
