# Github-awards

Github-awards gives your ranking on Github by language and by location (city, country and worldwide) based on the number of stars of your repos.


## How it works ?

In order to calculate your ranking on Github we need to :
- Get all github users with their location
- Geocode their location
- Get all github repositories with language and number of stars 

With this informations we are able to compute your ranking for a given language in a given city.

## Step 1 : Get all users and repositories

There are over 10 Millions users and 15 Millions repositories on Github, we cannot just call the get single element API from for each user and repos.

However the Github list API returns 100 results at a time with basic informations :
- [get-all-users](https://developer.github.com/v3/users/#get-all-users)
- [list-all-public-repositories](https://developer.github.com/v3/repos/#list-all-public-repositories)

With this you can get up to 500k user / repo per hour : this is enough to get the entire list of users and repositories with basic informations (username, repo name, etc).

Rake task are :

``` rake user:crawl ```

``` rake repo:crawl ```

Now we need to get detailed informations such as location, language, number of stars.


## Step 2 : Use Google Big Query to get details about active users and repositories 

> GitHub Archive is a project to record the public GitHub timeline, archive it, and make it easily accessible for further analysis.

The Github Archive dataset is public, with Google Big Query we can filter the dataset to get only the latest event for each repo and users. Unfortunatly the Github Archives events starts from 2011, so we won't get ranking informations for users and repos that have been inactive since 2011.

- Request for repositories :

[users.sql](https://github.com/vdaubry/github-awards-api/blob/master/sql/GoogleBigQuery/users.sql)

- Request for users :

[repos.sql](https://github.com/vdaubry/github-awards-api/blob/master/sql/GoogleBigQuery/repos.sql)

We can then download the results as JSON, parse the result, and fill missing informations about users and repos

Rake task are :

``` rake user:parse_users ```

``` rake repo:parse_repos ```

We now have users location, and repositories language and number of stars. In order to get country and world rank we need to geocode user locations


## Step 3 : Geocoding user locations

Location on Github is a plain text field, there are about 1 million profil with location on Github. Free geocoding APIs usually have a hard rate limiting. First step is to geocode only distinct location, which leaves about 100k location to geocode.
A solution to speed up the geocoding is to use a combination of :

- [Google Geocoding API](https://developers.google.com/maps/documentation/geocoding/)
- [Open Street Map API](http://wiki.openstreetmap.org/wiki/Nominatim)

Rake task is :

``` rake user:geocode_locations ```

We now have all informations we need to compute ranking.

## Step 4 : Compute rankings by language and by location (city/country/world)

To get rankings we first calculate a score for each user in each language using this formula :

``` sum(stars) + (1.0 - 1.0/count(repositories)) ```

Then we use Postgres [ROW_NUMBER()](http://www.postgresql.org/docs/9.4/static/functions-window.html) function to get ranks compared to other developers with repositories in the same languages, in the same location (by city, by country or worldwide).

Ok, now we have all github users ranking :)

In order to speed up queries based on user ranks, we create a table with all rankings informations. Once we have all rankings informations on a single table we can properly index it, and get acceptable response time when we query it from a web application.

The query to create the language_rankings table can be found here :

[rank.sql](https://github.com/vdaubry/github-awards-api/blob/master/sql/rank.sql)


## Step 5 : VOILA ! Look for your ranking and have fun :)


Next steps :

- Github connect
- Manually refresh your informations
- Automating data update
- Improve UI


## Contributing :

* Fork it ( https://github.com/vdaubry/github-awards/fork )
* Create your feature branch (git checkout -b my-new-feature)
* Commit your changes (git commit -am 'Add some feature')
* Push to the branch (git push origin my-new-feature)
* Create a new Pull Request