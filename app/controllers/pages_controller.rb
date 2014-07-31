class PagesController < ApplicationController
  def home
  end

  def handle_home
    session[:prefilled] = {
      name: params["searchbox1"],
      action: params["searchbox2"],
      charity: params["searchbox3"]
    }
    if authenticated?
      redirect_to new_campaign_path
    else
      redirect_to new_campaigner_path
    end
  end

  def dashboard
    require_authentication!
    @campaigns = current_user.campaigns
    @donations = current_user.payments
  end
end
