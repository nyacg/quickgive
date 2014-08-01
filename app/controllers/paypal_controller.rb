class PaypalController < ApplicationController
  def authenticate
    require_authentication!

    preapproval_request = PaypalAdaptive::Request.new

    # https://developer.paypal.com/docs/classic/api/adaptive-payments/Preapproval_API_Operation/
    data = {
      "endingDate"=>(Time.now+364.days).strftime("%Y-%m-%dZ"),
      "startingDate"=>Time.now.strftime("%Y-%m-%dZ"),
      "maxTotalOfAllPayments"=>1000,
      "currencyCode"=>"GBP",  
      "returnUrl" => params[:redirect], 
      "cancelUrl"=>"http://localhost:3000/paypal/cancelled",
      "ipnNotificationUrl"=>"http://81.174.154.185:3000/paypal/ipn?uid=#{current_user.id}",
      "requestEnvelope" => {"errorLanguage" => "en_US"},
      "actionType"=>"PREAPPROVAL"
    }
    puts data.inspect
    preapproval_response = preapproval_request.preapproval(data)

    if preapproval_response.success?
      redirect_to preapproval_response.preapproval_paypal_payment_url
    else
      puts preapproval_response.errors.first['message']
      redirect_to "/paypal/failed"
    end
  end

  def ipn
    puts params.inspect

    user = User.find params[:uid]
    user.paypal_email = params[:sender_email]
    user.paypal_preapproval_key = params[:preapproval_key]
    user.save

    # redirect_to params[:redirect]
  end 
end
