class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_tagger

  belongs_to :book, autosave: true
  delegate :recipes, to: :book

  before_save :create_book
  after_create :make_book_owner

  private

  def make_book_owner
    book.update_attributes(user_id: id)
  end
end
