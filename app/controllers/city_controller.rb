class CityController < ApplicationController
  before_filter :get_districts
  
  def index
    flash[:notice] = "<img src=\"/images/message_welcome.png\" width=\"500\" height=\"40\" alt=\"Message Welcome\">
    <p>This site is dedicated to revealing the interesting and positive aspects of the people we walk past  on the street every day. The homeless. Have you had an interesting encounter with a homeless person in your area? Have you done a good gesture  that had an impact on their lives? Did it impact your life? <a href=\"#\">Share your story with the rest of the world here.</a></p>"
    @articles = Article.recent
  end
  
  def login
    flash[:notice] = "<h2>Whoops!</h2><p>Sorry you must be signed in to do this! Please sign in with one of the following services.</p>"
  end
  
  def district
    @district = District.find_by_slug(params[:slug])
    @title = @district.name
    @articles = @district.articles.recent
    flash.now[:notice] = "<h2>Viewing Stories From #{@district.name}</h2>
    <p>This site is dedicated to revealing the interesting and positive aspects of the people we walk past  on the street every day. The homeless. Have you had an interesting encounter with a homeless person in your area? Have you done a good gesture  that had an impact on their lives? Did it impact your life? <a href=\"#\">Share your story with the rest of the world here.</a></p>"
  end
end
