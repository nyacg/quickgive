# As the name suggests, a campaign
class Campaign
  include MongoMapper::Document

  # The user that made the campaign
  belongs_to :user
  # The charity that the campaign is for
  belongs_to :charity

  # Donations made to the campaign
  many :payments

  # Metadata
  key :title,       String
  key :event, String
  key :event_url, String
  key :location, String
  key :target, Float
  key :initial, Float
  # Stretch goal amount
  key :strgoalamm, Float
  # Stretch goal description
  key :strgoaldesc, String
  key :slug,        String, required: true, indexed: true
  key :description, String
  timestamps!

  # Override the default of using long alphanumeric generated Mongo IDs and
  # instead use the human slugs (generated in CampaignsController)
  def id
    slug
  end

  # We also have to override find to use slugs rather than the default Mongo
  # IDs
  def self.find(slug)
    first slug: slug
  end

  # Sum up all of the donations made to the campaign
  def total_raised
    payments.inject(0) { |sum, p| sum + p.amount.to_f }
  end

  # A link to the campaign photo
  def image_url
    # It's just stored in public/data/slug.jpg or whatever the relevant file
    # extension is
    image = Dir["public/data/#{slug}.*"].first.split("/").last
    # That's accessed publicly over the website as /data/slug.jpg or whatever
    "/data/#{image}"
  end
end
