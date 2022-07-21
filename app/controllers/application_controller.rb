class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :null_session

  # before_action :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
