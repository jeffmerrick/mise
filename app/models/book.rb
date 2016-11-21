class Book < ActiveRecord::Base
  belongs_to :user
  has_many :book_users, dependent: :delete_all
  has_many :users, through: :book_users
  has_many :recipes, dependent: :delete_all
  acts_as_tagger

  after_create do
    user.books << self
  end
  
end
