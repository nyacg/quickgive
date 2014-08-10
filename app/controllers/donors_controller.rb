class DonorsController < ApplicationController
  # GET /donors/new
  # The UI page that's shown when a new donor is in the process is being created
  # So after clicking on a link sent to you via our twitter bot, this is the page
  # that asks you to log in with other social networks and Paypal
  def new
    # The URL to get back to this page so we can come back after authenticating
    # with other social networks
    back_here_url = url_for(controller: :donors, action: :new, campaign: params[:campaign ], amount: params[:amount])
    # Use SessionsController to authenticate with other social networks, passing
    # in the URL to come back here as the origin so they're redirected back here
    @twitter_url = "/auth/twitter?origin=#{CGI.escape back_here_url}"
    @facebook_url = "/auth/facebook?origin=#{CGI.escape back_here_url}"
    @facebook_url = "/auth/instagram?origin=#{CGI.escape back_here_url}"

    # The url to go to payments#create and pay
    donate_url = url_for(controller: :payments, action: :create, campaign: params[:campaign], amount: params[:amount], uid: current_user.id)
    # Use PaypalController to authenticate with Paypal, and immediately go to
    # the above URL and make a payment/donation once the authentication is
    # complete
    @paypal_url = "/paypal/authenticate?redirect=#{CGI.escape donate_url}"
  end
end
