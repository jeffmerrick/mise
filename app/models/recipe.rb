class Recipe < ActiveRecord::Base
  belongs_to :book
  has_many :users, through: :book
  acts_as_taggable_on :tags, :categories
  
  def self.search(search)
    where("description ILIKE ? OR name ILIKE ?", "%#{search}%", "%#{search}%") 
  end

end
