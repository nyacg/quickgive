class SessionsController < ApplicationController
  # POST /sessions
  # {
  #   email: hrickards@gmail.com,
  #   password: foobar
  # }
  def create
    @campaigner = PasswordAuthentication.authenticate params[:email], params[:password]
    if @campaigner
      authenticate @campaigner
      redirect_to root_path
    else
      redirect_to new_session_path, flash: {error: "Invalid email address or password."}
    end
  end

  # GET /sessions/destroy
  def destroy
    deauthenticate
    redirect_to root_path
  end

  # GET /sessions/new
  def new
  end

  def share_create_oauth
    origin = params[:origin] + "&amount=" + params[:amount] + "&description=" + CGI.escape(params[:description])
    redirect_to "/auth/#{params[:provider]}?origin=#{CGI.escape origin}"
  end

  def create_oauth
    auth = request.env["omniauth.auth"]
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

    case auth.provider
    when "twitter", "instagram"
      name_parts = auth.info.name.split " "
      first_name = name_parts.first
      last_name = name_parts[1] || ""
    when "facebook"
      first_name = auth.extra.first_name
      last_name = auth.extra.last_name
    end

    # If loged in, add as authentication method
    if authenticated?
      user = current_user
      ac = auth_class.new(uid: auth.uid)
      ac.access_token = auth.credentials.token if auth.provider == "facebook"
      user.authentications.push ac
      if session.include? :prefilled
        redirect_to new_campaign_path
      else
        redirect_to (request.env['omniauth.origin'] || root_path)
      end
    # Else try and log in
    else
      user = auth_class.authenticate auth.uid
      # Otherwise, see if there's an account to log in as
      if user
        authenticate user
        if session.include? :prefilled
          redirect_to new_campaign_path
        else
          redirect_to root_path
        end
      # Otherwise create a new account, add as authentication method
      else
        # Check if we're a twitter signup donor
        if request.env['omniauth.origin']
          @donor = User.new_donor first_name: first_name, last_name: last_name
          @donor.authentications = [auth_class.create(uid: auth.uid)]
          @donor.authentications[0].access_token = auth.credentials.token if auth.provider == "facebook"
          @donor.save
          authenticate(@donor)
          if session.include? :prefilled
            redirect_to new_campaign_path
          else
            redirect_to request.env['omniauth.origin']
          end
        # Else we're a campaigner
        else
          @campaigner = User.new_campaigner first_name: first_name, last_name: last_name
          @campaigner.authentications = [auth_class.create(uid: auth.uid)]
          @campaigner.authentications[0].access_token = auth.credentials.token if auth.provider == "facebook"
          @campaigner.save
          authenticate(@campaigner)
          if session.include? :prefilled
            redirect_to new_campaign_path
          else
            redirect_to root_path
          end
        end
      end
    end
  end

  def twitter_donate
    redirect_url = url_for(controller: :donors, action: :new, campaign: params[:campaign ], amount: params[:amount])
    redirect_to "/auth/twitter?origin=#{CGI.escape redirect_url}"
  end

  def facebook_donate
    redirect_url = url_for(controller: :donors, action: :new, campaign: params[:campaign ], amount: params[:amount])
    redirect_to "/auth/facebook?origin=#{CGI.escape redirect_url}"
  end
end
