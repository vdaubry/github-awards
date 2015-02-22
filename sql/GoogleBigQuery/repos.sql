SELECT 
  a.repository_url, 
  a.repository_watchers, 
  a.repository_language, 
  a.repository_pushed_at
FROM [githubarchive:github.timeline] a
JOIN EACH
  (
     SELECT MAX(repository_pushed_at) as repository_pushed_at, repository_url
     FROM [githubarchive:github.timeline]
     GROUP EACH BY repository_url
  ) b
  ON 
  b.repository_pushed_at = a.repository_pushed_at and
  b.repository_url = a.repository_url;