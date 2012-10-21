class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default

    @saved_sort = session[:sort]
    @saved_ratings = session[:ratings]
  end

  def index
    if params[:ratings].nil?
        params[:ratings] = Hash[*Movie.get_ratings(nil).select { |r| r[:checked] }.map { |r| [ r[:rating], '1' ] }.flatten ]
    end

    keys = params[:ratings].keys

    @movies = Movie.all(:order => params[:sort], :conditions => { :rating => keys })
    instance_variable_set("@#{params[:sort]}_hilite", 'hilite')

    @all_ratings = Movie.get_ratings(keys)

    session[:sort] = params[:sort]
    session[:ratings] = params[:ratings]
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
