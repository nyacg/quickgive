# Control the initial Paypal authentication flow
class PaypalController < ApplicationController
  # This is the URL that's visited when we want to begin the Paypal authentication
  def authenticate
    # Require the user to be logged in
    require_authentication!

    # Initialise a new request to the PayPal API
    preapproval_request = PaypalAdaptive::Request.new

    # See 
    # https://developer.paypal.com/docs/classic/api/adaptive-payments/Preapproval_API_Operation/
    # for API documentation. Essentially, we make a "preapproval request" that gives
    # us some secret keys allowing us to make payments without explicit authorisation
    # from the user in the future.
    # TODO TODO TODO Change cancelUrl and ipnNotificationUrl to use Rails.root rather than
    # hardcoding an address to the app
    data = {
      "endingDate"=>(Time.now+364.days).strftime("%Y-%m-%dZ"),
      "startingDate"=>Time.now.strftime("%Y-%m-%dZ"),
      "maxTotalOfAllPayments"=>1000,
      "currencyCode"=>"GBP",  
      # The URL the user ends back at after the whole Paypal authentication
      "returnUrl" => params[:redirect], 
      "cancelUrl"=>"http://localhost:3000/paypal/cancelled",
      # See comments below
      "ipnNotificationUrl"=>"http://81.174.154.185:3000/paypal/ipn?uid=#{current_user.id}",
      "requestEnvelope" => {"errorLanguage" => "en_US"},
      "actionType"=>"PREAPPROVAL"
    }
    puts data.inspect
    # Submit the preapproval request to Paypal
    preapproval_response = preapproval_request.preapproval(data)

    # Assuming the preapproval request was successful
    if preapproval_response.success?
      # Redirect to the URL paypal has given us. This is a page on Paypal's site that
      # makes sure the user is logged into Paypal and then gets them to authorise
      # us to take payments in the future. Once this is done, they're redirected back
      # to returnUrl from above (which is params[:redirect])
      # Once the user has authenticated on Paypal's site, they send us an "IPN"
      # This goes to ipnNotificationUrl above, which is a request made from Paypal directly
      # to us (so the Rails instance has to be public-facing; no localhost) that gives us
      # the relevant secret keys we need to make payments
      redirect_to preapproval_response.preapproval_paypal_payment_url
    else
      # If there are errors for some reason, display them
      puts preapproval_response.errors.first['message']
      # TODO Does paypal/failed do anything useful?
      redirect_to "/paypal/failed"
    end
  end

  # See comments above
  # Essentially: a request is made to here from Paypal's backend, and we need to store
  # soem of the data they send us
  def ipn
    # Output everything they send us for debugging purposes
    puts params.inspect

    # Find the user that's authenticated with paypal
    user = User.find params[:uid]
    # Save their paypal email address and the super-important super-secret magic payment key
    user.paypal_email = params[:sender_email]
    user.paypal_preapproval_key = params[:preapproval_key]
    user.save

    # This is *not* the user - this is Paypal's backend - so don't redirect to
    # the URL we redirect the user to
    # redirect_to params[:redirect]
  end 
end
