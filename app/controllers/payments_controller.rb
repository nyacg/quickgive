class PaymentsController < ApplicationController
  def create
    require_authentication!

    payment = Payment.new amount: params[:amount].to_f, time: Time.now, campaign: Campaign.find(params[:campaign]), user: current_user
    @successful = payment.save

    redirect_to "/pages/dashboard" if @successful
  end
end
