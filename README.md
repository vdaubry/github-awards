[![Build Status](https://semaphoreci.com/api/v1/projects/aa2cd6ce-b19d-43bc-9db1-f1c3c2756be9/389922/badge.svg)](https://semaphoreci.com/vdaubry/github-awards)      

# Important notice : Github Awards becomes Git Awards !

# Git Awards

Git Awards gives your ranking on GitHub by language and by location (city, country and worldwide) based on the number of stars on your repos.


## How does it work ?

In order to calculate your ranking on GitHub we:
- Get all GitHub users with their location
- Geocode their location
- Get all GitHub repositories with language and number of stars 

With this information we are able to compute your ranking for a given language in a given city.

## Step 1 : Get all users and repositories

There are over 10 Millions users and 15 Millions repositories on GitHub, we cannot just call the GitHub API for each user and his repos.

However the GitHub list API returns 100 results at a time with basic information :
- [get-all-users](https://developer.github.com/v3/users/#get-all-users)
- [list-all-public-repositories](https://developer.github.com/v3/repos/#list-all-public-repositories)

With this one can get up to 500k user / repo per hour : this is enough to get the entire list of users and repositories with basic informations (username, repo name, etc).

Rake tasks are :

    rake user:crawl
    rake repo:crawl

Now we need to get detailed informations such as location, language, number of stars.


## Step 2 : Use Google Big Query to get details about active users and repositories 

> GitHub Archive is a project to record the public GitHub timeline, archive it, and make it easily accessible for further analysis.

The GitHub Archive dataset is public, with Google Big Query we can filter the dataset to get only the latest event for each repo and users. Unfortunatly the GitHub Archives events starts from 2011, so we won't get ranking informations for users and repos that have been inactive since 2011.

- Request for users :

[users.sql](https://github.com/vdaubry/github-awards-api/blob/master/sql/GoogleBigQuery/users.sql)

- Request for repositories :

[repos.sql](https://github.com/vdaubry/github-awards-api/blob/master/sql/GoogleBigQuery/repos.sql)

We can then download the results as JSON, parse the result, and fill missing information about users and repos.

Rake tasks are :

    rake user:parse_users
    rake repo:parse_repos

We now have the users location, and repositories language and number of stars. In order to get country and world rank we need to geocode user locations


## Step 3 : Geocoding user locations

Location on GitHub is a plain text field, there are about 1 million profiles with location on GitHub. Free geocoding APIs usually have a hard rate limiting. First step is to geocode only distinct location, which leaves about 100k locations to geocode.
A solution to speed up the geocoding is to use a combination of :

- [Google Geocoding API](https://developers.google.com/maps/documentation/geocoding/)
- [Open Street Map API](http://wiki.openstreetmap.org/wiki/Nominatim)

Rake task is :

    rake user:geocode_locations

We now have all the information we need to compute ranking.

## Step 4 : Compute rankings by language and by location (city/country/world)

To get rankings we first calculate a score for each user in each language using this formula :

    sum(stars) + (1.0 - 1.0/count(repositories))

Then we use Postgres [ROW_NUMBER()](http://www.postgresql.org/docs/9.4/static/functions-window.html) function to get ranks compared to other developers with repositories in the same languages, in the same location (by city, by country or worldwide).

Ok, now we have all GitHub users' ranking :)

In order to speed up queries based on user ranks, we create a table with all rankings information. Once we have all rankings informations on a single table we can properly index it, we get acceptable response time when we query it from a web application.

The query to create the language_rankings table can be found here :

[rank.sql](https://github.com/vdaubry/github-awards-api/blob/master/sql/rank.sql)


## Step 5 : VOILA ! Look for your ranking and have fun :)


Next steps :

- Github connect
- Manually refresh your informations
- Automating data update
- Improve UI


## Contributing :

* Fork it `https://github.com/vdaubry/github-awards/fork`
* Create your feature branch `git checkout -b my-new-feature`
* Commit your changes `git commit -am 'Add some feature'`
* Push to the branch `git push origin my-new-feature`
* Create a new Pull Request

## License 

This project is available under the MIT license. [See the license file](LICENSE.md) for more details.
