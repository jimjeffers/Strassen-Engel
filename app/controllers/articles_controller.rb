class ArticlesController < ApplicationController
  before_filter :check_for_current_user
  
  # GET /articles
  def index
    @articles = Article.find(:all)
  end

  # GET /articles/1
  def show
    @article = Article.find(params[:id])
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  def create
    @article = Article.new(params[:article])

    if @article.save
      flash[:notice] = 'Article was successfully created.'
      if params[:article][:avatar].blank?
        redirect_to(@article)
      else
        render :action => 'cropping'
      end
    else
      render :action => 'new'
    end
  end

  # PUT /articles/1
  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      flash[:notice] = 'Article was successfully updated.'
      if params[:article][:avatar].blank?
        redirect_to(@article)
      else
        render :action => 'cropping'
      end
    else
      render :action => "edit"
    end
  end

  
  # DELETE /articles/1
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to(articles_url)
  end
  
end
