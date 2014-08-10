# Main controller that does things across the whole application
class ApplicationController < ActionController::Base
  # Rails automatically does things to prevent CSRF attacks but it
  # makes API debugging hard so we disabled it.
  # TODO Disabling it is a really bad idea...
  skip_before_filter :verify_authenticity_token

  # Make these methods available in all views as well as all controllers
  helper_method :authenticated?, :current_user, :campaigner?

  # Store a user in the SESSION so we know whether or not they're logged in
  def authenticate(user)
    session[:user] = user.id
  end

  # Remove a user from the SESSION to log them out
  def deauthenticate
    session[:user] = nil
  end

  # See whether a user is in the SESSION to see whether a user is logged in
  def authenticated?
    not session[:user].nil?
  end

  # Is the currently logged in user a campaigner? (as opposed to a donor)
  def campaigner?
    authenticated? and current_user.campaigner?
  end

  # Get the currently logged in user
  def current_user
    authenticated? && User.find(session[:user])
  end

  # Unless there's a user logged in, redirect to the homepage
  def require_authentication!
    redirect_to root_path, flash: {error: "You need to sign in to do that!"} unless authenticated?
  end
end
