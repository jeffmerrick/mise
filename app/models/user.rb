class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :book, dependent: :destroy
  has_many :book_users, dependent: :delete_all
  has_many :books, through: :book_users

  before_create :generate_token

  after_create do
    Book.create(user: self)
  end

  protected

  def generate_token
    self.invite_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless User.exists?(invite_token: random_token)
    end
  end

end
