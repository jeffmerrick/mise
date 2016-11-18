class Book < ActiveRecord::Base
  has_many :users
  has_many :recipes
  belongs_to :owner, foreign_key: "user_id", class_name: "User"
end
