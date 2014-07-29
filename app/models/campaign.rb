class Campaign
  include MongoMapper::Document

  belongs_to :user
  key :title,   String, required: true

  many :payments
end
