# Ways the user can login to the site, e.g., via password, twitter, etc.
# A general class that refers to all the different types; 
# `PasswordAuthentication`, `FacebookAuthentication`, `TwitterAuthentication`,
# `InstagramAuthentication` (just an empty skeleton at the moment) are child
# classes of `Authentication` that do the actual heavy lifting.

class Authentication
  include MongoMapper::Document

  # All of the implemented child classes store a UID (e.g. twitter user id)
  # Given this UID, we find a User with the corresponding UID and return them
  # Used to login users
  # Overriden by some (PasswordAuthentication) of the child classes
  def self.authenticate(uid)
    authentication = first uid: uid
    if authentication
      authentication.user
    else
      nil
    end
  end
end
