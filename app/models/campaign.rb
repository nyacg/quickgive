class Campaign
  include MongoMapper::Document

  belongs_to :user
  belongs_to :charity
  many :payments
  key :title,       String
  key :event, String
  key :event_url, String
  key :location, String
  key :target, Float
  key :initial, Float
  key :strgoalamm, Float
  key :strgoaldesc, String
  key :slug,        String, required: true, indexed: true
  key :description, String
  timestamps!

  def id
    slug
  end

  def self.find(slug)
    first slug: slug
  end

  def total_raised
    payments.inject(0) { |sum, p| sum + p.amount.to_f }
  end

  many :payments

  def image_url
    image = Dir["public/data/#{slug}.*"].first.split("/").last
    "/data/#{image}"
  end
end
