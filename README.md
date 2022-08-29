# README

Exploring the OMDb API: https://www.omdbapi.com/

## Local Installation

1. clone repo
2. bundle install
3. bundle exec figaro install (for safely handling api key as environment variable)
4. Get your free API key at https://www.omdbapi.com/
5. Navigate to `config/application.yml`
6. Add the following key: `omdb_api_key: <key acquired in step 4 goes here>`
7. start up a rails server with `rails server`
8. Search for some movies.

