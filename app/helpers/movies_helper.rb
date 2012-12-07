module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def find_similar_movies_path(movie)
    "/movies/#{movie.id}/find_similar_movies"
  end
end
