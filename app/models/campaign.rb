class Campaign
  include MongoMapper::Document

  belongs_to :user
  many :payments
  key :title,       String, required: true
  key :slug,        String, required: true, indexed: true
  key :description, String

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
end
