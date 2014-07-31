class Payment
  include MongoMapper::Document

  after_save :notify_user

  belongs_to :user
  belongs_to :campaign
  key :amount,  Float,  required: true
  key :time,    Time,   required: true

  def notify_user
    user.notify "Your donation of £#{amount} to #{campaign.title} was successful!"
  end

  def campaign
    Campaign.find campaign_id
  end
end
