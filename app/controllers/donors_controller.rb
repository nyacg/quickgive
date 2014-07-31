class DonorsController < ApplicationController
  # POST /donors/create
  def create
    # raise params.inspect
    # @donor = Donor.new service: :twitter, username: params[:twitter]
    # if @donor.save
      # redirect_to root_path
    # else
      # message = "Error(s): " + @donor.errors.map {|k,v| "#{k}: #{v}"}.join(",")
      # redirect_to root_path, flash: {error: message}
    # # end
  end

  # GET /donors/new
  def new
    back_here_url = url_for(controller: :donors, action: :new, campaign: params[:campaign ], amount: params[:amount])
    @twitter_url = "/auth/twitter?origin=#{CGI.escape back_here_url}"
    @facebook_url = "/auth/facebook?origin=#{CGI.escape back_here_url}"
    @facebook_url = "/auth/instagram?origin=#{CGI.escape back_here_url}"

    donate_url = url_for(controller: :payments, action: :create, campaign: params[:campaign], amount: params[:amount])
    @paypal_url = "/paypal/authenticate?redirect=#{CGI.escape donate_url}"
  end
end
