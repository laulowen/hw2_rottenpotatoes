class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session[:ratings] ||= {}

    session[:order] = @order_attribute = params.has_key?(:order) ? params[:order] : session[:order]
    session[:ratings] = @selected_ratings = params.has_key?(:ratings) ? params[:ratings] : session[:ratings]

    if (@selected_ratings.empty?)
      @movies = []
    else
      @movies = Movie.order(@order_attribute).where(:rating => @selected_ratings.keys).all
    end

    @title_header_class = @order_attribute == 'title' ? 'hilite' : 'normal'
    @release_date_header_class = @order_attribute == 'release_date' ? 'hilite' : 'normal'

    @all_ratings = Movie.all_ratings

    if (session[:order] && !params.has_key?(:order))
      flash.keep
      redirect_to movies_path(:order => @order_attribute, :ratings => @selected_ratings)
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
