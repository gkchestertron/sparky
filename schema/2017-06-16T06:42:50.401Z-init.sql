-- create schemas
create schema if not exists public;
drop schema if exists sparky cascade;
drop schema if exists sparky_private cascade;
create schema sparky;
create schema sparky_private;

-- create person table
create table sparky.person (
  id               serial primary key,
  first_name       text not null check (char_length(first_name) < 80),
  last_name        text check (char_length(last_name) < 80),
  about            text,
  created_at       timestamp default now()
);

-- add comments on person table
comment on table  sparky.person is 'A person of the forum.';
comment on column sparky.person.id is 'The primary unique identifier for the person.';
comment on column sparky.person.first_name is 'The person’s first name.';
comment on column sparky.person.last_name is 'The person’s last name.';
comment on column sparky.person.about is 'A short description about the person, written by the person.';
comment on column sparky.person.created_at is 'The time this person was created.';

-- create full name function
create function sparky.person_full_name(person sparky.person) returns text as $$
	select person.first_name || ' ' || person.last_name
$$ language sql stable;

comment on function sparky.person_full_name(sparky.person) is 'A person’s full name which is a concatenation of their first and last name.';

-- add updated columns
alter table sparky.person add column updated_at timestamp default now();

-- add triggers and function for update
create function sparky_private.set_updated_at() returns trigger as $$
begin
  new.updated_at := current_timestamp;
  return new;
end;
$$ language plpgsql;

create trigger person_updated_at before update
  on sparky.person
  for each row
  execute procedure sparky_private.set_updated_at();
