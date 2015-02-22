SELECT
  a.actor_attributes_login AS login,
  a.actor_attributes_name AS name,
  a.actor_attributes_company AS company,
  a.actor_attributes_location AS location,
  a.actor_attributes_blog AS blog,
  a.actor_attributes_email AS email,
  a.payload_member_avatar_url AS avatar_url,
FROM [githubarchive:github.timeline] a
JOIN EACH
  (
     SELECT MAX(created_at) as max_created, actor_attributes_login
     FROM [githubarchive:github.timeline]
     GROUP EACH BY actor_attributes_login
  ) b
  ON 
  b.max_created = a.created_at and
  b.actor_attributes_login = a.actor_attributes_login