class SessionsController < ApplicationController
  # POST /sessions
  # {
  #   email: hrickards@gmail.com,
  #   password: foobar
  # }
  def create
    @campaigner = Campaigner.authenticate params[:email], params[:password]
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
end
