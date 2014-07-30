class Campaigner
  include MongoMapper::Document

  attr_accessor :password
  before_save :encrypt_password
  validates_presence_of :password

  many :campaigns
  many :donors
  key :email,         String, required: true, unique: true
  key :first_name,    String, required: true
  key :last_name,     String, required: true
  key :password_hash, String
  key :password_salt, String

  def self.authenticate(email, password)
    user = first email: email
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
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
