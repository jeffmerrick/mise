class Recipe < ActiveRecord::Base
  def self.search(search)
    where("description ILIKE ? OR name ILIKE ?", "%#{search}%", "%#{search}%") 
  end
end
