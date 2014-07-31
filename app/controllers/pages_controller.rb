class PagesController < ApplicationController
  def home
  end

  def dashboard
    require_authentication!
    @campaigns = current_user.campaigns
    @donations = current_user.payments
  end
end
