# An authentication for when the user signs in with instagram
# TODO: Implement this. It does nothing at the moment!
class InstagramAuthentication < Authentication
  include MongoMapper::Document

  belongs_to :user

  key :uid, String, required: true
end
