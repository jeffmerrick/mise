class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :book
  has_many :recipes, through: :book
  acts_as_tagger
  after_create :generate_book

  private

  def generate_book
    create_book
  end
end
