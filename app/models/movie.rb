class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.find_movies_with_same_director(id)
    case movie = Movie.find_by_id(id)
    when nil then []
    else
      case director = movie.director
      when nil then []
      when '' then []
      else Movie.where("id != ?", id).find_all_by_director(director)
      end
    end
    #Movie.where("id != ?", id).find_all_by_director(Movie.find_by_id(id).director)
  end
end
