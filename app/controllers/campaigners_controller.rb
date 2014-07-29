class CampaignersController < ApplicationController
  # GET /campaigners/new
  # campaigners/new.html.erb
  def new
  end

  # POST /campaigners
  # {
  #   email: hrickards@gmail.com
  # }
  def create
    @campaigner = Campaigner.new email: params[:email]
    if @campaigner.save
      redirect_to root_path
    else
      message = "Error(s): " + @campaigner.errors.map {|k,v| "#{k}: #{v}"}.join(",")
      redirect_to root_path, flash: {error: message}
    end
  end
end
