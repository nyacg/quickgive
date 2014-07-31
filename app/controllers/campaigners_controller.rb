class CampaignersController < ApplicationController
  # GET /campaigners/new
  # campaigners/new.html.erb
  def new
    @campaigner = User.new_campaigner
    @campaigner.authentications = [PasswordAuthentication.new]
  end

  # POST /campaigners
  # {
  #   email: hrickards@gmail.com,
  #   password: test
  # }
  def create
    authentication = PasswordAuthentication.new params[:user].delete(:authentications)
    @campaigner = User.new_campaigner params[:user]
    @campaigner.authentications = [authentication]
    if @campaigner.save
      authenticate @campaigner
      redirect_to root_path
    else
      raise @campaigner.errors
      render 'new'
    end
  end
end
