class PasswordAuthentication < Authentication
  include MongoMapper::Document

  belongs_to :user

  key :email,         String, required: true, unique: true
  key :password_hash, String
  key :password_salt, String

  attr_accessor :password
  before_save :encrypt_password
  validates_presence_of :password

  def self.authenticate(email, password)
    authentication = first email: email
    if authentication && authentication.password_hash == BCrypt::Engine.hash_secret(password, authentication.password_salt)
      authentication.user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
