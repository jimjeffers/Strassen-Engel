class ArticlesController < ApplicationController
  before_filter :check_for_current_user
  before_filter :get_districts
  before_filter :set_title
  
  # GET /articles
  def index
    flash[:notice] = "<h2>Share A Story With Us</h2><p>Share with us an experience you have had with a 
    homeless person that interested you. Tell us about a good deed. Tell us about something you saw.. 
    or just tell us their story. Share their voice with us.</p><p>Also, you may <a href=\"#{articles_path}\">view past stories you have written.</a></p>"
    @articles = current_user.articles
  end

  # GET /articles/1
  def show
    @article = current_user.articles.find(params[:id])
  end

  # GET /articles/new
  def new
    flash[:notice] = "<h2>Share A Story With Us</h2><p>Share with us an experience you have had with a 
    homeless person that interested you. Tell us about a good deed. Tell us about something you saw.. 
    or just tell us their story. Share their voice with us.</p><p>Also, you may <a href=\"#{articles_path}\">view past stories you have written.</a></p>"
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
    @article = current_user.articles.find(params[:id])
    flash[:notice] = "<h2>Editing &quot;#{@article.name}&quot;</h2><p>You are currently editing a story you have
    submitted to strassen engel. If you don't wish to make changes you may <a href=\"#{articles_path}\">view other stories you have written.</a></p>"
  end

  # POST /articles
  def create
    @article = Article.new(params[:article])
    @article.user = current_user
    
    if @article.save
      flash[:notice] = '<h2>Awesome! You\'re Almost Done!</h2><p>Your article is getting published we just need you to confirm the photo.</p>'
      if params[:article][:avatar].blank?
        redirect_to(articles_url)
      else
        render :action => 'cropping'
      end
    else
      render :action => 'new'
    end
  end

  # PUT /articles/1
  def update
    @article = current_user.articles.find(params[:id])
    if @article.update_attributes(params[:article])
      flash[:notice] = '<h2>Success!</h2><p>Article was successfully updated.</p>'
      if params[:article][:avatar].blank?
        redirect_to(articles_url)
      else
        render :action => 'cropping'
      end
    else
      render :action => "edit"
    end
  end

  
  # DELETE /articles/1
  def destroy
    @article = current_user.articles.find(params[:id])
    @article.destroy

    redirect_to(articles_url)
  end
  
  protected
  
  def set_title
    @title = "Share A Story"
  end
  
end
