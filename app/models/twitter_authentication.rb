class TwitterAuthentication < Authentication
  include MongoMapper::Document

  belongs_to :user

  key :username, String, required: true
end
