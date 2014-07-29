class CampaignsController < ApplicationController
  # POST /campaigns
  def create
    require_authentication!

    @campaign = Campaign.new title: params[:title], campaigner: current_user
    if @campaign.save
      redirect_to campaign_path(@campaign)
    else
      message = "Error(s): " + @campaign.errors.map {|k,v| "#{k}: #{v}"}.join(",")
      redirect_to new_campaign_path, flash: {error: message}
    end
  end

  # GET /campaigns/:campaign_id
  def show
    if authenticated?
      render :show_donor
    else
      render :show
    end
  end

  # GET /campaigns/:campaign_id/edit
  def edit
    @campaign = Campaign.find params[:id]
  end

  # PUT /campaigns/:campaign_id
  def update
    # TODO
  end

  # GET /campaigns/:campaign_id/share
  def share
    @campaign = Campaign.find params[:id]
  end

  # GET /campaigns/:campaign_id/analysis
  def analysis
    @campaign = Campaign.find params[:id]
  end
end
