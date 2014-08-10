# An authentication method that allows the user to use a good ol'
# email address and password
class PasswordAuthentication < Authentication
  include MongoMapper::Document

  belongs_to :user

  key :email,         String, required: true, unique: true
  # Basic password security by hashing/salting
  key :password_hash, String
  key :password_salt, String

  # password is not actually a database field, but this line lets us do things
  # like
  #   user.password = "foo"
  attr_accessor :password

  # Before a user is saved to the database, encrypt their password
  before_save :encrypt_password
  # Check that a password is present before we attempt to save
  # TODO: Only do this initially, otherwise we can't update other user data
  # without changing/reentering the password!
  validates_presence_of :password

  # Given an email address and a password, find the user corresponding to that
  # email address and check their password is valid
  def self.authenticate(email, password)
    # Find the relevant user
    authentication = first email: email
    # Check the relevant user exists (i.e., not nil) and that when we hash
    # their password with the stored salt we get the stored hash (i.e., their
    # password is correct)
    if authentication && authentication.password_hash == BCrypt::Engine.hash_secret(password, authentication.password_salt)
      authentication.user
    else
      nil
    end
  end

  # Before a user is saved, encrypt their password
  def encrypt_password
    # It should be, because we're validating it's presence!
    if password.present?
      # Generate a salt we'll use to hash the password
      self.password_salt = BCrypt::Engine.generate_salt
      # Actually hash the password
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
