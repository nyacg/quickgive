class PaymentsController < ApplicationController
  # POST data to here to actually make a payment!
  def create
    # For obvious reasons, require the user to be logged in
    require_authentication!

    # Create a new Payment object with the relevant information,
    # and save that. The Payment model takes care of the rest
    payment = Payment.new amount: params[:amount].to_f, time: Time.now, campaign: Campaign.find(params[:campaign]), user: current_user
    @successful = payment.save

    # Redirect to the dashboard if the payment was successful.
    # If not, just show them views/payments/create.html.erb which is a basic
    # error page
    redirect_to "/pages/dashboard" if @successful
  end
end
