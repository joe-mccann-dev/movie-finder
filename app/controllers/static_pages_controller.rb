class StaticPagesController < ApplicationController
  def home
    if params[:search].present?
      find_movies
    end
  end

  def find_movies
    # first response returns list of movies with imdb_ids
    data = JSON.parse(initial_request.body)
    initial_results = data["Search"]
    if !initial_results
      flash[:error] = "No results found, please search again."
      redirect_to root_url
      return

    end
    @imdb_ids = initial_results.map { |result| result["imdbID"] }
    @movies = movies
  end


  def initial_request
    # imdb id only accessible by first doing a generic search
    # once relevant ids are available, we can get more complete details by requesting with the id parameter
    Typhoeus.get("https://www.omdbapi.com/?apikey=#{Figaro.env.omdb_api_key}&s=#{params[:search]}&type=movie&y=#{params[:release_year]}")
  end

  def movies
    # improve performance by caching requests and making requests in parallel
    hydra = Typhoeus::Hydra.new
    requests = parallel_requests(hydra)
    hydra.run
    requests.map do |request|
      response = JSON.parse(request.response.body) if request.response.code == 200 
      response["imdb_page"] = imdb_page(response["imdbID"])
      response
    end
  end

  def parallel_requests(hydra)
    @imdb_ids.map do |id|
      request = Typhoeus::Request.new("https://www.omdbapi.com/?apikey=#{Figaro.env.omdb_api_key}&i=#{id}")
      hydra.queue(request)
      request
    end
  end

  def imdb_page(id)
    "https://www.imdb.com/title/#{id}"
  end
end
