class CityController < ApplicationController
  before_filter :get_districts
  
  def index
    flash.now[:notice] = "<img src=\"/images/message_welcome.png\" width=\"500\" height=\"40\" alt=\"Message Welcome\">
    <p>This site is dedicated to revealing the interesting and positive aspects of the people we walk past  on the street every day. The homeless. Have you had an interesting encounter with a homeless person in your area? Have you done a good gesture  that had an impact on their lives? Did it impact your life? <a href=\"#\">Share your story with the rest of the world here.</a></p>"
  end
  
  def login
    flash[:notice] = "<p>Sorry you must be signed in to do this! Please sign in with one of the following services.</p>"
  end
  
  private
  
  def get_districts
    @districts = Distrct.sorted
  end
end
