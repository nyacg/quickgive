class CampaignersController < ApplicationController
  def new
  end

  def create
    campaigner = Campaigner.create email: params[:email]

    render json: {status: "Successful"}
  end
end
