class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @sort_column ||= []
    @sort_column = params[:sort_by]
    @rating_one ||= []
    @rating_one= params[:ratings]
    redirect = false
  
    
    if params[:ratings]
      session[:ratings] = @rating_one
    elsif session[:ratings]
      @rating_one = session[:ratings]
      redirect = true
    else @rating_one = nil
    end
     if params[:sort_by]
      session[:sort_by] = @sort_column
    elsif session[:sort_by]
      @sort_column = session[:sort_by]
      redirect = true
    else @sort_column = nil
     end

    if redirect
      flash.keep
      redirect_to movies_path :sort_by => @sort_column, :ratings => @rating_one
    end
    
  if @sort_column and @rating_one
    @movies =  Movie.where(:rating => @rating_one.keys).order(@sort_column)
  elsif  @sort_column  
      @movies = Movie.order(@sort_column)
    elsif @rating_one
      @movies = Movie.where(:rating => @rating_one.keys)
    else @movies =Movie.all
  end
  
  if @sort_column == "title" 
    @title_class = "hilite"
  elsif @sort_column == "release_date"
     @release_date_class = "hilite"
  end
  
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
