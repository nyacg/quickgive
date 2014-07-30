class CampaignersController < ApplicationController
  # GET /campaigners/new
  # campaigners/new.html.erb
  def new
  end

  # POST /campaigners
  # {
  #   email: hrickards@gmail.com,
  #   password: test
  # }
  def create
    @campaigner = Campaigner.new email: params[:email], password: params[:password], first_name: params[:first_name], last_name: params[:last_name]
    if @campaigner.save
      redirect_to root_path
    else
      message = "Error(s): " + @campaigner.errors.map {|k,v| "#{k}: #{v}"}.join(",")
      redirect_to root_path, flash: {error: message}
    end
  end
end
