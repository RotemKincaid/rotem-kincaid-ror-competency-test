class ArticlesController < ApplicationController
  allow_unauthenticated_access only: [:index]

  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # Guests:
  # - can see index
  # - must login to see show
  before_action :require_login!, only: [:show]

  # Editors only:
  before_action :require_login!, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_editor!, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_owner!, only: [:edit, :update, :destroy]

  def index
    @articles = Article.order(created_at: :desc)
  end

  def show; end

  def new
    @article = current_user.articles.build
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to @article, notice: "Article created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "Article deleted."
  end

  private

  def require_login!
    # Rails 8 auth generator usually gives you `Current.user`
    # If your app has `current_user` helper already, keep using it.
    redirect_to new_session_path, alert: "Please log in." unless current_user
  end

  def require_editor!
    redirect_to root_path, alert: "Not authorized." unless current_user&.editor_role?
  end

  def require_owner!
    redirect_to articles_path, alert: "Not authorized." unless @article.user_id == current_user.id
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :category)
  end
end
