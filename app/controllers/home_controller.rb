class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    categories = Article.distinct.pluck(:category)
    @articles_by_category = categories.to_h do |cat|
      [ cat, Article.where(category: cat).order(created_at: :desc).limit(3) ]
    end
  end
end
