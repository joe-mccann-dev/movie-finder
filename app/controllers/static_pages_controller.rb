require 'net/http'

class StaticPagesController < ApplicationController
  def home
    if params[:search].present?
      find_movies
    end
  end

  def find_movies
    # first response returns list of movies with imdb_ids
    response = Net::HTTP.get_response(initial_query)
    data = JSON.parse(response.body)
    initial_results = data["Search"]
    @imdb_ids = initial_results.map { |result| result["imdbID"] }
    @movies = movies
  end

  private

  def initial_query
    URI("https://www.omdbapi.com/?apikey=#{Figaro.env.omdb_api_key}&s=#{params[:search]}")
  end

  def movies
    @imdb_ids.map do |id|
      query = URI("https://www.omdbapi.com/?apikey=#{Figaro.env.omdb_api_key}&i=#{id}")
      response = Net::HTTP.get_response(query)
      movie = JSON.parse(response.body)
    end
  end
end
