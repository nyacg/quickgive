class Donor
  include MongoMapper::Document

  many :payments
  belongs_to :campaigner
  key :service,           String
  key :username,          String

  def donate(campaign, amount)
    Payment.create donor: self, campaign: campaign, amount: amount, time: Time.now
  end
end
