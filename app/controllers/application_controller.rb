class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session
  # TODO This is a really bad idea...
  skip_before_filter :verify_authenticity_token
end
