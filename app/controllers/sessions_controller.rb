class SessionsController < ApplicationController
  # POST /sessions/create
  # {
  #   email: hrickards@gmail.com
  # }
  def create
    @campaigner = Campaigner.first email: params[:email]
    if @campaigner.nil?
      redirect_to root_path, flash: {error: "Invalid email address"}
    else
      authenticate @campaigner
      redirect_to root_path
    end
  end

  # GET /sessions/destroy
  def destroy
    deauthenticate
    redirect_to root_path
  end
end
