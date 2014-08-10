# Control campaigners (i.e., the type of user who signed up through the QuickGive
# website without being solicited by a tweet)
class CampaignersController < ApplicationController
  # GET /campaigners/new
  # campaigners/new.html.erb
  # Web form to create a new campaigner
  def new
    # Create a blank Campaigner and PasswordAuthentication so we can base
    # the form fields on these blank objects
    @campaigner = User.new_campaigner
    @campaigner.authentications = [PasswordAuthentication.new]

    # If the user's name was entered on the front page (and consequently stored
    # in the session), prefill it into the form
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
  # Actually create a campaigner
  def create
    # Take out the hash stored under :authentication in params[:user], and use it to
    # create a new PasswordAuthentication
    authentication = PasswordAuthentication.new params[:user].delete(:authentications)

    # From the remaining details in params[:user], create a new campaigner
    @campaigner = User.new_campaigner params[:user]
    # Store the previously-created authentication in that user
    @campaigner.authentications = [authentication]

    # Attempt to save the campaigner
    if @campaigner.save
      # If it worked, log them in
      authenticate @campaigner
      # If we've got some prefilled data (i.e., they came from the front page
      # after entering some details on that form), then take them straight
      # to the new campaign page and prefill in that form
      if session.include? :prefilled
        redirect_to new_campaign_path
      else
        # Otherwise take them back to the homepage
        redirect_to root_path
      end
    else
      # TODO Don't raise errors just because the save attempt failed...
      raise @campaigner.errors.inspect
      render 'new'
    end
  end
end
