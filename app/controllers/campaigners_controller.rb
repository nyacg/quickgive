class CampaignersController < ApplicationController
  # GET /campaigners/new
  # campaigners/new.html.erb
  def new
    @campaigner = User.new_campaigner
    @campaigner.authentications = [PasswordAuthentication.new]

    if session.include? :prefilled
      @name = session[:prefilled]["name"]
    else
      @name = nil
    end
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
      if session.include? :prefilled
        redirect_to new_campaign_path
      else
        redirect_to root_path
      end
    else
      raise @campaigner.errors.inspect
      render 'new'
    end
  end
end
