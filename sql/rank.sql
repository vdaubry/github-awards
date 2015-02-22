DROP TABLE IF EXISTS language_ranks;

CREATE TABLE language_ranks AS
  SELECT t1.*, t2.city_user_count, t3.country_user_count, t4.world_user_count
  FROM (
    SELECT LOWER(LANGUAGE) AS LANGUAGE, LOWER(country) AS country,
      LOWER(city) AS city, 
      sum(stars) + (1.0 - 1.0/count(repositories.id)) AS score, 
      row_number() OVER (PARTITION BY repositories.language, users.city ORDER BY (sum(stars) + (1.0 - 1.0/count(repositories.id))) DESC) AS city_rank, 
      row_number() OVER (PARTITION BY repositories.language, users.country ORDER BY (sum(stars) + (1.0 - 1.0/count(repositories.id))) DESC) AS country_rank, 
      row_number() OVER (PARTITION BY repositories.language ORDER BY (sum(stars) + (1.0 - 1.0/count(repositories.id))) DESC) AS world_rank, 
      count(repositories.id) AS repository_count, 
      sum(stars) AS stars_count, 
      users.id AS user_id
    FROM repositories
    INNER JOIN users ON users.login = repositories.user_id
    WHERE repositories.language IS NOT NULL AND users.organization=FALSE
    GROUP BY repositories.language, city, country, users.id
  ) t1
  LEFT OUTER JOIN (
    SELECT count(DISTINCT user_id) AS city_user_count, 
      LOWER(repositories.language) AS LANGUAGE, 
      LOWER(city) AS city
    FROM repositories
    INNER JOIN users ON repositories.user_id = users.login
    WHERE repositories.language IS NOT NULL AND users.organization=FALSE
    GROUP BY repositories.language, city
  ) t2 ON t1.language = t2.language AND (t1.city = t2.city OR (t1.city IS NULL AND t2.city IS NULL)) 
  LEFT OUTER JOIN (
    SELECT count(DISTINCT user_id) AS country_user_count, 
      LOWER(repositories.language) AS LANGUAGE, 
      LOWER(country) AS country
    FROM repositories
    INNER JOIN users ON repositories.user_id = users.login
    WHERE repositories.language IS NOT NULL AND users.organization=FALSE
    GROUP BY repositories.language, country
  ) t3 ON t1.language = t3.language AND (t1.country = t3.country OR (t1.country IS NULL AND t3.country IS NULL))
  INNER JOIN (
    SELECT count(DISTINCT user_id) AS world_user_count, 
      LOWER(repositories.language) AS LANGUAGE
    FROM repositories
    INNER JOIN users ON repositories.user_id = users.login
    WHERE repositories.language IS NOT NULL AND users.organization=FALSE
    GROUP BY repositories.language
  ) t4 ON t1.language = t4.language;

CREATE INDEX language_ranks_user_id ON language_ranks USING btree (user_id);
CREATE INDEX language_ranks_city ON language_ranks USING btree (LANGUAGE, city_rank, city);
CREATE INDEX language_ranks_country ON language_ranks USING btree (LANGUAGE, country_rank, country);
CREATE INDEX language_ranks_world ON language_ranks USING btree (LANGUAGE, world_rank);