require 'spec_helper'

describe Movie do
  def valid_attributes
    {}
  end
  def valid_session
    {}
  end
  describe '.all_ratings' do
    it 'should return an Array of string containing G, PG, PG-13, NC-17 and R' do
      Movie.all_ratings.should == %w(G PG PG-13 NC-17 R)
    end
  end
  describe '.find_movies_with_same_director(id)' do
    context 'when no movie matches the given id' do
      it 'should return empty array' do
        Movie.stub(:find_by_id).and_return(nil)
        Movie.find_movies_with_same_director(1).should == []
      end
    end
    context 'when a movie matches the given id' do
      context 'when movie has no director' do
        context 'when director is nil' do
          it 'should return empty array' do
            fake_movie = mock('Movie', :director => nil)
            Movie.stub(:find_by_id).and_return(fake_movie)
            Movie.find_movies_with_same_director(1).should == []
          end
        end
        context 'when director is empty string' do
          it 'should return empty array' do
            fake_movie = mock('Movie', :director => '')
            Movie.stub(:find_by_id).and_return(fake_movie)
            Movie.find_movies_with_same_director(1).should == []
          end
        end
      end
      context 'when movie has a director' do
        it 'should return other movies that have the same director' do
          fake_movie = mock('Movie', :director => 'Fake Director')
          Movie.stub(:find_by_id).and_return(fake_movie)
          Movie.stub_chain(:where, :find_all_by_director).and_return('It passes this part of the code')
          Movie.find_movies_with_same_director(1).should == 'It passes this part of the code'
        end
      end
    end
  end
end
