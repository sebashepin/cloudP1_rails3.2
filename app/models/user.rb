class User 
  include Dynamoid::Document
  #lets see if this next line doesnt fuck up
  #attr_accessible :name, :email, :password, :password_confirmation
  field :name
  field :email
  field :password
  field :password_confirmation
  field :remember_token
  field :video_ids
  has_many :videos, dependent: :destroy
  #before_save { self.email = email.downcase }

  before_create :create_remember_token
  #validates :name,  presence: true, length: { maximum: 50 }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  #                  uniqueness: { case_sensitive: false }
  #has_secure_password
  #validates :password, length: { minimum: 6 }  
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
