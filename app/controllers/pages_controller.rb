class PagesController < ApplicationController
  # The main homepage with the static 'quick' form on
  def home
  end

  # The action that data is POSTed to from that form on the main
  # homepage
  def handle_home
    # Store data in that form in the session so we can prefill it into
    # forms in the future
    session[:prefilled] = {
      name: params["searchbox1"],
      action: params["searchbox2"],
      charity: params["searchbox3"]
    }

    # If the user's logged in, create a new campaign otherwise redirect them
    # to the signup page
    if authenticated?
      redirect_to new_campaign_path
    else
      redirect_to new_campaigner_path
    end
  end

  # The dashboard page
  def dashboard
    # Make sure the user's logged in
    require_authentication!

    # Campaigns the current user has created
    @campaigns = current_user.campaigns
    # Donations the current user has made
    @donations = current_user.payments
  end
end
