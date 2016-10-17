class Recipe < ActiveRecord::Base
  belongs_to :user
  
  def self.search(search)
    where("description ILIKE ? OR name ILIKE ?", "%#{search}%", "%#{search}%") 
  end
end
