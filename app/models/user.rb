class User
  include MongoMapper::Document

  many :authentications
  many :campaigns
  many :payments
end
