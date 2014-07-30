class CampaignsController < ApplicationController
  # POST /campaigns
  def create
    require_authentication!

    @campaign = Campaign.new params[:campaign]
    if @campaign.save
      redirect_to campaign_path(@campaign)
    else
      render 'new'
    end
  end

  # GET /campaigns/new
  def new
    require_authentication!
    @campaign = Campaign.new
  end

  # GET /campaigns/:campaign_id
  def show
    @campaign = Campaign.find params[:id]
    if authenticated?
      render :show
    else
      render :show_donor
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
