class FacebookAuthentication < Authentication
  include MongoMapper::Document

  belongs_to :user

  key :uid, String, required: true
end
