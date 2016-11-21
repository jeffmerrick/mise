class Recipe < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  acts_as_taggable_on :tags, :categories

  before_create do
    self.user = book.user
  end  

  def self.search(search)
    where("description ILIKE ? OR name ILIKE ?", "%#{search}%", "%#{search}%") 
  end

end
