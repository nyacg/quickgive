class PagesController < ApplicationController
  def home
    redirect_to url_for(action: :dashboard) if authenticated?
  end

  def dashboard
    require_authentication!
    @campaigns = current_user.campaigns
  end
end
