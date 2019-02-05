class User < ApplicationRecord
  before_create :set_authencitation_token, :create_encrypted_password

  validates :email, :username, :password, presence: true
  validates_uniqueness_of :username

  has_many :owned_lists, class_name: 'List', foreign_key: 'created_by'
  has_many :owned_cards, class_name: 'Card', foreign_key: 'created_by'

  has_many :list_users, dependent: :destroy
  has_many :lists, through: :list_users

  enum role: [ :admin, :user ]


  def set_authencitation_token
    self.token = generate_api_key
  end

  # Generate a unique API key
  def generate_api_key
    loop do
      authentication_token = SecureRandom.base64.tr('+/=', 'Qrt')
      break authentication_token unless User.exists?(token: authentication_token)
    end
  end


  def create_encrypted_password
    self.password = Digest::MD5.hexdigest(self.password)
  end

  def authenticate_user user_password
    Digest::MD5.hexdigest(user_password) == password
  end


  def user_lists(params)
    start = params[:start] || 0
    limit = params[:limit] || 0
    if self.admin?
      owned_lists.offset(start).limit(10)
    else
      lists.offset(start).limit(10)
    end
  end

  def user_cards(params)
    start = params[:start] || 0
    limit = params[:limit] || 0
    owned_cards.offset(start).limit(10)
  end

end
