class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @selected_ratings = @all_ratings
    if params[:ratings]
      session[:ratings] = params[:ratings]
      @selected_ratings = params[:ratings].keys
    elsif session[:ratings]
      restful_redirect = true
      @selected_ratings = session[:ratings].keys
    end
    @movies = Movie.where(:rating => @selected_ratings)
    if params.has_key? :sort
      session[:sort] = params[:sort]
      @movies = @movies.find(:all, :order => params[:sort])
      @sort = params[:sort]
    elsif session[:sort]
      restful_redirect = true
      @sort = session[:sort]
    end
    if restful_redirect
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
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
