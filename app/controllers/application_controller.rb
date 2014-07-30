class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session
  # TODO This is a really bad idea...
  skip_before_filter :verify_authenticity_token

  helper_method :authenticated?, :current_user, :campaigner?

  def authenticated?
    not session[:user].nil?
  end

  def campaigner?
    authenticated? and current_user.campaigner?
  end

  def authenticate(user)
    session[:user] = user.id
  end

  def deauthenticate
    session[:user] = nil
  end

  def current_user
    authenticated? && User.find(session[:user])
  end

  def require_authentication!
    redirect_to root_path, flash: {error: "You need to sign in to do that!"} unless authenticated?
  end
end
