class ApplicationController < ActionController::Base
  #for authorization include pundit
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #devise gem's -- authenticate user before each action
  before_action :authenticate_user!

  #standardize not authorized error redirect to referrer/root with proper flash error
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  #store history
  before_filter :store_history

  private

  def permission_denied
    flash[:error] = "You don't have the proper permissions to view this page. If you think you are supposed to then please contact admin at admin@washbee.com"
    self.response_body = nil
    redirect_to(request.referrer || root_path)
  end

  #method to store history
  def store_history
    session[:history] ||= []
    session[:history].delete_at(0) if session[:history].size >= 5
    session[:history] << request.url
  end
end
