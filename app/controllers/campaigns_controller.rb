class CampaignsController < ApplicationController
  # POST /campaigns
  def create
    require_authentication!

    values = params[:campaign]
    values[:slug] = values[:title].parameterize
    values[:date] = Chronic.parse values[:date]
  
    @campaign = Campaign.new values
    @campaign.user = current_user
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

    @prefilled = session.delete(:prefilled) || {name: nil, action: nil, charity: nil}
  end

  # GET /campaigns/:campaign_id
  def show
    @campaign = Campaign.find params[:id]
    @strgoaldesc = @campaign.strgoaldesc
    @strgoaldesc[0] = @strgoaldesc[0].downcase
    if @campaign.user == current_user
      render :show_owner
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
