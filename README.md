# README

Exploring the OMDb API: https://www.omdbapi.com/
I developed this project to further practice interacting with APIs, so that I can do so quickly.

## Local Installation

1. clone repo
2. bundle install
3. bundle exec figaro install (for safely handling api key as environment variable)
4. Get your free API key at https://www.omdbapi.com/
5. Navigate to `config/application.yml`
6. Add the following key: `omdb_api_key: <key acquired in step 4 goes here>`
7. start up a rails server with `rails server`
8. Search for some movies.

### About API Requests

The way this particular API is structured required me to first make an "initial request" to get all of the ids returned by a title search, and then using `map`, iterate over each id to cache requests and make requests in parallel. Querying this API with the movie's id grants more information, such as "Actors" and "Plot". I used the `Typhoeus` gem to make requests in parallel, see: https://github.com/typhoeus/typhoeus. As the maintainer's state, "Typhoeus wraps libcurl in order to make fast and reliable requests." This seemed like a good fit for making several requests in parallel with the added benefit of caching requests. Following their basic example was enough to accomplish this.