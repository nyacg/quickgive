class Donor
  include MongoMapper::Document

  many :payments
  belongs_to :campaigner
  key :service,           String
  key :username,          String

  def donate(campaign, amount)
    Payment.create donor: self, campaign: campaign, amount: amount, time: Time.now
  end

  def self.find_by_twitter_username(username)
    first service: "twitter", username: username
  end
end
