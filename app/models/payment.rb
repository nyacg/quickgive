# A donation to a campaign
class Payment
  include MongoMapper::Document

  # After the donation is made, take the payment via PayPal and notify the user
  # to tell them we've made the payment!
  after_save :notify_user
  after_save :pay

  # The user that made the donation
  belongs_to :user
  # The campaign the donation was made to
  belongs_to :campaign

  key :amount,  Float,  required: true
  key :time,    Time,   required: true
  key :via,     String

  # TODO Update this text
  # Tell the user we've taken their payment
  def notify_user
    # See the User model for implementation of user.notify
    user.notify "Your donation of £#{amount} to #{campaign.title} (http://quickgive.rckrds.uk#{Rails.application.routes.url_helpers.campaign_path campaign}) was successful!"
  end

  # Return the campaign that the donation was made to
  # TODO Shouldn't this be done automatically by MongoMapper?
  def campaign
    Campaign.find campaign_id
  end

  # Take the payment
  def pay
    # Create a new Paypal payments API request
    pay_request = PaypalAdaptive::Request.new

    # Look at the Paypal API docs (they're hidden deep on the web) for more info
    # user.paypal_preapproval_key is the supersecret string that lets us
    # authenticate with Paypal to actually take the payment
    # user.paypal_email tells Paypal which account we're taking money from
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
    # Make the payment
    pay_response = pay_request.pay(data)
    # Print out the response we get from the PayPal API so we know for debugging
    # purposes that everything has gone through correctly
    puts pay_response.inspect
  end
end
