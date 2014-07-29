class Campaigner
  include MongoMapper::Document

  many :campaigns
  key :email, String, required: true, unique: true
end
