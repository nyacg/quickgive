class PaypalController < ApplicationController
  def authenticate
    redirect_to (params[:redirect] || root_path)
  end
end
