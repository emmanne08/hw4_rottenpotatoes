require 'spec_helper'

describe MoviesController do
  def valid_attributes
    {}
  end
  def valid_session
    {}
  end
  before :each do
    @id = 1
  end
  describe '#find_similar_movies' do
    context 'when movie has no director info' do
      it 'should redirect to index template' do
        Movie.stub(:find_movies_with_same_director).with(@id.to_s).and_return([])
        fake_movie = mock('Movie', :title => 'Fake Movie')
        Movie.stub(:find_by_id).with(@id.to_s).and_return(fake_movie)
        post :find_similar_movies, {:id => @id}
        response.should redirect_to(movies_path)
      end
    end
    context 'when movie has director info' do
      before :each do
        @fake_movies = [mock('Movie'), mock('Movie')]
        Movie.stub(:find_movies_with_same_director).with(@id.to_s).and_return(@fake_movies)
      end
      it 'should render find_similar_movies template' do
        post :find_similar_movies, {:id => @id}
        response.should render_template('find_similar_movies')
      end
      it 'should make the result of Movie.find_similar_movies available to that template' do
        post :find_similar_movies, {:id => @id}
        assigns(:movies).should == @fake_movies
      end
    end
  end
  describe '#show' do
    it 'should render show template' do
      Movie.stub(:find).with(@id.to_s)
      get :show, {:id => @id}
      response.should render_template('show')
    end
    it 'should make the result of Move.find available to that template' do
      fake_movie = mock('Movie', :title => 'Fake Movie')
      Movie.stub(:find).with(@id.to_s).and_return(fake_movie)
      get :show, {:id => @id}
      assigns(:movie).should == fake_movie
    end
  end
  describe "GET show" do # ***
    it "assigns the requested movie as @movie" do
      movie = Movie.create! valid_attributes
      get :show, {:id => movie.to_param}, valid_session
      assigns(:movie).should eq(movie)
    end
  end
  describe '#new' do
      it 'should render new template' do
      get :new, {:id => @id}
      response.should render_template('new')
    end
  end
  # Not applicable with rottenpotatoes
  #describe "GET new" do # ***
  #  it "assigns a new movie as @movie" do
  #    get :new, {}, valid_session
  #    assigns(:movie).should be_a_new(Movie)
  #  end
  #end
  describe "GET edit" do # ***
    it "assigns the requested movie as @movie" do
      movie = Movie.create! valid_attributes
      get :edit, {:id => movie.to_param}, valid_session
      assigns(:movie).should eq(movie)
    end
  end
  describe '#create' do
    it 'should redirect to movies index page' do
      fake_movie = mock('Movie', :title => 'Kamote')
      Movie.stub(:create!).and_return(fake_movie)
      post :create, {:movie => {'title' => 'Fake Movie'}}
      response.should redirect_to(movies_path)
    end
  end
  describe "POST create" do # ***
    describe "with valid params" do
      it "creates a new Movie" do
        expect {
          post :create, {:movie => valid_attributes}, valid_session
        }.to change(Movie, :count).by(1)
      end

      it "assigns a newly created movie as @movie" do
        post :create, {:movie => valid_attributes}, valid_session
        assigns(:movie).should be_a(Movie)
        assigns(:movie).should be_persisted
      end

      it "redirects to the created movie" do
        post :create, {:movie => valid_attributes}, valid_session
        response.should redirect_to(movies_path) # I modified this from Movie.last to movies_path
      end
    end

    #describe "with invalid params" do
    #  it "assigns a newly created but unsaved movie as @movie" do
    #    # Trigger the behavior that occurs when invalid params are submitted
    #    Movie.any_instance.stub(:save).and_return(false)
    #    post :create, {:movie => {}}, valid_session
    #    assigns(:movie).should be_a_new(Movie)
    #  end

    #  it "re-renders the 'new' template" do
    #    # Trigger the behavior that occurs when invalid params are submitted
    #    Movie.any_instance.stub(:save).and_return(false)
    #    post :create, {:movie => {}}, valid_session
    #    response.should render_template("new")
    #  end
    #end
  end

  describe "PUT update" do # ***
    describe "with valid params" do
      it "updates the requested movie" do
        movie = Movie.create! valid_attributes
        # Assuming there are no other movies in the database, this
        # specifies that the Movie created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Movie.any_instance.should_receive(:update_attributes!).with({'these' => 'params'}) # I changed :update_attributes to :update_attributes!
        put :update, {:id => movie.to_param, :movie => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested movie as @movie" do
        movie = Movie.create! valid_attributes
        put :update, {:id => movie.to_param, :movie => valid_attributes}, valid_session
        assigns(:movie).should eq(movie)
      end

      it "redirects to the movie" do
        movie = Movie.create! valid_attributes
        put :update, {:id => movie.to_param, :movie => valid_attributes}, valid_session
        response.should redirect_to(movie)
      end
    end

    #describe "with invalid params" do
    #  it "assigns the movie as @movie" do
    #    movie = Movie.create! valid_attributes
    #    # Trigger the behavior that occurs when invalid params are submitted
    #    Movie.any_instance.stub(:save).and_return(false)
    #    put :update, {:id => movie.to_param, :movie => {}}, valid_session
    #    assigns(:movie).should eq(movie)
    #  end

    #  it "re-renders the 'edit' template" do
    #    movie = Movie.create! valid_attributes
    #    # Trigger the behavior that occurs when invalid params are submitted
    #    Movie.any_instance.stub(:save).and_return(false)
    #    put :update, {:id => movie.to_param, :movie => {}}, valid_session
    #    response.should render_template("edit")
    #  end
    #end
  end
  describe "DELETE destroy" do # ***
    it "destroys the requested movie" do
      movie = Movie.create! valid_attributes
      expect {
        delete :destroy, {:id => movie.to_param}, valid_session
      }.to change(Movie, :count).by(-1)
    end

    it "redirects to the movies list" do
      movie = Movie.create! valid_attributes
      delete :destroy, {:id => movie.to_param}, valid_session
      response.should redirect_to(movies_url)
    end
  end
end
