-- add pgcrypto
create extension if not exists "pgcrypto";

-- add private person account table
create table sparky_private.person_account (
  person_id        integer primary key references sparky.person(id) on delete cascade,
  email            text not null unique check (email ~* '^.+@.+\..+$'),
  password_hash    text not null
);

comment on table sparky_private.person_account is 'Private information about a person’s account.';
comment on column sparky_private.person_account.person_id is 'The id of the person associated with this account.';
comment on column sparky_private.person_account.email is 'The email address of the person.';
comment on column sparky_private.person_account.password_hash is 'An opaque hash of the person’s password.';

-- register person function
create function sparky.register_person(
  first_name text,
  last_name text,
  email text,
  password text
) returns sparky.person as $$
declare
  person sparky.person;
begin
  insert into sparky.person (first_name, last_name) values
    (first_name, last_name)
    returning * into person;

  insert into sparky_private.person_account (person_id, email, password_hash) values
    (person.id, email, crypt(password, gen_salt('bf')));

  return person;
end;
$$ language plpgsql strict security definer;

comment on function sparky.register_person(text, text, text, text) is 'Registers a single person and creates an account in our forum.';

-- create some roles
drop role if exists sparky_anonymous;
create role sparky_anonymous;
grant sparky_anonymous to sparky_postgraphql;

drop role if exists sparky_person;
create role sparky_person;
grant sparky_person to sparky_postgraphql;

drop role if exists sparky_contributor;
create role sparky_contributor;
grant sparky_contributor to sparky_postgraphql;

drop role if exists sparky_moderator;
create role sparky_moderator;
grant sparky_moderator to sparky_postgraphql;

drop role if exists sparky_admin;
create role sparky_admin;
grant sparky_admin to sparky_postgraphql;

-- create token type
create type sparky.jwt_token as (
  role text,
  person_id integer
);

-- add auth function
create function sparky.authenticate(
  email text,
  password text
) returns sparky.jwt_token as $$
declare
  account sparky_private.person_account;
begin
  select a.* into account
  from sparky_private.person_account as a
  where a.email = $1;

  if account.password_hash = crypt(password, account.password_hash) then
    return ('sparky_person', account.person_id)::sparky.jwt_token;
  else
    return null;
  end if;
end;
$$ language plpgsql strict security definer;

comment on function sparky.authenticate(text, text) is 'Creates a JWT token that will securely identify a person and give them certain permissions.';

-- add  current person function
create or replace function sparky.current_person() returns sparky.person as $$
  declare 
    person sparky.person;
  begin
    select * into person
      from sparky.person
      where id = current_setting('jwt.claims.person_id')::integer;
      return person;
  exception
    when SQLSTATE '42704' then
      return null;
  end;
$$ language plpgsql stable;

comment on function sparky.current_person() is 'Gets the person who was identified by our JWT.';
grant execute on function sparky.current_person() to sparky_anonymous, sparky_person;

-- grants
-- after schema creation and before function creation
alter default privileges revoke execute on functions from public;

grant usage on schema sparky to sparky_anonymous, sparky_person;

grant select on table sparky.person to sparky_anonymous, sparky_person;
grant update, delete on table sparky.person to sparky_person;

grant select on table sparky.post to sparky_anonymous, sparky_person;
grant insert, update, delete on table sparky.post to sparky_person;
grant usage on sequence sparky.post_id_seq to sparky_person;

grant execute on function sparky.person_full_name(sparky.person) to sparky_anonymous, sparky_person;
grant execute on function sparky.post_summary(sparky.post, integer, text) to sparky_anonymous, sparky_person;
grant execute on function sparky.person_latest_post(sparky.person) to sparky_anonymous, sparky_person;
grant execute on function sparky.search_posts(text) to sparky_anonymous, sparky_person;
grant execute on function sparky.authenticate(text, text) to sparky_anonymous, sparky_person;
grant execute on function sparky.current_person() to sparky_anonymous, sparky_person;

grant execute on function sparky.register_person(text, text, text, text) to sparky_anonymous;

-- enable row-level security
alter table sparky.person enable row level security;
alter table sparky.post enable row level security;

-- read policy for anybody
create policy select_person on sparky.person for select
  using (true);

create policy select_post on sparky.post for select
  using (true);

-- write/delete policies for logged in persons on their own accts
create policy update_person on sparky.person for update to sparky_person
  using (id = current_setting('jwt.claims.person_id')::integer);

create policy delete_person on sparky.person for delete to sparky_person
  using (id = current_setting('jwt.claims.person_id')::integer);

-- post policies
create policy insert_post on sparky.post for insert to sparky_person
  with check (author_id = current_setting('jwt.claims.person_id')::integer);

create policy update_post on sparky.post for update to sparky_person
  using (author_id = current_setting('jwt.claims.person_id')::integer);

create policy delete_post on sparky.post for delete to sparky_person
  using (author_id = current_setting('jwt.claims.person_id')::integer);
