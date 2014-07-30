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

  def create_oauth
    auth = request.env["omniauth.auth"]
    auth_class =  case auth.provider
                  when "twitter"
                    TwitterAuthentication
                  when "facebook"
                    FacebookAuthentication
                  else
                    raise auth.provider.inspect
                  end

    # If loged in, add as authentication method
    if authenticated?
      user = current_user
      user.authentications.push auth_class.new(uid: auth.uid)
      redirect_to root_path
    # Else try and log in
    else
      user = auth_class.authenticate auth.uid
      # Otherwise, see if there's an account to log in as
      if user
        authenticate user
        redirect_to root_path
      # Otherwise create a new account, add as authentication method
      else
        @campaigner = User.new_campaigner
        @campaigner.authentications = [auth_class.create(uid: auth.uid)]
        @campaigner.save
        authenticate(@campaigner)
        redirect_to root_path
      end
    end
  end
end
