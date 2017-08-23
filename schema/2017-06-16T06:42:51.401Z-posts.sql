-- create a new enum type
create type sparky.post_topic as enum (
  'discussion',
  'inspiration',
  'help',
  'showcase'
);

-- create the post table
create table sparky.post (
  id               serial primary key,
  author_id        integer not null references sparky.person(id),
  headline         text not null check (char_length(headline) < 280),
  body             text,
  topic            sparky.post_topic,
  created_at       timestamp default now()
);

-- add some annotations
comment on table  sparky.post is 'A forum post written by a person.';
comment on column sparky.post.id is 'The primary key for the post.';
comment on column sparky.post.headline is 'The title written by the person.';
comment on column sparky.post.author_id is 'The id of the author person.';
comment on column sparky.post.topic is 'The topic this has been posted in.';
comment on column sparky.post.body is 'The main body text of our post.';
comment on column sparky.post.created_at is 'The time this post was created.';

-- create post summary function
create function sparky.post_summary(
  post sparky.post,
  length int default 50,
  omission text default '…'
) returns text as $$
  select case
    when post.body is null then null
    else substr(post.body, 0, length) || omission
  end
$$ language sql stable;

comment on function sparky.post_summary(sparky.post, int, text) is 'A truncated version of the body for summaries.';

-- latest post function
create function sparky.person_latest_post(person sparky.person) returns sparky.post as $$
  select post.*
  from sparky.post as post
  where post.author_id = person.id
  order by created_at desc
  limit 1
$$ language sql stable;

comment on function sparky.person_latest_post(sparky.person) is 'Get’s the latest post written by the person.';

-- search post function
create function sparky.search_posts(search text) returns setof sparky.post as $$
  select post.*
  from sparky.post as post
  where post.headline ilike ('%' || search || '%') or post.body ilike ('%' || search || '%')
$$ language sql stable;

comment on function sparky.search_posts(text) is 'Returns posts containing a given search term.';

-- add updated at
alter table sparky.post add column updated_at timestamp default now();

-- add triggers and function for update
create trigger post_updated_at before update
  on sparky.post
  for each row
  execute procedure sparky_private.set_updated_at();
