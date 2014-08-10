# An authentication for when the user signs in with facebook
class FacebookAuthentication < Authentication
  include MongoMapper::Document

  belongs_to :user

  # A unique user ID we get from Facebook
  key :uid, String, required: true
  # An oauth token the FB API gives us that we can use to access the user's
  # Facebook account in the future
  # TODO: Do this ever expire and what should we do if it does?
  key :access_token, String
end
