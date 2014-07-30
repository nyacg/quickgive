class Campaign
  include MongoMapper::Document

  belongs_to :campaigner
  key :title,   String, required: true
  key :slug,    String, required: true

  many :payments
end
