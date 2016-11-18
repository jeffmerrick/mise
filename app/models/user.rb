class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_tagger

  belongs_to :book
  has_many :recipes, through: :book

  before_create :generate_book

  private

  def generate_book
    create_book(user_id: id)
  end
end
