class Article < ApplicationRecord
  belongs_to :user
  validates :title, :content, :category, presence: true
end
