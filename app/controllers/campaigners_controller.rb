class CampaignersController < ApplicationController
  # GET /campaigners/new
  # campaigners/new.html.erb
  def new
    @campaigner = Campaigner.new
  end

  # POST /campaigners
  # {
  #   email: hrickards@gmail.com,
  #   password: test
  # }
  def create
    @campaigner = Campaigner.new params[:campaigner]
    if @campaigner.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  # POST /campaigners/add_donor
  # Add to current user
  def add_donor
    @campaigner = current_user
    @campaigner.donors += Donor.find params[:donor]
    if @campaigner.save
      redirect_to root_path
    else
      message = "Error(s): " + @campaigner.errors.map {|k,v| "#{k}: #{v}"}.join(",")
      redirect_to root_path, flash: {error: message}
    end
  end
end
