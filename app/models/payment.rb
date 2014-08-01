class Payment
  include MongoMapper::Document

  after_save :notify_user
  after_save :pay

  belongs_to :user
  belongs_to :campaign
  key :amount,  Float,  required: true
  key :time,    Time,   required: true
  key :via,     String

  def notify_user
    user.notify "Your donation of £#{amount} to #{campaign.title} (http://quickgive.rckrds.uk#{Rails.application.routes.url_helpers.campaign_path campaign}) was successful!"
  end

  def campaign
    Campaign.find campaign_id
  end

  def pay
    pay_request = PaypalAdaptive::Request.new

    data = {
      "actionType" => "PAY",
      "currencyCode" => "GBP",
      "feesPayer" => "EACHRECEIVER",
      "memo" => "Donation",
      "preapprovalKey" => user.paypal_preapproval_key,
      "receiverList" => {"receiver" => [{"email" => "hrickards+business@gmail.com", "amount" => amount}]},
      "senderEmail" => user.paypal_email,
      "requestEnvelope" => {"errorLanguage" => "en_US"},
      "returnUrl" => "http://localhost:3000/paypal/completed", 
      "cancelUrl"=>"http://localhost:3000/paypal/cancelled"
    }
    pay_response = pay_request.pay(data)
    puts pay_response.inspect
  end
end
