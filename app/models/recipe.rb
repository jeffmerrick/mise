class Recipe < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  acts_as_taggable_on :tags, :categories
  validates :canonical_url, :url => {:allow_blank => true}
  
  before_create do
    self.user = book.user
  end  

  def self.search(search)
    where("description ILIKE ? OR name ILIKE ? OR ingredients ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%") 
  end
end
