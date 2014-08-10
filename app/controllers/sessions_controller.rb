# Control everything to do with authenticating (apart from Paypal, that's
# done through PaypalController)
class SessionsController < ApplicationController
  # POST /sessions
  # {
  #   email: hrickards@gmail.com,
  #   password: foobar
  # }
  # Log a user in through password authentication
  def create
    # The PasswordAuthentication model handles the whole authentication process for us
    @campaigner = PasswordAuthentication.authenticate params[:email], params[:password]
    # If the user was logged in successfully
    if @campaigner
      # Store them in the session and redirect back to the homepage
      authenticate @campaigner
      redirect_to root_path
    else
      # Otherwise redirect back to the signin page and give them an error
      redirect_to new_session_path, flash: {error: "Invalid email address or password."}
    end
  end

  # GET /sessions/destroy
  # Log the current user out (works no matter what signin method they used)
  def destroy
    deauthenticate
    redirect_to root_path
  end

  # GET /sessions/new
  # Frontend view for signing in (contains a form for email and passwords that posts to
  # sessions#create, or buttons for signing in with Twitter/Facebook/etc that use the
  # OAuth flows below)
  def new
  end

  # The big one.
  # When a user clicks an OAuth signin/register button, they're redirect to /auth/twitter
  # or similar. This uses the built in OmniAuth logic to get them to authenticate via OAauth
  # and then they're redirect here with various relevant things stored in request.env
  def create_oauth
    # Get information about the authentication
    auth = request.env["omniauth.auth"]

    # Based on the OAuth provider, get the relevant class we'll be using to store
    # authentications
    auth_class =  case auth.provider
                  when "twitter"
                    TwitterAuthentication
                  when "facebook"
                    FacebookAuthentication
                  when "instagram"
                    InstagramAuthentication
                  else
                    raise auth.provider.inspect
                  end

    # Obtain the first name and last name
    case auth.provider
    when "twitter", "instagram"
      # For twitter and instagram, we only get an overall name so we have
      # to split it into first and last name manually. Here it's just done
      # by taking the first and last word.
      # TODO Make this a bit cleverer
      name_parts = auth.info.name.split " "
      first_name = name_parts.first
      last_name = name_parts[1] || ""
    when "facebook"
      # Facebook gives us the first and last name seperately right off the bat
      first_name = auth.extra.first_name
      last_name = auth.extra.last_name
    end

    # If the user's already logged in, add this as a new Authentication method
    if authenticated?
      # Find the logged in user
      user = current_user

      # Create a new Authentication of the relevant child class
      # (e.g., TwitterAuthentication)
      ac = auth_class.new(uid: auth.uid)

      # If the user's just authenticated with Facebook, store the OAauth access
      # token returned so we can access their FB account in the future (for things
      # like sharing campaigns)
      ac.access_token = auth.credentials.token if auth.provider == "facebook"

      # Add the Authentication to the list of the user's Authentications
      user.authentications.push ac
      user.save

      # If there's prefilled data in the session from the form on the first page,
      # redirect the user to create a new campaign
      if session.include? :prefilled
        redirect_to new_campaign_path
      else
        # Otherwise, if there was an origin parameter specifying a redirect URL
        # passed back into the original Omniauth request, redirect there
        # Otherwise redirect back to the homepage
        redirect_to (request.env['omniauth.origin'] || root_path)
      end

    # Otherwise (i.e., the user's not yet logged in), try and log them in
    else
      # Attempt to find a user to log in as
      user = auth_class.authenticate auth.uid
      # If one was find, log them in!
      if user
        authenticate user
        if session.include? :prefilled
          # If we have prefilled data in the session from the front page form,
          # redirect to the new campaign form
          redirect_to new_campaign_path
        else
          # Otherwise redirect straight back to the homepage
          redirect_to root_path
        end

      # Otherwise (i.e., the user has not been created yet), create an account
      # and add the current OAuth authentication as a new Authentication method
      # Otherwise create a new account, add as authentication method
      else
        # There are two discrete cases here:
        # - The user is a donor who's signed up by clicking a link tweeted to
        #     them by our twitter bot. If this is a case, we create them as a
        #     donor.
        # - The user is a campaigner who's signed up by clicking e.g., the
        #     "Register with twitter" button on the user signin page

        # Set the user type
        # TODO: This is a bit of a hack based on the fact that twitter signups
        # send a URL to redirect to as an origin param, whereas campaigner
        # signups don't. While this works perfectly for now, it's rather
        # reliant on this not changing, so we should think of a better way
        # to distinguish between the two cases (or do we even really need to
        # distinguish between them at all?)
        if request.env['omniauth.origin']
          # We're a twitter-signup donor
          @user = User.new_donor first_name: first_name, last_name: last_name
        else
          # We're a new campaigner
          @user = User.new_campaigner first_name: first_name, last_name: last_name
        end

        # Create an Authentication object and add it to the user so they can sign
        # in in the future
        @user.authentications = [auth_class.create(uid: auth.uid)]
        @user.authentications[0].access_token = auth.credentials.token if auth.provider == "facebook"
        @user.save

        # Log in the user
        authenticate(@user)

        if session.include? :prefilled
          # If we have prefilled data from the form on the front page, redirect
          # to the new campaign path so they can carry on signing up
          redirect_to new_campaign_path
        else
          # Otherwise, if there was an origin parameter specifying a redirect URL
          # passed back into the original Omniauth request (there would be with a
          # Twitter-signup donor, but not a campaigner signup), redirect there
          # Otherwise redirect back to the homepage
          redirect_to (request.env['omniauth.origin'] || root_path)
        end
      end
    end
  end

  # Authenticates the user via Twitter as a new donor
  # In the comments above this flow is referred to as a twitter-donor signup
  def twitter_donate
    # Generate a url to donors#new: the page allowing users to authenticate
    # via other methods/PayPal
    redirect_url = url_for(controller: :donors, action: :new, campaign: params[:campaign ], amount: params[:amount])
    # Login with twitter, and redirect to the above page afterwards
    redirect_to "/auth/twitter?origin=#{CGI.escape redirect_url}"
  end

  # Authenticates the user via Facebook as a new donor
  # This isn't used anywhere at the moment, so in the comments above this flow is
  # referred to as a twitter-donor signup
  def facebook_donate
    # Generate a url to donors#new: the page allowing users to authenticate
    # via other methods/PayPal
    redirect_url = url_for(controller: :donors, action: :new, campaign: params[:campaign ], amount: params[:amount])
    # Login with facebook, and redirect to the above page afterwards
    redirect_to "/auth/facebook?origin=#{CGI.escape redirect_url}"
  end
end
