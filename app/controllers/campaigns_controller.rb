# Control campaigns
class CampaignsController < ApplicationController
  # POST /campaigns
  # Create a new campaign from data posted to us
  def create
    # Make sure someone's logged in
    require_authentication!

    # Data for the new campaign
    values = params[:campaign]
    # Create a slug from the event title
    # e.g. "Harry's marathon run" -> "harrysmarathonrun"
    values[:slug] = values[:event].parameterize.gsub "-", ""
    # Find the relevant Charity object from the charity title we have stored
    # Charity titles are fully uppercase in the database
    values[:charity] = Charity.find_by_title values[:charity].upcase

    # If an image was uplodaed
    if values.include? :image
      # Find the image extension by looking at everything after the last dot
      # in the filename
      extension =  values[:image].original_filename.split(".").last
      directory = "public/data"
      # Create a path to store the image in public/data/, with the slug
      # as the filename
      path = File.join("public/data", "#{values[:slug]}.#{extension}")
      # Open that path and write the image
      File.open(path, "wb") { |f| f.write(values[:image].read) }
      values.delete :image
    else
      # Otherwise if no image was uploaded, copy a placeholder image
      FileUtils.cp "public/data/placeholder.jpg", File.join("public/data", "#{values[:slug]}.jpg")
    end

    # Create a new campaign from the details above
    @campaign = Campaign.new values
    # Set the Campaign creator to the current user
    @campaign.user = current_user

    # Attempt to save the campaign
    if @campaign.save
      # If everything went well, redirect to the dashboard
      redirect_to "/pages/dashboard"
    else
      # Otherwise go back to the campaign creation page
      # TODO Make sure we're showing errors on that page
      render 'new'
    end
  end

  # GET /campaigns/new
  # Frontend page to create a new campaign
  def new
    # Make sure the user's logged in
    require_authentication!
    # Create a new empty Campaign object that we can use to populate the form
    # (because that's how Rails forms roll...)
    @campaign = Campaign.new

    # Get prefilled data from the front page form via the session, setting it all
    # to nil if we didn't story everything in the session
    @prefilled = session.delete(:prefilled) || {name: nil, action: nil, charity: nil}
    # Make sure the campaign action is cased properly ("harry's mountain marathon"
    # becomes "Harry's Mountain Marathon")
    @prefilled["action"] = @prefilled["action"].titleize unless @prefilled["action"].nil?
  end

  # GET /campaigns/:campaign_id
  # Frontend page to show details of a campaign
  def show
    # Find the campaign from the slug passed in to us
    @campaign = Campaign.find params[:id]

    # Explicitly pull out the stretch goal description, so we can make
    # the first character lowercase (fits with the UI better)
    # TODO Refactor this into the Campaign model?
    @strgoaldesc = @campaign.strgoaldesc
    @strgoaldesc[0] = @strgoaldesc[0].downcase unless @strgoal.nil?

    render :show
  end

  # GET /campaigns/:campaign_id/share
  # Frontend page where you can share a campaign via social media
  def share
    # Find the relevant campaign by it's slug
    @campaign = Campaign.find params[:id]

    # The base URL that we can tweet from. This opens up a new tweet
    # window on Twiter's website. URL parameters like the actual
    # tweet content are filled in via javascript
    @twitter_link = "https://twitter.com/intent/tweet"
  end
end
