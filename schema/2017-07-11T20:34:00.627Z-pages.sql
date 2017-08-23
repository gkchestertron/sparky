-- create page table
create table sparky.page (
  id               serial primary key,
  route            text not null check (char_length(route) < 2000),
  name             text not null check (char_length(route) < 280),
  template         text not null check (char_length(route) < 280),
  data             jsonb not null,
  created_at       timestamp default now(),
  updated_at       timestamp default now()
);

-- page docs
comment on table sparky.page is 'A collection of pages for the app';
comment on column sparky.page.route is 'The route where this page should be shown';
comment on column sparky.page.name is 'The page name';
comment on column sparky.page.template is 'The page template file';
comment on column sparky.page.data is 'Static data for the page template';

-- create a trigger
create trigger page_updated_at before update
  on sparky.page
  for each row
  execute procedure sparky_private.set_updated_at();

-- permissions
-- TODO make admin when ACL is done
grant select on table sparky.page to sparky_anonymous, sparky_person;
grant update on table sparky.page to sparky_person;
grant insert on table sparky.page to sparky_person;
grant delete on table sparky.page to sparky_person;
