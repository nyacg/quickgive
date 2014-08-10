# An authentication for when the user signs in with twitter
class TwitterAuthentication < Authentication
  include MongoMapper::Document

  # The user that's logged in
  belongs_to :user

  # A unique user ID we get from the Twitter API
  key :uid, String, required: true

  # Use the Twitter API to find out a user's human-readable
  # Twitter handle
  def screen_name
    TWITTER_CLIENT.user(uid.to_i).screen_name
  end

  # Given a human-readable Twitter handle, return the machine UID (the thing
  # we store and use)
  def self.uid_of_screen_name(screen_name)
    TWITTER_CLIENT.user(screen_name).id
  end
end
