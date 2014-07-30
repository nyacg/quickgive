class Campaign
  include MongoMapper::Document

  belongs_to :user
  key :title,       String, required: true
  key :slug,        String, required: true, indexed: true
  key :description, String

  def id
    slug
  end

  def self.find(slug)
    first slug: slug
  end

  many :payments
end
