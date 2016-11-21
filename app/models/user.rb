class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :book, dependent: :destroy
  has_many :book_users, dependent: :delete_all
  has_many :books, through: :book_users

  after_create do
    Book.create(user: self)
  end
end
