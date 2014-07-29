class Authentication
  include MongoMapper::Document

  belongs_to :user
  key :service,   String, required: true
  key :username,  String, required: true
end
